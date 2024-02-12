//
//  Customer.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 11/02/2024.
//

import Foundation

class Customer {
    
    var id: Int
    private var serviceTime: Int
    private(set) var priority: Priority
    
    private(set) var arrivalTime: Int
    var remainingServiceTime: Int
    private var startTime = Int.min
    private var endTime = Int.min
    var state: CustomerState
    
    init(id: Int, arrivalTime: Int, serviceTime: Int, priority: Int) {
        self.id = id
        self.arrivalTime = arrivalTime
        self.serviceTime = serviceTime
        self.remainingServiceTime = serviceTime
        self.priority = Priority(rawValue: priority) ?? .low
        self.state = .pending
        
    }
    
    func updateStartTimeIfNeeded(currentTime: Int) {
        if self.startTime == Int.min {
            self.startTime = currentTime
        }
    }
    
    func suspend() {
        self.state = .suspended
    }
    
    func completed(currentTime: Int) {
        self.endTime = currentTime
        self.state = .completed
    }
    
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
    
    func getArrivalTime() -> String {
        return String(self.arrivalTime)
    }
    
    func getServiceTime() -> String {
        return String(self.serviceTime)
    }
    
    func getWaitTime() -> String {
        let waitTime = endTime - arrivalTime - serviceTime
        return String(waitTime)
    }
    
    func getTurnaroundTime() -> String {
        let turnaroundTime = endTime - arrivalTime
        return String(turnaroundTime)
    }
    
    func getResponseTime() -> String {
        let turnaroundTime = endTime - arrivalTime
        let responseTime = turnaroundTime + serviceTime
        return String(responseTime)
    }
    
    func getStartTime() -> String {
        return String(self.startTime)
    }
    
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

enum CustomerState {
    case suspended
    case completed
    case pending
}
enum Priority: Int {
    case high = 3
    case medium = 2
    case low = 1
}
