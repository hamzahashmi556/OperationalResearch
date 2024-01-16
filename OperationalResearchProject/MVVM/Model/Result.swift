//
//  Result.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 15/08/2023.
//

import Foundation

struct QueuingResults {
    let utilization: Double
    let avgNumCustomersSystem: Double
    let avgNumCustomersQueue: Double
    let avgTimeInSystem: Double
    let avgTimeInQueue: Double
    
    func toText() -> String {
        
        let utilization = "Server Utilization (P): \(String(format: "%.3f", utilization))"
        
        let avgNumCustomersSystem = "Average Customers in System (L): \(String(format: "%.3f", avgNumCustomersSystem))"
        
        let avgNumCustomersQueue = "Average Customers in Queue (Lq): \(String(format: "%.3f", avgNumCustomersQueue))"
        
        let avgTimeInSystem = "Average Time in System (W): \(String(format: "%.3f", avgTimeInSystem))"
        
        let avgTimeInQueue = "Average Time in Queue (Wq): \(String(format: "%.3f", avgTimeInQueue))"
        
        return "\(utilization)\n\(avgNumCustomersSystem)\n\(avgNumCustomersQueue)\n\(avgTimeInSystem)\n\(avgTimeInQueue)"
    }
}
