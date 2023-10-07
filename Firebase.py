import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json

# Initialize Firebase Admin SDK with your service account key
cred = credentials.Certificate("/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json")  # Replace with the path to your service account key JSON file
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://vulcan-203a4.firebaseio.com'  # Replace with your Firebase Realtime Database URL
})

# Read the JSON data from the existing JSON file
with open('/Users/jrai/Documents/GitHub/Vulcan/file_data.json', 'r') as json_file:
    json_data = json.load(json_file)

# Reference to the database location where you want to store the data
ref = db.reference("/")  # Replace with the desired path in your database

# Push the data to the specified location
new_entry = ref.push(json_data)
print(f"Data uploaded with key: {new_entry.key}")

