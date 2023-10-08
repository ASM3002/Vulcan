//
//  ExcelToJSON.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//

import Foundation

// Specify the file path for the CSV file
func ExcelToJSON() {
    let csvFilePath = "/Users/jrai/Documents/fire_data.csv"  // Replace with the actual file path
    
    // Read CSV data from the file
    if let csvData = try? String(contentsOfFile: csvFilePath, encoding: .utf8) {
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
            let jsonFilePath = "/Users/jrai/Documents/fire_data.json" // Replace with your desired file path
            
            // Save the filtered JSON data to a file
            do {
                try jsonData.write(to: URL(fileURLWithPath: jsonFilePath))
                print("Filtered JSON data saved to '\(jsonFilePath)'")
            } catch {
                print("Error: \(error)")
            }
        }
    } else {
        print("Error: Failed to read CSV data from '\(csvFilePath)'")
    }
}
