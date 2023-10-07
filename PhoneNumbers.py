import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Initialize Firebase Admin SDK with your service account key
cred = credentials.Certificate("/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json")  # Replace with the path to your service account key JSON file
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.client()

# Reference to the Firestore collection where you want to store the data
collection_ref = db.collection('PhoneNumber')  # Replace with the desired Firestore collection name

# Data to add to Firestore
data = {
    "phonenumber": "+19168389043",
}

# Add the data to Firestore
doc_ref = collection_ref.add(data)
print(f"Data added with document ID: {doc_ref.id}")
