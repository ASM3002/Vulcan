import firebase_admin
from firebase_admin import credentials, firestore
import json

# Initialize Firebase Admin SDK with your service account key
cred = credentials.Certificate('/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json')
firebase_admin.initialize_app(cred)

# Initialize Firestore client
db = firestore.client()

# Define the collection reference where you want to store the data
collection_ref = db.collection('LandSat')  # Replace with the desired Firestore collection name

# Read the JSON data from the existing JSON file
with open("/Users/jrai/Documents/GitHub/Vulcan/file_data.json", "r") as f:
    json_data = json.load(f)


# Add the JSON data to Firestore    
i=0   
for document_id, data in enumerate(json_data):
    if float(json_data[i]['latitude'])>39.3 and float(json_data[i]['latitude'])<40.15 and float(json_data[i]['longitude'])>-122.069 and float(json_data[i]['longitude'])<-121.077: 
        document_ref = collection_ref.add(data)
    i+=1
    
print("Data uploaded to Firestore")


