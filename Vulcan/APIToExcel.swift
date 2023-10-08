//
//  APIToExcel.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//

import Foundation

func APIToExcel() {
    // API Key
    let apiKey = "39698316900e4e7fc292375d74aa88f1"  // Replace with your actual API key
    
    // Get the date for yesterday
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let formattedDate = dateFormatter.string(from: yesterday)
    print(formattedDate)
    
    // Define the API URL
    let baseURL = "https://firms.modaps.eosdis.nasa.gov/api/country/csv"
    let dataset = "LANDSAT_NRT"
    let country = "USA"
    let requestURL = "\(baseURL)/\(apiKey)/\(dataset)/\(country)/1/\("2023-10-05")"
    
    // Specify the directory where you want to save the CSV file
    let saveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let csvFilePath = saveDirectory.appendingPathComponent("fire_data.csv")
    
    // Create a URL for the API request
    if let url = URL(string: requestURL) {
        // Create a URL session
        let session = URLSession.shared
        
        // Create a data task for the API request
        let task = session.dataTask(with: url) { data, response, error in
            do {
                if let error = error {
                    throw error // Throw the error if it exists
                }
                
                if let data = data {
                    // Check if the request was successful (status code 200)
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        // Save the API response as a CSV file
                        try data.write(to: csvFilePath)
                        print("CSV data saved to '\(csvFilePath.path)'")
                    } else {
                        print("Error: Invalid status code")
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
        
        // Start the data task
        task.resume()
    } else {
        print("Error: Invalid URL")
    }
}
