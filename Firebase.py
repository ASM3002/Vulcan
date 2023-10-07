import firebase_admin
from firebase_admin import credentials, firestore
import json

# Initialize Firebase Admin SDK with your service account key
cred = credentials.Certificate('/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json')
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.client()

# Define the collection reference where you want to store the data
collection_ref = db.collection('FirmsData')  # Replace with the desired Firestore collection name

# Read the JSON data from the existing JSON file
with open("/Users/jrai/Documents/GitHub/Vulcan/file_data.json", "r") as f:
    json_data = json.load(f)

# Add the JSON data to Firestore
for document_id, data in enumerate(json_data):
    # You can use a custom document ID or let Firestore auto-generate one
    # In this example, we let Firestore auto-generate the document ID
    # If you want to specify a custom ID, use collection_ref.document('custom_id').set(data) instead
    document_ref = collection_ref.add(data)

print("Data uploaded to Firestore")


