import firebase_admin
from firebase_admin import credentials
import requests

# Initialize Firebase Admin SDK
cred = credentials.Certificate("/Users/jrai/Documents/GitHub/Vulcan/vulcan-203a4-firebase-adminsdk-j79bb-014b7ab941.json")  # Replace with your service account key path
firebase_admin.initialize_app(cred)

# Replace with your Firebase Web API Key
firebase_web_api_key = "AIzaSyAB-cHpVhOI54TItTGWE9kOECXwHayky90"

# User's phone number to verify
phone_number = "+19168389043"  # Replace with the user's phone number

# Generate a verification code and send it via SMS
verification_code = "123456"  # Replace with a generated verification code
message = f"Your verification code is {verification_code}"

# Firebase Phone Authentication API URL
firebase_auth_url = f"https://identitytoolkit.googleapis.com/v1/accounts:sendVerificationCode?key={firebase_web_api_key}"

# Data to send in the POST request
data = {
    "phoneNumber": phone_number,
    "recaptchaToken": "RECAPTCHA_TOKEN",  # Replace with your Recaptcha token (optional)
    "iosBundleId": "IOS_BUNDLE_ID",  # Replace with your iOS bundle ID (optional)
    "androidPackageName": "ANDROID_PACKAGE_NAME",  # Replace with your Android package name (optional)
    "message": message,
    "languageCode": "en"  # Replace with the desired language code
}

# Send the verification code
response = requests.post(firebase_auth_url, json=data)

# Check the response
if response.status_code == 200:
    print("Verification code sent successfully.")
else:
    print(f"Error: {response.status_code} - {response.text}")
