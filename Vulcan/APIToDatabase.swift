//
//  APIToDatabase.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//
import CoreData

// Assuming you have a FIRMSData entity and a FIRMSDataModel Core Data model.

// Fetch and parse FIRMS data
func fetchAndSaveFIRMSData() {
    guard let url = URL(string: "https://firms.modaps.eosdis.nasa.gov/api/country/csv/39698316900e4e7fc292375d74aa88f1/LANDSAT_NRT/USA/2023-10-05") else {
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data else {
            return
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Set your date decoding strategy

            let firmsData = try decoder.decode([FIRMSData].self, from: data)

            // Save FIRMS data to Core Data
            let context = persistentContainer.viewContext
            for firmData in firmsData {
                let entity = FIRMSData(context: context)
                entity.latitude = firmData.latitude
                entity.longitude = firmData.longitude
                entity.acq_date = firmData.acq_date
                entity.acq_time = firmData.acq_time
                // Set other attributes as needed
            }

            try context.save()
        } catch {
            print("Error parsing or saving FIRMS data: \(error)")
        }
    }.resume()
}

