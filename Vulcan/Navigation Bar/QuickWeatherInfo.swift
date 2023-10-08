//
//  QuickWeatherInfo.swift
//  Vulcan
//
//  Created by Aiden McDougal on 9/19/23.
//

import SwiftUI
import CoreLocation

struct QuickWeatherInfo: View {
    @EnvironmentObject var weatherKitManager: WeatherKitManager
    @EnvironmentObject var manTestData: ManagementTestData
    @StateObject var fwiManager = FosbergFWIManager()
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            if weatherKitManager.weather != nil {
                NavigationBarItem(data: fwiManager.FFWI(temp: weatherKitManager.weather!.currentWeather.temperature.converted(to: .fahrenheit).value, humidity: weatherKitManager.weather!.currentWeather.humidity, wind: weatherKitManager.weather!.currentWeather.wind.speed.value), decimals: 1, label: "FWI")
                NavigationBarItem(data: weatherKitManager.weather!.currentWeather.temperature.converted(to: .fahrenheit).value, decimals: 0, label: "Temp", unit: "°F")
                NavigationBarItem(data: weatherKitManager.weather!.currentWeather.wind.speed.value, decimals: 0, label: "Wind", unit: "\(weatherKitManager.weather!.currentWeather.wind.compassDirection.abbreviation)")
            } else {
                Text("Weather Data Failed To Load")
                    .foregroundColor(.theme.white)
                    .font(.title2)
            }
        }
        .onAppear {
            Task {
                try await weatherKitManager.getWeather(latitude: manTestData.testAccount.base.latitude, longitude: manTestData.testAccount.base.longitude)
                await print(weatherKitManager.weather)
                
            }
        }
    }
}

struct QuickWeatherInfo_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
