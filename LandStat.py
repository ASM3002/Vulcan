import csv
import json
import firebase_admin
from firebase_admin import credentials, firestore
import json

def jsonConversion(csv_file_path,json_file_path):
    #csv_file_path = '/Users/jrai/Documents/GitHub/Vulcan/fire_data.csv'  # Replace with the path to your CSV file
    #json_file_path = '/Users/jrai/Documents/GitHub/Vulcan/file_data.json'  # Output JSON file path

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

jsonConversion("/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_24h.csv","/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_24h.json")
jsonConversion("/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_48h.csv","/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_48h.json")
jsonConversion("/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_7d.csv","/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_7d.json")

files=['/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_24h.json','/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_48h.json','/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii_7d.json']

def merge_JsonFiles(filename):
    result = list()
    for f1 in filename:
        with open(f1, 'r') as infile:
            result.extend(json.load(infile))

    with open('/Users/jrai/Documents/GitHub/Vulcan/LANDSAT_USA_contiguous_and_Hawaii.json', 'w') as output_file:
        json.dump(result, output_file)

merge_JsonFiles(files)

cred = credentials.Certificate('/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json')
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.client()

# Define the collection reference where you want to store the data
collection_ref = db.collection('LandSat')  # Replace with the desired Firestore collection name

# Read the JSON data from the existing JSON file
with open("LANDSAT_USA_contiguous_and_Hawaii.json", "r") as f:
    json_data = json.load(f)

# Add the JSON data to Firestore
for i, data in enumerate(json_data, start=1):
    # Use the document ID from your JSON data or let Firestore auto-generate it
    document_id = data.get('document_id')  # Replace with the actual identifier in your JSON data

    # Reference to the specific document in the collection
    document_ref = collection_ref.document(str(i))

    # Use set with merge=True to update or add the document
    document_ref.set(data, merge=True)


print("Data uploaded to Firestore")

