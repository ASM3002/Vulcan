//
//  FireTestData.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/5/23.
//

import Foundation

class FireTestData: ObservableObject {
    @Published var suspect: [Fire_Old] = [
        Fire_Old(longitude: -121.63,
                 latitude: 39.77,
                 confidence: .high,
                 discoveryTS: Date(timeIntervalSince1970: 1696767324),
                 responseStatus: .suspect),
        Fire_Old(longitude: -121.38,
                 latitude: 39.54,
                 confidence: .high,
                 discoveryTS: Date(timeIntervalSince1970: 1696760124),
                 responseStatus: .suspect)
    ]
    @Published var verified: [Fire_Old] = [
        Fire_Old(longitude: -121.47,
                 latitude: 39.65,
                 confidence: .low,
                 discoveryTS: Date(timeIntervalSince1970: 1696741704),
                 responseStatus: .verified),
        Fire_Old(longitude: -121.83,
                 latitude: 39.57,
                 confidence: .low,
                 discoveryTS: Date(timeIntervalSince1970: 1696735824),
                 responseStatus: .verified)
    ]
    @Published var tending: [Fire_Old] = [
        Fire_Old(longitude: -121.8527,
             latitude: 39.739868,
             confidence: .high,
             discoveryTS: Date(timeIntervalSince1970: 1696707924),
             responseStatus: .responding),
        Fire_Old(longitude: -121.83,
             latitude: 39.69,
             confidence: .low,
             discoveryTS: Date(timeIntervalSince1970: 1696640724),
             responseStatus: .responding)
    ]
}
