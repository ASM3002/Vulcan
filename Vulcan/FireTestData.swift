//
//  FireTestData.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/8/23.
//

import Foundation

class FireTestData: ObservableObject {
    @Published var suspect: [Fire_Old] = [
        Fire(longitude: -121.63,
             latitude: 39.37,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 10052023),
             responseStatus: .responding),
        Fire(longitude: -121.38,
             latitude: 39.54,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 10052023),
             responseStatus: .responding)
    ]
    @Published var verified: [Fire_Old] = [
        Fire(longitude: -121.47,
             latitude: 39.65,
             confidence: .low,
             discoveryTS: Date(timeIntervalSince1970: 10052023),
             responseStatus: .verified),
        Fire(longitude: -121.83,
             latitude: 39.69,
             confidence: .low,
             discoveryTS: Date(timeIntervalSince1970: 10052023),
             responseStatus: .verified)
    ]
    @Published var responding: [Fire_Old] = [
        Fire(longitude: -121.8527,
             latitude: 39.739868,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 10052023),
             responseStatus: .responding),
        Fire(longitude: -121.83,
             latitude: 39.69,
             confidence: .low,
             discoveryTS: Date(timeIntervalSince1970: 10052023),
             responseStatus: .responding)
    ]
}
