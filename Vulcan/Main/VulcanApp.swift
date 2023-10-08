//
//  VulcanApp.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/19/23.
//

import SwiftUI

@main
struct VulcanApp: App {
    @StateObject var mainVM = MainViewModel()
    @StateObject var manTestData = ManagementTestData()
    @StateObject var fireTestData = FireTestData()
    @ObservedObject var mapManager = MapManager()
    @StateObject var dataController = DataController()
    @StateObject var smsManager = SMSManager()
    @ObservedObject var weatherKitManager = WeatherKitManager()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(mainVM)
                .environmentObject(manTestData)
                .environmentObject(fireTestData)
                .environmentObject(mapManager)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(smsManager)
                .environmentObject(weatherKitManager)
        }
    }
}
