#SMS Alerts using Python and Gmail
#LJ Giron 10/8/2023

import smtplib
from email.message import EmailMessage
import sys

input_data = sys.stdin.read()
print(input_data)
contactNumbers = input_data.split(",")

def sms_alert(subject, body, contactNumbers):
    user = "ArielSMSAlert@gmail.com"
    password = "kphdpdishjzwfiuo"

    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(user, password)

    serviceProviders = [
    '@txt.att.net',                 #At&t
    '@messaging.sprintpcs.com',     #Sprint
    '@tmomail.net',                 #T-Mobile
    '@vtext.com',                   #Verizon
    ]
    
    for contact in range(len(contactNumbers)-1):
        print("Alert was sent to " + contactNumbers[contact])
        for provider in serviceProviders:
            contactPoint = contactNumbers[contact] + provider
            #print("Alert was sent to " + ContactNumberCount + ServiceProvidersCount)
            msg = EmailMessage()
            msg.set_content(body)
            msg['subject'] = subject
            msg['from'] = user
            msg['to'] = contactpoint
            server.send_message(msg)
    server.quit()

sms_alert("Fire Alert", contactNumbers[-1], contactNumbers)

print("The alerts were sent.")
