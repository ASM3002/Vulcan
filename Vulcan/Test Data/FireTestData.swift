//
//  FireTestData.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/5/23.
//

import Foundation

class FireTestData: ObservableObject {
    @Published var suspect: [Fire] = [
        Fire(longitude: 42.20,
             latitude: 38.98,
             confidence: .low,
             discoveryTS: Date(timeIntervalSince1970: 12345506),
             responseStatus: .suspect),
        Fire(longitude: 42.20,
             latitude: 38.98,
             confidence: .medium,
             discoveryTS: Date(timeIntervalSince1970: 12345506),
             responseStatus: .suspect)
    ]
    @Published var verified: [Fire] = [
        Fire(longitude: 42.20,
             latitude: 38.98,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 12345506),
             responseStatus: .verified),
        Fire(longitude: 42.20,
             latitude: 38.98,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 12345506),
             responseStatus: .verified)
    ]
    @Published var tending: [Fire] = [
        Fire(longitude: 42.20,
             latitude: 38.98,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 12345506),
             responseStatus: .tending)
    ]
}
