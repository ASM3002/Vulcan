//
//  WeatherKitManager.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/19/23.
//

/**import Foundation
import WeatherKit

@MainActor class WeatherKitManager: ObservableObject {
    @Published var weather: Weather?
    
    func getWeather(latitude: Double, longitude: Double) async {
        do {
            weather = try await Task.detached(priority: .userInitiated) {
                return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            }.value
        } catch {
            print("\(error)")
        }
    }
    
}**/
