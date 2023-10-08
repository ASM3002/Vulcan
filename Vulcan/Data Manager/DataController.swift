//
//  MessageManager.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "PhoneNumberModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to Load Phone Number Data: \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Phone Data Saved!")
        } catch {
            print("Error saving phone number")
        }
    }
    
    func addNumber(number: String, context: NSManagedObjectContext) {
        let phoneNumber = PhoneNumber(context: context)
        phoneNumber.id = UUID()
        phoneNumber.phoneNumber = number
        
        save(context: context)
    }
}
