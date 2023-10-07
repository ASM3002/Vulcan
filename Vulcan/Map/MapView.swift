//
//  MapView.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/20/23.
//

/*import SwiftUI
import MapKit

struct MapView: NSViewRepresentable {
    typealias NSViewType = MKMapView
    
    @EnvironmentObject var mapData: MapManager
    @EnvironmentObject var manTestData: ManagementTestData
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeNSView(context: Context) -> MKMapView {
        let view = mapData.mapView
        
        view.showsUserLocation = true
        view.delegate = context.coordinator
        view.mapType = mapData.mapType
        //Compass Configuration
        view.showsCompass = true
        let compass = MKCompassButton(mapView: view)
        compass.frame.origin = CGPoint(x: 25, y: 25)
        compass.compassVisibility = .visible
        view.addSubview(compass)
        return view
    }
    
    func updateNSView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            //Custom Pins...
            //Excluding User Blue Circle...
            if annotation.isKind(of: MKUserLocation.self) {return nil}
            else {
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true
                
                return pinAnnotation
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
              let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = NSColor(Color.theme.lightGray)
              renderer.lineWidth = 4
              return renderer
            }

            return MKOverlayRenderer()
        }
    }
}*/
