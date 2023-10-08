import smtplib
from email.message import EmailMessage
import sys

input_data = sys.stdin.read()
print(input_data)
contactnumbers = input_data.split(',')

def sms_alert(subject, body, contactnumbers):
    user = "ArielSMSAlert@gmail.com"
    password = "kphdpdishjzwfiuo"

    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(user, password)

    serviceproviders = [
    '@txt.att.net',                 #At&t
    '@messaging.sprintpcs.com',     #Sprint
    '@tmomail.net',                 #T-Mobile
    '@vtext.com',                   #Verizon
    ]
    
    for ContactNumberCount in contactnumbers:
        print("Alert was sent to " + ContactNumberCount)
        for ServiceProvidersCount in serviceproviders:
            contactpoint = ContactNumberCount + ServiceProvidersCount
            #print("Alert was sent to " + ContactNumberCount + ServiceProvidersCount)
            msg = EmailMessage()
            msg.set_content(body)
            msg['subject'] = subject
            msg['from'] = user
            msg['to'] = contactpoint
            server.send_message(msg)
    server.quit()
    
    print("The alerts were sent.")