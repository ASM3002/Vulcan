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
for i, data in enumerate(json_data, start=1):
    # Use the document ID from your JSON data or let Firestore auto-generate it
    document_id = data.get('document_id')  # Replace with the actual identifier in your JSON data

    # Reference to the specific document in the collection
    document_ref = collection_ref.document(str(i))

    # Use set with merge=True to update or add the document
    document_ref.set(data, merge=True)

print("Data uploaded to Firestore")


