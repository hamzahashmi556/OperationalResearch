//
//  LCGViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 28/01/2024.
//

import Foundation
import SwiftUI

class LCGViewModel: ObservableObject {
    
    @Published var inputA = String()
    @Published var inputM = String()
    @Published var inputC = String()
    @Published var inputPriority = String()
    @Published var inputIteration = String()

    @Published var minPriority = 1
    
    @Published var lcgModels: [LCGRow] = []
    
    @Published var errorMessage = ""
    @Published var errorType: LCGFieldType = .none
    
    @Published var showResults = false
    
    /// Constant
    @Published var Z = 10112166
    
    func push(no: Int, Z: Int, R: Int, Rand: Double, Priority: Int) {
        let lcg = LCGRow(simulation: String(no),
                      z: String(Z),
                      r: String(R),
                      random: String(Rand),
                      priority: String(Priority))
        self.lcgModels.append(lcg)
    }
    
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
    
    func validateInputModel() -> LCGInput? {
        
        let errorMessage = "Please Fill This Field"
        
        // Checking A
        if self.inputA.isEmpty {
            self.showError(error: errorMessage, type: .a)
            return .none
        }
        
        guard let valueA = Int(inputA) else {
            self.showError(error: "Can not convert value of A into Integer", type: .a)
            return .none
        }
        
        // Checking M
        if self.inputM.isEmpty {
            self.showError(error: errorMessage, type: .m)
            return .none
        }
        
        guard let valueM = Int(inputM) else {
            self.errorMessage = "Can not convert value of M into Integer"
            self.errorType = .m
            return .none
        }

        // Checking C
        if self.inputC.isEmpty {
            self.showError(error: errorMessage, type: .c)
            return .none
        }
        
        guard let valueC = Int(inputC) else {
            self.showError(error: "Can not convert value of C into Integer", type: .c)
            return .none
        }
        
        // Checking Priority
        if self.inputPriority.isEmpty {
            self.showError(error: errorMessage, type: .priority)
            return .none
        }
        
        guard let maxPriority = Int(self.inputPriority) else {
            self.showError(error: "Can not convert value of Priority into Double", type: .priority)
            return .none
        }

        // Checking Number of Simulation
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
    
    func showError(error: String, type: LCGFieldType) {
        withAnimation {
            self.errorMessage = error
            self.errorType = type
        }
    }
}

enum LCGFieldType: String {
    case none = ""
    case a = "A"
    case m = "M"
    case c = "C"
    case priority = "Maximum Priority"
    case decimals = "Decimals"
    case noOfSimulation = "Simulation"
    
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
