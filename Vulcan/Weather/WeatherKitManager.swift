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
    @Published var isFetchingWeather: Bool = false
    
    func getWeather(latitude: Double, longitude: Double) async {
        do {
            let receivedWeather = try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
            DispatchQueue.main.async {
                self.weather = receivedWeather
            }
        } catch {
            print("\(error)")
        }
    }
    
}**/
