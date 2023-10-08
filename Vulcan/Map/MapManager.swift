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
    
    func focusSpecificLocation(location: CLLocationCoordinate2D) {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: maxCoordinateDist()[0], longitudinalMeters: maxCoordinateDist()[1])
            
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
        print("Polyline has been  set")
        let overlay: MKOverlay = polyline
        mapView.addOverlay(overlay)
        print("Overlay added to map")
    }
    
    func formattedServiceRegion() -> [CLLocationCoordinate2D] {
        let array = ManagementTestData().testAccount.region
        var newArray: [CLLocationCoordinate2D] = []
        for coord in array {
            let clCoord = CLLocationCoordinate2D(latitude: CLLocationDegrees(coord[1]), longitude: CLLocationDegrees(coord[0]))
            newArray.append(clCoord)
        }
        if array.count > 0 {
            let first = newArray[0]
            newArray.append(first)
        }
        return newArray
    }
    
    func maxCoordinateDist() -> [Double] {
        let region = formattedServiceRegion()
        var minLong = region[0].longitude
        var maxLong = region[0].longitude
        var minLat = region[0].latitude
        var maxLat = region[0].latitude
        for coord in region {
            if coord.longitude > maxLong {
                maxLong = coord.longitude
            }
            if coord.longitude < minLong {
                minLong = coord.longitude
            }
            if coord.latitude > maxLat {
                maxLat = coord.latitude
            }
            if coord.latitude < minLat {
                minLat = coord.latitude
            }
        }
        let latRange = maxLat - minLat
        let longRange = maxLong - minLong
        return[latRange*111139,longRange*111139]
    }
    
    func addBaseAnnotation(coord: CLLocationCoordinate2D) {
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coord
        pointAnnotation.title = "HQ"
        mapView.addAnnotation(pointAnnotation)
    }
    
    func addFireAnnotations(fires: [Fire_Old]) {
        for fire in fires {
            var ann = MKPointAnnotation()
            ann.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(fire.latitude), longitude: CLLocationDegrees(fire.longitude))
            ann.title = fire.responseStatus.rawValue.capitalized
            mapView.addAnnotation(ann)
        }
        
    }
}
