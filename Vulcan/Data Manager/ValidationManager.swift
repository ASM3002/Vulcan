//
//  ValidationManager.swift
//  Vulcan
//
//  Created by Aiden McDougal on 10/7/23.
//

import Foundation
import CoreML

class ValidationManager: ObservableObject {
    
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
