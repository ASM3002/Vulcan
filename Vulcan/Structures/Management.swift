//
//  Management.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/5/23.
//

import Foundation
import MapKit

struct Management {
    var id = UUID()
    var name: String
    var base: CLLocationCoordinate2D
    var region: [[Float]]
    var timeStamp: Date
}
