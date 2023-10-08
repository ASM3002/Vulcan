//
//  Fire.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/5/23.
//

import Foundation

struct Fire_Old: Identifiable {
    var id = UUID()
    var longitude: Float
    var latitude: Float
    var confidence: FireConfidence
    var discoveryTS: Date
    var responseStatus: ResponseStatus
}

enum ResponseStatus: String {
    case suspect, verified, responding
}

enum FireConfidence: String {
    case low, medium, high
}
