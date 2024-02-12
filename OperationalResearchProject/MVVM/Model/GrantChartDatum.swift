//
//  GrantChartDatum.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 12/02/2024.
//

import Foundation

/// Data structure representing information for the Gantt chart.
struct GrantChartData: Identifiable {
    
    var id = UUID().uuidString
    private var customerID: Int = 0
    private var startTime: Int
    private var endTime: Int = Int.min
    
    /// Initializes the GrantChartData structure with customer ID and start time.
    /// - Parameters:
    ///   - customerID: The ID of the customer.
    ///   - startTime: The start time of the service.
    init(customerID: Int, startTime: Int) {
        self.customerID = customerID
        self.startTime = startTime
    }
    
    /// Resets the start and end times to their initial values.
    mutating func reset() {
        self.startTime = Int.min
        self.endTime = Int.min
    }
    
    /// Sets the end time.
    /// - Parameter endTime: The end time of the service.
    mutating func end(endTime: Int) {
        self.endTime = endTime
    }
    
    /// Retrieves the ID of the customer.
    /// - Returns: The customer ID.
    func getID() -> String {
        return String(customerID)
    }
    
    /// Retrieves the start time as a string.
    /// - Returns: The start time.
    func getStartTime() -> String {
        return String(startTime)
    }
    
    /// Retrieves the end time as a string.
    /// - Returns: The end time.
    func getEndTime() -> String {
        return String(endTime)
    }
}
