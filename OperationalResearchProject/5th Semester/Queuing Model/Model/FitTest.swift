//
//  FitTest.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 18/08/2023.
//

import Foundation

/// Struct representing the results of a fit test.
struct FitTest {
    /// Chi-square value.
    var chiSquare: Double
    
    /// Significance level.
    var significanceLevel: Double
    
    /// Critical value.
    var criticalValue: Double
    
    /// Converts the fit test results to a formatted text representation.
    func toResult() -> String {
        let isHypothesis = chiSquare <= criticalValue
        let chiResult = "Chi Square Value: \(String(format: "%.3f", chiSquare))"
        let significanceLevel = "Significance Level Value: \(String(format: "%.3f", significanceLevel))"
        let criticalValue = "Critical Value: \(String(format: "%.3f", criticalValue))"
        let hypothesis = isHypothesis ? "Null Hypothesis" : "Alternative Hypothesis"
        
        return "\(chiResult)\n\(significanceLevel)\n\(criticalValue)\n\(hypothesis)"
    }
}
