# -*- coding: utf-8 -*-
"""
Weather Data Pulling Script

Created on Sat Oct  7 16:38:49 2023

"""
# For data analysis:
import pandas as pd
import numpy as np

# Pull data
import json
import requests
import datetime   # For reformatting, for API requests

###############################################################################
# User Inputs:
weatherAPIKey = "e25bb10ced064b3aad9195242230710"

###############################################################################

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

# Stores Object in `name`, locally.
def storeData(obj, name):
    '''
    file_path = os.path.join(save_directory, 'fire_data.csv')

    # Save the data to a CSV file in the specified directory
    with open(file_path, 'w', newline='') as csv_file:
        csv_file.write(csv_data)
    '''
    
# Pull Weather Frame to feed into ML Training Alg
def pullWeatherFrame(lat, long, date_tuple):
    # Instantiate Date object:
    date = datetime.date(date_tuple[0], date_tuple[1], date_tuple[2])    #(Y, M, D)
    
    # 7 Days Ago:
    date -= datetime.timedelta(days=7)
    weather_7 = pullWeatherData(lat, long, date.strftime("%Y-%m-%d"))
    data_7 = weather_7["data"]
    
    # 15 Days Ago:
    date -= datetime.timedelta(days=8)
    weather_15 = pullWeatherData(lat, long, date.strftime("%Y-%m-%d"))
    data_15 = weather_15["data"]
    
    date += datetime.timedelta(days=7)
    date += datetime.timedelta(days=8)  # ew ew ew
    out_date = str(date.year) + "-" + str(date.month) + "-" + str(date.day) #YYYY-MM-DD
    
    # Same format as FireWeather data:
    out = {"latitude": lat, "longitude": long, 
           "disc_clean_date": out_date,\
           "Temp_pre_15": data_15["avgtemp_c"], "Temp_pre_7":   data_7["avgtemp_c"],\
           "Wind_pre_15": data_15["maxwind_kph"], "Wind_pre_7": data_7["maxwind_kph"],\
           "Hum_pre_15":  data_15["avghumidity"], "Hum_pre_7":  data_7["avghumidity"],\
           "Prec_pre_15": data_15["totalprecip_mm"], "Prec_pre_7": data_7["totalprecip_mm"],\
        }
    
    return out

example = pullWeatherFrame(40.343056, -123.383056, (2023,7,31))