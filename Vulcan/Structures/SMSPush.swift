//
//  SMSPush.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import Foundation

struct SMSPush: Identifiable {
    var id = UUID()
    
    var severity: Int
    var subject: String
    var message: String
    var url: String?
    
    var timeStamp: Date
}
