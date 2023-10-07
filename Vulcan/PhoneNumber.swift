//
//  PhoneNumber.swift
//  Vulcan
//
//  Created by Jashan Rai on 10/7/23.
//
import Firebase
import Foundation
import FirebaseFirestore
/*let db = Firestore.firestore()

let data : [String:Any] = ["phonenumber": "+19168389043"]

db.collection("users").addDocument(data: data) { error in
    if let error = error {
        print("Error: \(error.localizedDescription)")
    } else {
        print("Data added successfully!")
    }
}*/


func addDataToFirestore() {
    let db = Firestore.firestore()
    let data : [String:Any] = [
        "phonenumber": "+19168389043", //Replace phone number with data from user input
    ]

    db.collection("PhoneNumber").addDocument(data: data) { error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            print("Data added successfully!")
        }
    }
}

// Call the function to execute the code
addDataToFirestore()

