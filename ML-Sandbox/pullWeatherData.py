# -*- coding: utf-8 -*-
"""
Weather Data Pulling Script

Created on Sat Oct  7 16:38:49 2023

"""
# Pull data
import json
import requests
import datetime   # For reformatting, for API requests

# Store data
import pandas as pd

###############################################################################
# User Inputs:
weatherAPIKey = "e25bb10ced064b3aad9195242230710"       # WeatherAPI key
LATITUDE = 40.343056
LONGITUDE = -123.383056

from datetime import datetime, timedelta

# Get the current date
current_date = datetime.today() + timedelta(days=1)

# Initialize an empty list to store the dates
DATES = []

# Calculate the date from exactly one year ago
one_year_ago = current_date - timedelta(days=(360 - 16))

# Loop through the past year and add each date to the list
while one_year_ago < current_date:
    year = one_year_ago.year
    month = one_year_ago.month
    day = one_year_ago.day
    DATES.append(one_year_ago)
    # DATES.append((year, month, day))
    
    # Move to the next day
    one_year_ago += timedelta(days=1)

# balls = datetime.date(DATES[0][0], DATES[0][1], DATES[0][2])
# print(balls)
# input("Balls?")
    
OUTPUTFILENAME = f"WeatherAPI_LAT_{LATITUDE}_LON_{LONGITUDE}" #.csv

###############################################################################
# Data Storage Scripts:
# Stores Object in `name`, locally.
def storeListOfDictsCSV(list_of_dicts, name):
    df = pd.DataFrame(list_of_dicts) 
    df.to_csv(f"./{name}.csv", index=False)

# Pulls dict of dicts:
def getListOfDictsCSV(name):
    df = pd.read_csv(f"./{name}.csv")
    list_of_dictionaries = df.to_dict('records')
    return list_of_dictionaries

###############################################################################
# Weather API Scripts:
# Pull JSON Data w/ Python
def requestAPI(req):
    # Make API request:
    response = requests.get(req)
    
    # Check if the request was successful (status code 200)
    if response.status_code == 200:
        # Check if the response contains data (not empty)
        if response.text.strip():
            try:
                # Attempt to parse the JSON response data
                json_data = response.json()
                
                return json_data
            
            except json.JSONDecodeError as e:
                print(f"Error parsing JSON: {e}")
                
                return None
        else:
            print("The API response is empty.")
    else:
        print(f"Error: {response.status_code} - {response.text}")

# Pull Weather from WeatherAPI, return dict.
def pullWeatherData(lat, long, date=None):
    # Note: data="YYYY-MM-DD" on/after 2010-01-01
    q = str(lat) + "," + str(long)
    
    baseURL = "http://api.weatherapi.com/v1/"
    
    if not date:    # Current
        req = baseURL + "current.json?key=" + str(weatherAPIKey) \
                + "&q=" + str(q) + "&aqi=no"
    else:           # Historical
        req = baseURL + "history.json?key=" + str(weatherAPIKey) \
                + "&q=" + str(q) + "&dt=" + str(date)
    
    # Request the Data
    weatherData = requestAPI(req)
    
    if not weatherData:
        print("DATA UNAVAIALABLE. INPUTTING NULL.")
        weatherData = {"location": {}, "data": {}}
    
    # Package to output:
    if not date:
        out = {"location": weatherData["location"], \
               "data": weatherData["current"]}
    else:
        out = {"location": weatherData["location"], \
               "data": weatherData["forecast"]["forecastday"][0]["day"]}
    
    return out
    
# Pull Weather Frame to feed into ML Training Alg
#example = pullWeatherFrame(40.343056, -123.383056, (2023,7,31))
def pullWeatherFrame(lat, long, date):
    # Instantiate Date object:
    # date = datetime.date(date_tuple[0], date_tuple[1], date_tuple[2])    #(Y, M, D)
    
    # 0 Days Ago:
    weather_0 = pullWeatherData(lat, long, date.strftime("%Y-%m-%d"))
    data_0 = weather_0["data"]        
    
    # 7 Days Ago:
    date -= timedelta(days=7)
    weather_7 = pullWeatherData(lat, long, date.strftime("%Y-%m-%d"))
    data_7 = weather_7["data"]
    
    # 15 Days Ago:
    date -= timedelta(days=8)
    weather_15 = pullWeatherData(lat, long, date.strftime("%Y-%m-%d"))
    data_15 = weather_15["data"]
    
    date += timedelta(days=7)
    date += timedelta(days=8)  # ew ew ew
    out_date = str(date.year) + "-" + str(date.month) + "-" + str(date.day) #YYYY-MM-DD
    
    # Same format as FireWeather data:
    out = {"latitude": lat, "longitude": long,                                      \
           "disc_clean_date": out_date,                                             \
           "Temp_pre_15": data_15["avgtemp_c"], "Temp_pre_7":   data_7["avgtemp_c"],\
           "Wind_pre_15": data_15["maxwind_mph"], "Wind_pre_7": data_7["maxwind_mph"],\
           "Hum_pre_15":  data_15["avghumidity"], "Hum_pre_7":  data_7["avghumidity"],\
           "Prec_pre_15": data_15["totalprecip_in"], "Prec_pre_7": data_7["totalprecip_in"],\
           
           "Temp": data_0["avgtemp_c"],     \
           "Wind": data_0["maxwind_mph"],   \
           "Hum":  data_0["avghumidity"],   \
           "Prec": data_0["totalprecip_in"] \
        }
    
    return out

###############################################################################
'''
# Sample Storing:
outdata = []
for date in DATES:
    # formatted_date = datetime.date(_date[0], _date[1], _date[2]) 
    print(date)
    outdata.append(pullWeatherFrame(LATITUDE, LONGITUDE, date))
    
# Data's ready, store it:
storeListOfDictsCSV(outdata, OUTPUTFILENAME)
'''
# Sample Retrieval:
indata = getListOfDictsCSV(OUTPUTFILENAME)