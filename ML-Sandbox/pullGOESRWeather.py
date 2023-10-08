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

# set up access to S3 bucket
s3 = boto3.client('s3', config=Config(signature_version=UNSIGNED))
paginator = s3.get_paginator("list_objects_v2")
page_iterator = paginator.paginate(Bucket="noaa-goes16", Prefix="ABI-L2-LSTF/2023/281/01/") 

S3_HEADER = "s3://noaa-goes16/"
files_mapper = [S3_HEADER + f["Key"] for page in page_iterator for f in page["Contents"]]

# open data file
# libraries needed: netcdf4, pydap
url_blue = files_mapper[0] +"#mode=bytes"
ds_blue = xr.open_dataset(url_blue)

print(ds_blue)
ds_blue["LST"].plot()
