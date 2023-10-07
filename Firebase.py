import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

cred = credentials.Certificate("/Users/jrai/Downloads/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json")
firebase_admin.initialize_app(cred)
ref = db.reference('/Users/jrai/Documents/GitHub/Vulcan/file_data.json')

# Read data from the database
data = ref.get()
print(data)
