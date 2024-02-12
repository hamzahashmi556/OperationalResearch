//
//  Result.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 15/08/2023.
//

import Foundation

/// Struct representing the results of queueing analysis.
struct QueuingResults {
    /// Server utilization.
    let utilization: Double
    
    /// Average number of customers in the system.
    let avgNumCustomersSystem: Double
    
    /// Average number of customers in the queue.
    let avgNumCustomersQueue: Double
    
    /// Average time a customer spends in the system.
    let avgTimeInSystem: Double
    
    /// Average time a customer spends in the queue.
    let avgTimeInQueue: Double
    
    /// Converts the results to a formatted text representation.
    func toText() -> String {
        
        let utilization = "Server Utilization (P): \(String(format: "%.3f", utilization))"
        
        let avgNumCustomersSystem = "Average Customers in System (L): \(String(format: "%.3f", avgNumCustomersSystem))"
        
        let avgNumCustomersQueue = "Average Customers in Queue (Lq): \(String(format: "%.3f", avgNumCustomersQueue))"
        
        let avgTimeInSystem = "Average Time in System (W): \(String(format: "%.3f", avgTimeInSystem))"
        
        let avgTimeInQueue = "Average Time in Queue (Wq): \(String(format: "%.3f", avgTimeInQueue))"
        
        return "\(utilization)\n\(avgNumCustomersSystem)\n\(avgNumCustomersQueue)\n\(avgTimeInSystem)\n\(avgTimeInQueue)"
    }
}
