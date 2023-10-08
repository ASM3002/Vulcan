//
//  SMSView.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import SwiftUI
import CoreData

struct SMSPanel: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var phoneNumbers: FetchedResults<PhoneNumber>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.timeStamp, order: .reverse)]) var smsPushes: FetchedResults<SMSPush>
    
    @State private var phoneNumber: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Awaiting Approval")
                .foregroundColor(.theme.white)
                .fontWeight(.semibold)
                .font(.title2)
            Divider()
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    ForEach(smsPushes) { sms in
                        SMSDisplay(sms: sms)
                    }
                }
            }
            Text("Outreach List")
                .foregroundColor(.theme.white)
                .fontWeight(.semibold)
                .font(.title2)
            Divider()
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    ForEach(phoneNumbers) { number in
                        HStack {
                            Text("\(number.phoneNumber ?? "")")
                            Spacer(minLength: 0.0)
                            Image(systemName: "minus.circle")
                                .onTapGesture {
                                    DataController().delete(object: number, context: managedObjContext)
                                    
                                }
                        }
                        Divider()
                    }
                }
            }
            TextField("Enter Phone Number to Add", text: $phoneNumber)
            Button("Submit Number") {
                DataController().addNumber(number: phoneNumber, context: managedObjContext)
                phoneNumber = ""
            }
            .disabled(phoneNumber.count <= 9)
            .disabled(phoneNumber.count > 10)
            .frame(maxWidth: .infinity, alignment: .center)
//            Button("Test AI") {
//                print(ValidationManager().testFireProbability(temp: 40, wind: 8, humidity: 5))
//            }
//            Button("Test SMS") {
//                SMSManager().sendSMS(numbers: phoneNumbers)
//            }
//            Button("Add SMS Push Spoof") {
//                DataController().addSMSPush(severity: 3, subject: "POTENTIAL FIRE NEARBY", message: "Fires have been detected in your area, proceed with caution.", url: nil, context: managedObjContext)
//            }
        }
        .padding(5)
    }
}

#Preview {
    SMSPanel()
}

struct SMSDisplay: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: []) var phoneNumbers: FetchedResults<PhoneNumber>
    @EnvironmentObject var smsManager: SMSManager
    var sms: SMSPush
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(sms.subject ?? "")
                            .font(.headline)
                        Spacer(minLength: 0.0)
                        Text("LVL: \(sms.severity)")
                    }
                    .foregroundColor(.theme.white)
                    HStack(spacing: 0) {
                        Text(sms.timeStamp ?? Date.now, style: .time) +
                        Text(": ") +
                        Text(sms.message ?? "")
                    }
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.theme.lightGray)
                    Text(sms.url ?? "")
                        .foregroundColor(.blue)
                }
                .font(.subheadline)
                VStack(spacing: 15) {
                    Button {
                        smsManager.sendSMS(numbers: phoneNumbers)
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    Button {
                        DataController().delete(object: sms, context: managedObjContext)
                    } label: {
                        Image(systemName: "minus")
                    }
                }
            }
            Divider()
        }
    }
}
