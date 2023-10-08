//
//  APIToJSON.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//

import Foundation

// Get the date for yesterday
let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
let formattedDate = dateFormatter.string(from: yesterday)

// Define the API URL
let baseURL = "https://firms.modaps.eosdis.nasa.gov/api/country/csv"
let apiKey = "39698316900e4e7fc292375d74aa88f1"
let dataset = "LANDSAT_NRT"
let country = "USA"
let requestURL = "\(baseURL)/\(apiKey)/\(dataset)/\(country)/1/\(formattedDate)"

// Specify the directory where you want to save the file
let saveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

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
                    // Parse the CSV response data
                    if let csvData = String(data: data, encoding: .utf8) {
                        print("Complete")
                        
                        // Specify the full file path
                        let filePath = saveDirectory.appendingPathComponent("fire_data.csv")
                        
                        // Save the data to a CSV file in the specified directory
                        try csvData.write(to: filePath, atomically: true, encoding: .utf8)
                        print("Fire data saved to '\(filePath.path)'")
                        
                        // Parse CSV data into JSON
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
                        
                        // Convert JSON data to Data
                        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted) {
                            // Specify the full file path for the JSON file
                            let jsonFilePath = saveDirectory.appendingPathComponent("file_data.json")
                            
                            // Save the JSON data to a file
                            do {
                                try jsonData.write(to: jsonFilePath)
                                print("CSV data converted to JSON and saved to '\(jsonFilePath.path)'")
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



