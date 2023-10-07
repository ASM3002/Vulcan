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
            
            //Load Region Overlay
            print("Attempting Overlay Load")
            mapManager.drawMapItems()
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
