# -*- coding: utf-8 -*-
"""
GOES-R Weather Data Polling Script

Created on Sat Oct  7 20:13:48 2023

@author: dmtrm
"""
# import packages
import xarray as xr # note: pip install netcdf4 pydap
from matplotlib import pyplot as plt
import numpy as np
import boto3
import fsspec
from botocore import UNSIGNED
from botocore.config import Config

from netCDF4 import Dataset

###############################################################################
# External Packages:
'''

Massive thanks to:
    the NOAA/NESDIS/STAR Aerosols and Atmospheric Composition Science Team!

https://www.star.nesdis.noaa.gov/atmospheric-composition-training/python_abi_lat_lon.php
https://www.star.nesdis.noaa.gov/atmospheric-composition-training/satellite_data_goes_imager_projection.php

'''
import numpy as np

# Calculate latitude and longitude from GOES ABI fixed grid projection data
# GOES ABI fixed grid projection is a map projection relative to the GOES satellite
# Units: latitude in °N (°S < 0), longitude in °E (°W < 0)
# See GOES-R Product User Guide (PUG) Volume 5 (L2 products) Section 4.2.8 for details & example of calculations
# "file_id" is an ABI L1b or L2 .nc file opened using the netCDF4 library

def calculate_degrees(file_id):
    # Read in GOES ABI fixed grid projection variables and constants
    x_coordinate_1d = file_id.variables['x'][:]  # E/W scanning angle in radians
    y_coordinate_1d = file_id.variables['y'][:]  # N/S elevation angle in radians
    projection_info = file_id.variables['goes_imager_projection'].attrs   ## Need to access dict-like
    lon_origin = projection_info['longitude_of_projection_origin']
    H = projection_info['perspective_point_height']+projection_info['semi_major_axis']
    r_eq = projection_info['semi_major_axis']
    r_pol = projection_info['semi_minor_axis']
    
    # Create 2D coordinate matrices from 1D coordinate vectors
    x_coordinate_2d, y_coordinate_2d = np.meshgrid(x_coordinate_1d, y_coordinate_1d)
    
    # Equations to calculate latitude and longitude
    lambda_0 = (lon_origin*np.pi)/180.0  
    a_var = np.power(np.sin(x_coordinate_2d),2.0) + (np.power(np.cos(x_coordinate_2d),2.0)*(np.power(np.cos(y_coordinate_2d),2.0)+(((r_eq*r_eq)/(r_pol*r_pol))*np.power(np.sin(y_coordinate_2d),2.0))))
    b_var = -2.0*H*np.cos(x_coordinate_2d)*np.cos(y_coordinate_2d)
    c_var = (H**2.0)-(r_eq**2.0)
    r_s = (-1.0*b_var - np.sqrt((b_var**2)-(4.0*a_var*c_var)))/(2.0*a_var)
    s_x = r_s*np.cos(x_coordinate_2d)*np.cos(y_coordinate_2d)
    s_y = - r_s*np.sin(x_coordinate_2d)
    s_z = r_s*np.cos(x_coordinate_2d)*np.sin(y_coordinate_2d)
    
    # Ignore numpy errors for sqrt of negative number; occurs for GOES-16 ABI CONUS sector data
    np.seterr(all='ignore')
    
    abi_lat = (180.0/np.pi)*(np.arctan(((r_eq*r_eq)/(r_pol*r_pol))*((s_z/np.sqrt(((H-s_x)*(H-s_x))+(s_y*s_y))))))
    abi_lon = (lambda_0 - np.arctan(s_y/(H-s_x)))*(180.0/np.pi)
    
    return abi_lat, abi_lon

###############################################################################
# Pull Data from GOES-R:
# USER INPUTS:
LATITUDE = 41.429780#40.343056
LONGITUDE = -81.833320#-123.383056
TOL_LAT = 0.01
TOL_LON = 0.01

# LST - Land Surface Temp (Skin), DMW (Derived Motion Winds) - no x, y only lat lon
VOI_STR = "LST"

## Set up access to S3 bucket
s3 = boto3.client('s3', config=Config(signature_version=UNSIGNED))
paginator = s3.get_paginator("list_objects_v2")
page_iterator = paginator.paginate(Bucket="noaa-goes16", Prefix=f"ABI-L2-{VOI_STR}F/2023/281/01/")

S3_HEADER = "s3://noaa-goes16/"
files_mapper = [S3_HEADER + f["Key"] for page in page_iterator for f in page["Contents"]]

# open data file
# libraries needed: netcdf4, pydap
url = files_mapper[0] +"#mode=bytes"
ds = xr.open_dataset(url)

## Pull mapping of (x, y) -> (abi_lat, abi_lon)
_abi_lat, _abi_lon = calculate_degrees(ds)
abi_lat = np.ma.array(_abi_lat, mask=np.isnan(_abi_lat)) # Use a mask to mark the NaNs
abi_lon = np.ma.array(_abi_lon, mask=np.isnan(_abi_lon)) # Use a mask to mark the NaNs
# Map desired (lat, lon) to found (x, y):
abi_x = np.where(np.abs(abi_lon - LONGITUDE) < TOL_LON) # Search matching Longitudes
abi_y = np.where(np.abs(abi_lat - LATITUDE) < TOL_LAT)  # Search matching Latitudes

# Find intersections
matching_x = np.intersect1d(abi_x[0], abi_y[0]) # X Coordinate matches
matching_y = np.intersect1d(abi_x[1], abi_y[1]) # Y Coordinate matches

# At this point, matching_x & y will be more-or-less continguous/monotonically 
#  increasing arrays. Any combination of matching_x & matching_y will give 
#  something in tolerance. 
# For some reason we're not always gonna get a variable, so it's good to have a
#  few points that might get us what we want (otherwise have nan at that pt)

# Now, get the Variable of Interest
_VOI_Array = ds.variables[VOI_STR].data[matching_x, matching_y] # Pull intersections
VOI = np.nanmean(_VOI_Array)                                    # Get mean for a representative value
VOI_F = (VOI - 273.15) * 9/5 + 32
VOI_C = (VOI - 273.15)
print(VOI, VOI_F, VOI_C)
ds[VOI_STR].plot()

