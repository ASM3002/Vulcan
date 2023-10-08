//
//  ContentView.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/19/23.
//

import SwiftUI
import MapKit

struct MainView: View {
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var manTestData: ManagementTestData
    @EnvironmentObject var mapManager: MapManager
    @EnvironmentObject var fireTestData: FireTestData
    @EnvironmentObject var smsManager: SMSManager
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @Environment(\.managedObjectContext) var managedObjContext
    
    @State var locationManager = CLLocationManager()
    
    var body: some View {
        NavigationView {
            PanelView()
            MapView()
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: { // 1
                    Image(systemName: "sidebar.leading")
                })
            }
            ToolbarItem(placement: .principal) {
                NavigationBarView()
            }
        }
        .navigationTitle("\(manTestData.testAccount.name)")
        .onAppear {
            print("TEST")
            //Set Delegate
            locationManager.delegate = mapManager
            locationManager.requestAlwaysAuthorization()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                //Load Region Overlay
                print("Attempting Overlay Load")
                mapManager.drawMapItems()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                //Focus Location
                print("Attempting to focus location")
                mapManager.focusSpecificLocation(location: CLLocationCoordinate2D(latitude: manTestData.testAccount.base.latitude, longitude: manTestData.testAccount.base.longitude))
                mapManager.addBaseAnnotation(coord: manTestData.testAccount.base)
                mapManager.addFireAnnotations(fires: fireTestData.suspect)
                mapManager.addFireAnnotations(fires: fireTestData.verified)
                mapManager.addFireAnnotations(fires: fireTestData.tending)
                
                let temp = weatherKitManager.weather?.currentWeather.temperature.value ?? 15.0
                let wind = weatherKitManager.weather?.currentWeather.wind.speed.value ?? 5.0
                let humidity = weatherKitManager.weather?.currentWeather.humidity ?? 40.0
                if smsManager.testFireProbability(temp: temp, wind: wind, humidity: humidity) && fireTestData.suspect != nil {
                    DataController().addSMSPush(severity: 2, subject: "Fires Likely Nearby", message: "There may be fires in your area, proceed with caution - SPACE APPS TEST, THIS IS NOT AN EMERGENCY", url: nil, context: managedObjContext)
                }
            }
        }
        //Permission Denied Alert
        .alert(isPresented: $mapManager.permissionDenied) {
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Go To Settings"), action: {
                //Redirect User to System Preferences...
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension")!)
            }))
        }
    }
    
    private func toggleSidebar() { // 2
            #if os(iOS)
            #else
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
            #endif
        }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
