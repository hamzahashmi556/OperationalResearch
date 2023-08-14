//
//  ViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 15/08/2023.
//

import Foundation

class QueuingViewModel: ObservableObject {
    
    @Published var serverType = 0
    @Published var numberOfServers = 0
    @Published var arrivalRate = ""
    @Published var serviceRate = ""
    
    @Published var errorMessage: String? = nil
    @Published var result: QueuingResults? = nil
    
    func calculateResults() {
        
        guard let arrivalRate = Double(self.arrivalRate) else {
            self.errorMessage = "Arrival Rate is not in Correct Format"
            self.result = nil
            return
        }
        
        guard let serviceRate = Double(self.serviceRate) else {
            self.errorMessage = "Service Rate is not in Correct Format"
            self.result = nil
            return
        }
        
        // m/m/c
        if serverType == 0 {
            self.result = self.calculateMMCResults(numberOfServers: numberOfServers, arrivalRate: arrivalRate, serviceRate: serviceRate)
        }
        // m/m/g
        else if serverType == 1 {
            self.result = self.calculateMMGResults(numberOfServers: numberOfServers, arrivalRate: arrivalRate, serviceRate: serviceRate)
        }
        // g/g/c
        else {
            self.result = self.calculateGGCResults(numberOfServers: numberOfServers, arrivalRate: arrivalRate, serviceRate: serviceRate)
        }
        
        self.errorMessage = nil
    }
    
    private func calculateMMCResults(numberOfServers: Int, arrivalRate: Double, serviceRate: Double) -> QueuingResults {
        let utilization = arrivalRate / (Double(numberOfServers) * serviceRate)
        let avgNumCustomersSystem = utilization / (1 - utilization)
        let avgNumCustomersQueue = utilization * utilization / (1 - utilization)
        let avgTimeInSystem = 1 / (serviceRate - arrivalRate)
        let avgTimeInQueue = avgNumCustomersQueue / arrivalRate
        
        return QueuingResults(utilization: utilization,
                              avgNumCustomersSystem: avgNumCustomersSystem,
                              avgNumCustomersQueue: avgNumCustomersQueue,
                              avgTimeInSystem: avgTimeInSystem,
                              avgTimeInQueue: avgTimeInQueue)
    }
    
    private func calculateMMGResults(numberOfServers: Int, arrivalRate: Double, serviceRate: Double) -> QueuingResults {
        // Implement M/M/G calculations
        // This requires more complex calculations and depends on inter-arrival time distribution
        // For simplicity, let's assume a basic MM1 calculation for illustration
        return calculateMMCResults(numberOfServers: 1, arrivalRate: arrivalRate, serviceRate: serviceRate)
    }
    
    private func calculateGGCResults(numberOfServers: Int, arrivalRate: Double, serviceRate: Double) -> QueuingResults {
        // Implement G/G/C calculations
        // This requires detailed knowledge of the general distribution of arrivals and service times
        // For simplicity, let's assume a basic MM1 calculation for illustration
        return calculateMMCResults(numberOfServers: numberOfServers, arrivalRate: arrivalRate, serviceRate: serviceRate)
    }
}
