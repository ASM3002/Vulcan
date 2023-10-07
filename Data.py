import requests
import json

# Define the API URL
url = "https://firms.modaps.eosdis.nasa.gov/api/country/json/39698316900e4e7fc292375d74aa88f1/LANDSAT_NRT/USA/1/2023-09-19"

# Make the API request
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Check if the response contains data (not empty)
    if response.text.strip():
        try:
            # Attempt to parse the JSON response data
            json_data = response.json()

            # Save the data to a JSON file
            with open('fire_data.json', 'w') as json_file:
                json.dump(json_data, json_file, indent=4)

            print("Fire data saved to 'fire_data.json'")
        except json.JSONDecodeError as e:
            print(f"Error parsing JSON: {e}")
    else:
        print("The API response is empty.")
else:
    print(f"Error: {response.status_code} - {response.text}")


