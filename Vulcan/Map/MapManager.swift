//
//  MapManager.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

//
//  LocationServiceProvider.swift
//  Headacre
//
//  Created by Aiden McDougal on 5/16/23.
//

import MapKit
import SwiftUI
//import LocationFormatter

enum LocationDetails {
    static let initialLocation = CLLocationCoordinate2D(latitude: 41.41568, longitude: -81.85949)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    static let defaultDist: CLLocationDistance = 100
}

class MapManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    
    @Published var region: MKCoordinateRegion!
    //Alert
    @Published var permissionDenied: Bool = false
    @Published var confirmRemoval: Bool = false
    //Map Type
    @Published var mapType: MKMapType = .hybrid
    //Zoom Factor
    //MapZoom
    @Published var zoomFactor: CLLocationDistance = 100
    //Service Area Outline
    @Published var serviceRegion: [CLLocationCoordinate2D] = []
    
    //Coord Format
    //@Published var coordinateType: CoordinateType = .dms
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // here you call the function that manages the location rights at the app launch
        checkLocationAuthorization(manager)
    }
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorization(manager)
//    }
    
    private func checkLocationAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            //Requesting...
            manager.requestAlwaysAuthorization()
        case .restricted:
            print("Location is restricted.  Allow location Authorization is Settings to use feature.")
        case .denied:
            //Alert
            permissionDenied.toggle()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: self.zoomFactor, longitudinalMeters: self.zoomFactor)
        
        self.mapView.setRegion(self.region, animated: true)
        
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
    
    func updateMapType() {
        mapView.mapType = mapType
    }
    
    func focusLocation() {
        guard let _ = region else {return}
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    //MARK: MAP DATA MANAGEMENT FUNCTIONS
    func drawMapItems() { //Not including Annotations(Pins)
        mapView.removeOverlays(mapView.overlays)
        print("Overlay removed")
        //Draw Perim
        let region = formattedServiceRegion()
        print("Region has been set")
        let polyline = MKPolyline(coordinates: region, count: region.count)
        let overlay: MKOverlay = polyline
        mapView.addOverlay(overlay)
    }
    
    func formattedServiceRegion() -> [CLLocationCoordinate2D] {
        var array = self.serviceRegion
        if array.count > 0 {
            let first = array[0]
            array.append(first)
        }
        return array
    }
}
