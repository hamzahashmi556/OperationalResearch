//
//  Customer.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 11/02/2024.
//

import Foundation

/// Class representing a customer in the queueing system.
class Customer {
    
    /// Identifier for the customer.
    var id: Int
    
    /// Time required for service.
    private var serviceTime: Int
    
    /// Priority of the customer.
    private(set) var priority: Priority
    
    /// Time of arrival for the customer.
    private(set) var arrivalTime: Int
    
    /// Remaining service time for the customer.
    var remainingServiceTime: Int
    
    /// Start time of service for the customer.
    private var startTime = Int.min
    
    /// End time of service for the customer.
    private var endTime = Int.min
    
    /// State of the customer.
    var state: CustomerState
    
    /// Initializes a customer with the specified parameters.
    init(id: Int, arrivalTime: Int, serviceTime: Int, priority: Int) {
        self.id = id
        self.arrivalTime = arrivalTime
        self.serviceTime = serviceTime
        self.remainingServiceTime = serviceTime
        self.priority = Priority(rawValue: priority) ?? .low
        self.state = .pending
    }
    
    /// Updates the start time of service if needed.
    func updateStartTimeIfNeeded(currentTime: Int) {
        if self.startTime == Int.min {
            self.startTime = currentTime
        }
    }
    
    /// Suspends the customer's service.
    func suspend() {
        self.state = .suspended
    }
    
    /// Marks the customer's service as completed.
    func completed(currentTime: Int) {
        self.endTime = currentTime
        self.state = .completed
    }
    
    /// Gets a string representation of the customer's priority.
    func getPriority() -> String {
        switch priority {
        case .high:
            return "High : 3"
        case .medium:
            return "Medium : 2"
        case .low:
            return "Low : 1"
        }
    }
    
    /// Gets the arrival time of the customer as a string.
    func getArrivalTime() -> String {
        return String(self.arrivalTime)
    }
    
    /// Gets the service time of the customer as a string.
    func getServiceTime() -> String {
        return String(self.serviceTime)
    }
    
    /// Gets the wait time of the customer as a string.
    func getWaitTime() -> String {
        let waitTime = endTime - arrivalTime - serviceTime
        return String(waitTime)
    }
    
    /// Gets the turnaround time of the customer as a string.
    func getTurnaroundTime() -> String {
        let turnaroundTime = endTime - arrivalTime
        return String(turnaroundTime)
    }
    
    /// Gets the response time of the customer as a string.
    func getResponseTime() -> String {
        let turnaroundTime = endTime - arrivalTime
        let responseTime = turnaroundTime + serviceTime
        return String(responseTime)
    }
    
    /// Gets the start time of service for the customer as a string.
    func getStartTime() -> String {
        return String(self.startTime)
    }
    
    /// Gets the end time of service for the customer as a string.
    func getEndTime() -> String {
        return String(self.endTime)
    }
    
//    func calculateMetrics() {
////        let waitTime = endTime - arrivalTime - serviceTime
//        
//        // Add other metrics as needed
//        
//        print("Customer \(ObjectIdentifier(self)):")
////        print("  Wait Time: \(waitTime)")
//        print("  Turnaround Time: \(turnaroundTime)")
//        print("  Response Time: \(responseTime)")
//        print("  Start Time: \(startTime)")
//        print("  End Time: \(endTime)")
//        print("  Priority: \(priority)")
//        print("  ------------------------")
//    }
}

/// Enum representing the state of a customer.
enum CustomerState {
    case suspended
    case completed
    case pending
}

/// Enum representing the priority of a customer.
enum Priority: Int {
    case high = 3
    case medium = 2
    case low = 1
}
