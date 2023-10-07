import requests
import csv
import json
import os  # Import the 'os' module for working with file paths

# Define the API URL
url = "https://firms.modaps.eosdis.nasa.gov/api/country/csv/39698316900e4e7fc292375d74aa88f1/LANDSAT_NRT/USA/1/2023-09-19"

# Specify the directory where you want to save the file
save_directory = "/Users/jrai/Documents/GitHub/Vulcan"  # Replace with the actual directory path

# Make the API request
response = requests.get(url)

# Check if the request was successful (status code 200)
if response.status_code == 200:
    # Parse the CSV response data
    csv_data = response.text

    # Specify the full file path
    file_path = os.path.join(save_directory, 'fire_data.csv')

    # Save the data to a CSV file in the specified directory
    with open(file_path, 'w', newline='') as csv_file:
        csv_file.write(csv_data)

    print(f"Fire data saved to '{file_path}'")
else:
    print(f"Error: {response.status_code} - {response.text}")


# Read CSV data from a file
csv_file_path = '/Users/jrai/Documents/GitHub/Vulcan/fire_data.csv'  # Replace with the path to your CSV file
json_file_path = '/Users/jrai/Documents/GitHub/Vulcan/file_data.json'  # Output JSON file path

csv_data = []

with open(csv_file_path, 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    for row in csv_reader:
        csv_data.append(row)

# Convert CSV data to JSON
json_data = json.dumps(csv_data, indent=4)

# Save the JSON data to a file
with open(json_file_path, 'w') as json_file:
    json_file.write(json_data)

print(f"CSV data converted to JSON and saved to '{json_file_path}'")

