# -*- coding: utf-8 -*-
"""
GOES-R Weather Data Polling Script

Created on Sat Oct  7 20:13:48 2023

@author: dmtrm
"""
# GOES-R Dataset Info
import xarray as xr # note: pip install netcdf4 pydap
from matplotlib import pyplot as plt
import numpy as np
import boto3
import fsspec
from botocore import UNSIGNED
from botocore.config import Config

import datetime # use datetime.date, datetime.timedelta
import pandas as pd # to store data nicely
import traceback # to handle errors gracefully & in detail
import time

###############################################################################
# USER INPUTS:    
LATITUDE = [41.429780, 40.343056]   # len(LATITUDE) dictates # locations queried
LONGITUDE = [-81.833320, -123.383056]
LAT_TOL = 0.05
LON_TOL = 0.05

# LST - Land Surface Temp (Skin)
# AOD - Aerosol Optical Depth, COD - Cloud Optical Depth
# Would like to implement Derived Motion Winds as well
VOI_STR = ["LST"]

CSV_NAME = f"GOES-R_" + str(VOI_STR) + "_LAT_" + str(LATITUDE) \
                + "_LON_" + str(LONGITUDE) + "_" + str(int(time.time() * 1e3))

'''
DATES = [(2023, 10, 8), (2020, 10, 8), (2000, 1, 1)]
for ind, _date in enumerate(DATES):
    DATES[ind] = datetime.date(_date[0], _date[1], _date[2])
'''

weather_df = pd.read_csv('Weather.csv')
DATES = weather_df['disc_clean_date'].tolist()
for ind, _date in enumerate(DATES):
    DATES[ind] = datetime.datetime.strptime(_date, "%Y-%m-%d").date()
  
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
# API Function: Get Dataset from GOES-R:
def getDataset(voi_str, year, day, reading=0,  firstlast=-1):
    # First: 0, Last/Most Recent: -1 (for reading of the day)
    
    # Year (YYYY), Day (DDD) of the year, Reading (RR)
    _year = '{:0>4}'.format(year)
    _day = '{:0>3}'.format(day)
    _reading = '{:0>2}'.format(reading)
    
    query_str = f"ABI-L2-{voi_str}F/{_year}/{_day}/{_reading}/" # Get Full Disk projection
    
    ## Set up access to S3 bucket
    s3 = boto3.client('s3', config=Config(signature_version=UNSIGNED))
    paginator = s3.get_paginator("list_objects_v2")
    page_iterator = paginator.paginate(Bucket="noaa-goes16", Prefix=query_str)
    
    for page in page_iterator:
        if not ("Contents" in page):
            print("WARNING: Potentially empty entry. Could fix by selecting different date")
            print("Inspect bin/url here: " + f"https://noaa-goes16.s3.amazonaws.com/index.html#{query_str}")
        
            return None
        else:   # Data exists.
            S3_HEADER = "s3://noaa-goes16/"
            files_mapper = [S3_HEADER + f["Key"] for page in page_iterator for f in page["Contents"]]
                # Note: KeyError: 'Contents' implies that the entry doesn't exist
            
            # open data file
            # libraries needed: netcdf4, pydap
            url = files_mapper[firstlast] +"#mode=bytes"
            ds = xr.open_dataset(url)
        
            return ds


# Get mean VOI for given Latitude, Longitude (assuming only given X, Y from GOES-R projection)
def getMeanVOI(voi_str, ds, query_lat, query_lon,  lat_tol=0.01, lon_tol=0.01):
    # See if we can pull the mapping of (x, y) -> (abi_lat, abi_lon)
    try:
        abi_lat, abi_lon = calculate_degrees(ds)
        
    except Exception as e:    
        traceback.format_stack()
        #print(repr(traceback.extract_stack()))
        #print(repr(traceback.format_stack()))
        
        print("\n...Continuing without VOI: " + str(voi_str))
        return None
    
    # Otherwise, we're good, pull our VOI:    
    # Map desired (lat, lon) to found (x, y):
    abi_x = np.where(np.abs(abi_lon - query_lon) < lon_tol) # Search matching Longitudes
    abi_y = np.where(np.abs(abi_lat - query_lat) < lat_tol)  # Search matching Latitudes

    # Find intersections (X & Y that approximate query_lat/lon)
    matching_x = np.intersect1d(abi_x[0], abi_y[0]) # X Coordinate matches
    matching_y = np.intersect1d(abi_x[1], abi_y[1]) # Y Coordinate matches
    
    #matching_x = matching_x[:, np.newaxis]  # Expand to avoid broadcasting issues w/ np
    matching_y = matching_y[:, np.newaxis]  # Expand to avoid broadcasting issues w/ np

    # At this point, matching_x & y will be more-or-less continguous/monotonically 
    #  increasing arrays. Any combination of matching_x & matching_y will give 
    #  something in tolerance. 
    
    # For some reason we're not always gonna get a variable, so it's good to have a
    #  few points that might get us what we want (otherwise have nan at that pt)
    # So we leave matching_x, matching_y unchanged for our output.

    # Now, get the Variable of Interest
    if voi_str in ds.variables:
        _VOI_Array = ds.variables[voi_str].data[matching_x, matching_y] # Pull intersections
        meanVOI = np.nanmean(_VOI_Array)                                    # Get mean for a representative value
        return meanVOI
    else:
        print(f"ERROR: {voi_str} not present directly. Need different query string internally, implement later")
        print(ds.variables)
        return None

# Get day of year based on date
def getDayOfYear(date_in):
    # Get first day of the year with same year as `date_in`:
    first_date = date_in.replace(month=1, day=1)
    
    # Calculate difference in days between input datetime and first day of year
    delta = date_in - first_date
    
    # Add 1 to account for first day of year itself:
    day = delta.days + 1
    return day

###############################################################################
# Sample of pulling data from GOES-R
# For each date...
outdata = pd.DataFrame(columns=['latitude', 'longitude', 'date'] + [str(i) for i in range(len(VOI_STR))])

# Pull data first:
ds_dict = np.empty((len(DATES), len(VOI_STR)), dtype=object)
for indDate, _date in enumerate(DATES):
    for indVOI, _voi_str in enumerate(VOI_STR):
        # For the user:
        print(f"QUERYING: DATE: {_date}, VOI: {_voi_str}")
        # Pull data:
        day_of_year = getDayOfYear(_date)
        ds_dict[indDate][indVOI] = getDataset(_voi_str, _date.year, day_of_year, 0)
    
# Read data:
for indDate, _date in enumerate(DATES):
    for _ind in range(len(LATITUDE)):
        tmp_lat = LATITUDE[_ind]
        tmp_lon = LONGITUDE[_ind]
        
        voi_arr = []
        for indVOI, _voi_str in enumerate(VOI_STR):
            _ds = ds_dict[indDate][indVOI]
            _voi = getMeanVOI(_voi_str, _ds, tmp_lat, tmp_lon, LAT_TOL, LON_TOL)
            voi_arr.append(_voi)
            print(f"DATE: {_date}\t LAT: {LATITUDE[_ind]}\tLON: {LONGITUDE[_ind]}\tVOI: {_voi}")
            
        tmp_dict = {'latitude': tmp_lat, 'longitude': tmp_lon, 'date': _date}
        tmp_dict.update({key: value for key, value in zip(VOI_STR, voi_arr)})
        
        outdata = pd.concat([outdata, pd.DataFrame([tmp_dict])], ignore_index=True)
        
# Output to CSV
outdata.to_csv(f"./{CSV_NAME}.csv", index=False)