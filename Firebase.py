import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import json

# Fetch the service account key JSON file contents
cred = credentials.Certificate('/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json')
# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': "https://vulcan-203a4-default-rtdb.firebaseio.com/"
})

ref = db.reference('/')
with open("/Users/jrai/Documents/GitHub/Vulcan/file_data.json", "r") as f:
	file_contents = json.load(f)
ref.set(file_contents)

