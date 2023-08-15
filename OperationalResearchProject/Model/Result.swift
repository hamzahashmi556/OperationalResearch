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
        let utilization = String(format: "%.2f", utilization)
        let avgNumCustomersSystem = String(format: "%.2f", avgNumCustomersSystem)
        let avgNumCustomersQueue = String(format: "%.2f", avgNumCustomersQueue)
        let avgTimeInSystem = String(format: "%.2f", avgTimeInSystem)
        let avgTimeInQueue = String(format: "%.2f", avgTimeInQueue)

        return "Utilization: \(utilization)\nAverage  Number of Customers in System: \(avgNumCustomersSystem)\nAverage Number of Customers in Queue: \(avgNumCustomersQueue)\nAverage Time in System: \(avgTimeInSystem)\nAverage Time in Queue: \(avgTimeInQueue)"
    }
}
