//
//  LCGViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 28/01/2024.
//

import Foundation
import SwiftUI

/// View model for managing Linear Congruential Generator (LCG) simulation parameters and results.
class LCGViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Input for parameter 'A'.
    @Published var inputA = String()
    
    /// Input for parameter 'M'.
    @Published var inputM = String()
    
    /// Input for parameter 'C'.
    @Published var inputC = String()
    
    /// Input for maximum priority value.
    @Published var inputPriority = String()
    
    /// Input for the number of simulations.
    @Published var inputIteration = String()
    
    /// Minimum priority value.
    @Published var minPriority = 1
    
    /// Array of rows representing LCG simulation results.
    @Published var lcgModels: [LCGRow] = []
    
    /// Error message to display.
    @Published var errorMessage = ""
    
    /// Type of input field causing the error.
    @Published var errorType: LCGFieldType = .none
    
    /// Indicates whether to show the results view.
    @Published var showResults = false
    
    /// Constant value for 'Z'.
    @Published var Z = 10112166
    
    // MARK: - Methods
    
    /// Pushes simulation results to the array of LCGRow.
    func push(no: Int, Z: Int, R: Int, Rand: Double, Priority: Int) {
        let lcg = LCGRow(simulation: String(no),
                         z: String(Z),
                         r: String(R),
                         random: String(Rand),
                         priority: String(Priority))
        self.lcgModels.append(lcg)
    }
    
    /// Calculates the results of the LCG simulation.
    func calculateResults() {
        
        guard let input = self.validateInputModel() else {
            print(#function, "Error")
            return
        }
        
        self.errorMessage = ""
        self.errorType = .none
        
        let minPriority = Double(self.minPriority)
        let maxPriority = Double(input.maxPriority)
        
        self.lcgModels.removeAll()
        
        for i in 0 ..< input.valueIteration {
            let R = (input.valueA * self.Z + input.valueC) % input.valueM
            
            let Rand = (Double(R) / Double(input.valueM))
            
            let priorityRange = maxPriority - minPriority
            let priority = Int((priorityRange * Rand + minPriority).rounded())
            
            self.push(no: i + 1, Z: Z, R: R, Rand: Rand, Priority: priority)
            self.Z = R
        }
        self.showResults = true
    }
    
    /// Validates the input model for LCG parameters.
    func validateInputModel() -> LCGInput? {
        
        let errorMessage = "Please Fill This Field"
        
        // Validate parameter 'A'
        if self.inputA.isEmpty {
            self.showError(error: errorMessage, type: .a)
            return .none
        }
        
        guard let valueA = Int(inputA) else {
            self.showError(error: "Can not convert value of A into Integer", type: .a)
            return .none
        }
        
        // Validate parameter 'M'
        if self.inputM.isEmpty {
            self.showError(error: errorMessage, type: .m)
            return .none
        }
        
        guard let valueM = Int(inputM) else {
            self.errorMessage = "Can not convert value of M into Integer"
            self.errorType = .m
            return .none
        }
        
        
        // Validate parameter 'C'
        if self.inputC.isEmpty {
            self.showError(error: errorMessage, type: .c)
            return .none
        }
        guard let valueC = Int(inputC) else {
            self.showError(error: "Can not convert value of C into Integer", type: .c)
            return .none
        }
        
        // Validate maximum priority value
        if self.inputPriority.isEmpty {
            self.showError(error: errorMessage, type: .priority)
            return .none
        }
        
        guard let maxPriority = Int(self.inputPriority) else {
            self.showError(error: "Can not convert value of Priority into Double", type: .priority)
            return .none
        }
        
        // Validate number of simulations
        if self.inputIteration.isEmpty {
            self.showError(error: errorMessage, type: .noOfSimulation)
            return .none
        }
        
        guard let valueIterations = Int(self.inputIteration) else {
            self.showError(error: "Can not convert value of Simulation into Integer", type: .noOfSimulation)
            return .none
        }
        
        return LCGInput(valueA: valueA, valueM: valueM, valueC: valueC, maxPriority: maxPriority, valueIteration: valueIterations)
    }
    
    /// Shows error message for the specified type of input field.
    func showError(error: String, type: LCGFieldType) {
        withAnimation {
            self.errorMessage = error
            self.errorType = type
        }
    }
}

/// Enum representing different types of LCG input fields.
enum LCGFieldType: String {
    case none = ""
    case a = "A"
    case m = "M"
    case c = "C"
    case priority = "Maximum Priority"
    case decimals = "Decimals"
    case noOfSimulation = "Simulation"
    
    /// Provides a placeholder text for the input field based on the field type.
    func getPlaceHolder() -> String {
        switch self {
        case .none:
            return ""
        case .a:
            return "Enter Value of A"
        case .m:
            return "Enter Value of M"
        case .c:
            return "Enter Value of C"
        case .priority:
            return "Enter priority from 1 to ..."
        case .decimals:
            return "Enter Value of Decimals"
        case .noOfSimulation:
            return "Enter Number of Simulations"
        }
    }
}
