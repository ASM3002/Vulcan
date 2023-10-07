//
//  AppDelegate.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, NSApplicationDelegate {
  func application(_ application: NSApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

