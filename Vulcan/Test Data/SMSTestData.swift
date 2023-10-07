//
//  FleetTestData.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/5/23.
//

import Foundation

class SMSTestData: ObservableObject {
    @Published var smsPushes: [SMSPush] = [
        SMSPush(severity: 3, 
                subject: "SUBJECT 1",
                message: "This is a test push notification. Do not be alarmed",
                url: "This is the clickableURL",
                timeStamp: Date.now),
        SMSPush(severity: 3,
                subject: "SUBJECT 2",
                message: "This is a test push notification. Do not be alarmed",
                url: "This is the clickableURL",
                timeStamp: Date.now),
        SMSPush(severity: 3,
                subject: "SUBJECT 3",
                message: "This is a test push notification. Do not be alarmed",
                url: "This is the clickableURL",
                timeStamp: Date.now)
    ]
}
