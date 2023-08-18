//
//  FitTest.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 18/08/2023.
//

import Foundation

struct FitTest {
    var chiSquare: Double
    var significanceLevel: Double
    var criticalValue: Double
    var hypothesis: Bool
    
    func toResult() -> String {
        let chiResult = "Chi Square Value: \(String(format: "%.3f", chiSquare))"
        let significanceLevel = "Significance Level Value: \(String(format: "%.3f", significanceLevel))"
        let criticalValue = "Critical Value: \(String(format: "%.3f", criticalValue))"
        let hypothesis = hypothesis ? "Null Hypothesis" : "Alter Hypothesis"
        
        return "\(chiResult)\n\(significanceLevel)\n\(criticalValue)\n\(hypothesis)"
    }
}
