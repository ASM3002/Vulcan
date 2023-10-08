//
//  SMSManager.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import SwiftUI
import CoreData
import CoreML


class SMSManager: ObservableObject {
    
    func sendSMS(/*sms: SMSPush,*/ numbers: FetchedResults<PhoneNumber>) {
        var mainString = "This is the main string which test can be ran from"
//        if sms.subject != nil || sms.message != nil {
//            mainString = sms.subject! + ": " + sms.message!
//        }
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/python3") // Path to the Python interpreter (change as needed)
        task.arguments = ["sendEmail.py"] // Path to your Python script (change as needed)

        let inputPipe = Pipe()
        task.standardInput = inputPipe
        var numString = ""
        for number in numbers {
            numString = numString + number.phoneNumber! + ","
        }
        let inputData = numString + mainString
        inputPipe.fileHandleForWriting.write(Data(inputData.utf8))
        inputPipe.fileHandleForWriting.closeFile()

        do {
            try task.run()
            task.waitUntilExit()
        } catch {
            print("Error running Python script: \(error)")
        }
    }
    
    func testFireProbability(temp: Double, wind: Double, humidity: Double) -> Bool {
        // Initialize the model (replace "YourModelName" with your actual model name)
        if let model = try? svm_model(configuration: MLModelConfiguration()) {
            // Prepare input data (replace with your actual input data)
            let input = svm_modelInput(input: [temp, wind, humidity])
            print(input)
            // Make a prediction
            if let prediction = try? model.prediction(input: input) {
                // Access the prediction result (replace with your specific output field)
                if let output = prediction.featureValue(for: "classLabel") {
                    print("Prediction: \(output)")
                    print("Double Value: \(output.int64Value)")
                    if output.int64Value == 1 {
                        return true
                    }
                }
            }
        }
        return false
    }
}
