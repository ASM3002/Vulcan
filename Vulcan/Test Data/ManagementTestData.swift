//
//  ManagementTestData.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/6/23.
//

import Foundation
import MapKit

class ManagementTestData: ObservableObject {
    @Published var testAccount: Management = Management(name: "Brecksville Fire Dept",
                                                        base: CLLocationCoordinate2D(latitude: 41.31657, longitude: -81.62625),
                                                        region: [CLLocationCoordinate2D(latitude: 41.30788,
                                                                                        longitude: 81.64808),
                                                                 CLLocationCoordinate2D(latitude: 41.34446,
                                                                                        longitude: 81.64911),
                                                                 CLLocationCoordinate2D(latitude: 41.3548,
                                                                                        longitude: 81.58057),
                                                                 CLLocationCoordinate2D(latitude: 41.25675,
                                                                                        longitude: 81.55656),
                                                                 CLLocationCoordinate2D(latitude: 41.25153,
                                                                                        longitude: 81.59553),
                                                                 CLLocationCoordinate2D(latitude: 41.22361,
                                                                                        longitude: 81.64004),
                                                                 CLLocationCoordinate2D(latitude: 41.28153,
                                                                                        longitude: 81.68327)],
                                                        timeStamp: Date.now)
}
