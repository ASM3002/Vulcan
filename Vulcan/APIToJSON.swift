//
//  APIToJSON.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//

import Foundation

// API Key
func APIToJson() {
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
                        
                        // Read CSV data from the file
                        if let csvData = try? String(contentsOf: csvFilePath, encoding: .utf8) {
                            // Convert CSV data to JSON
                            let csvRows = csvData.components(separatedBy: "\n")
                            var jsonArray: [[String: String]] = []
                            let csvHeaders = csvRows[0].components(separatedBy: ",")
                            for i in 1..<csvRows.count {
                                let csvColumns = csvRows[i].components(separatedBy: ",")
                                var jsonObject: [String: String] = [:]
                                for (index, column) in csvColumns.enumerated() {
                                    if index < csvHeaders.count {
                                        jsonObject[csvHeaders[index]] = column
                                    }
                                }
                                jsonArray.append(jsonObject)
                            }
                            
                            // Filter JSON data based on latitude and longitude criteria
                            let filteredJSON = jsonArray.filter { data in
                                if let latitudeStr = data["latitude"], let longitudeStr = data["longitude"],
                                   let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                                    // Define your latitude and longitude criteria here
                                    return (latitude > 39.3 && latitude < 40.15) && (longitude > -122.069 && longitude < -121.077)
                                }
                                return false
                            }
                            
                            // Convert filtered JSON to Data
                            if let jsonData = try? JSONSerialization.data(withJSONObject: filteredJSON, options: .prettyPrinted) {
                                // Specify the full file path for the JSON file
                                let jsonFilePath = saveDirectory.appendingPathComponent("fire_data.json")
                                
                                // Save the filtered JSON data to a file
                                do {
                                    try jsonData.write(to: jsonFilePath)
                                    print("Filtered JSON data saved to '\(jsonFilePath.path)'")
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                        }
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
