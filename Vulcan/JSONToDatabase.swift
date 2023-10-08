//
//  JSONToDatabase.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//

import Foundation

func JSONToCoreData(){
    // Load JSON data from a file or an API
    if let url = Bundle.main.url(forResource: "fire_data", withExtension: "json"),
       let data = try? Data(contentsOf: url),
       let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
        
        // Access jsonArray, which is an array of JSON objects
        // Now you can iterate over jsonArray and insert each object into Core Data
    }
    let context = persistentContainer.viewContext
    
    for jsonObject in jsonArray {
        let firmData = YourCoreDataEntity(context: context)
        firmData.latitude = jsonObject["latitude"] as? Double
        firmData.longitude = jsonObject["longitude"] as? Double
        firmData.acq_date = dateFormatter.date(from: jsonObject["acq_date"] as? String ?? "")
        // Set other attributes as needed
    }
    
    do {
        try context.save()
    } catch {
        print("Error saving data: \(error)")
    }
}
