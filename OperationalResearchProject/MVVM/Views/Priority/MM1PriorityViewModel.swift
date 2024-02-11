//
//  MM1PriorityViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 29/01/2024.
//

import Foundation

class MM1PriorityViewModel: ObservableObject {
    
    @Published var inputArrivals = "" {
        didSet {
            self.validateInputs()
        }
    }
    @Published var arrivalMessage = ""
    
    @Published var inputServices = ""{
        didSet {
            self.validateInputs()
        }
    }
    @Published var serviceMessage = ""
    
    
    @Published var inputPriorities = ""{
        didSet {
            self.validateInputs()
        }
    }
    @Published var priorityMessage = ""
    
    @Published var calculatedCustomers: [Customer] = []
}


extension MM1PriorityViewModel {
    
    func validateInputs() {
        
        // Arrivals
        var arrivals: [Int] = []
        
        // arrivals
        do {
            arrivals = try self.checkInput(inputString: self.inputArrivals)
        }
        catch {
            self.arrivalMessage = error.localizedDescription
        }
        
        // services
        var services: [Int] = []
        do {
            services = try self.checkInput(inputString: self.inputServices)
        }
        catch {
            self.serviceMessage = error.localizedDescription
        }


        // priorities
        var priorites: [Int] = []
        do {
            priorites = try self.checkInput(inputString: self.inputPriorities)
        }
        catch {
            self.priorityMessage = error.localizedDescription
        }
        
        if arrivals.count == services.count && services.count == priorites.count {
            self.arrivalMessage = ""
            self.serviceMessage = ""
            self.priorityMessage = ""
            self.calculatedCustomers = self.caluclateResults(arrivals: arrivals, services: services, priorities: priorites)
        }
        else {
            if arrivals.count != services.count {
                self.arrivalMessage = "Numbers Are Not Equal"
                self.serviceMessage = "Numbers Are Not Equal"
            }
            else if services.count != priorites.count {
                self.serviceMessage = "Numbers Are Not Equal"
                self.priorityMessage = "Numbers Are Not Equal"
            }
            else if arrivals.count != priorites.count {
                self.arrivalMessage = "Numbers Are Not Equal"
                self.priorityMessage = "Numbers Are Not Equal"
            }
        }
    }
    
    private func checkInput(inputString: String) throws -> [Int] {
        var errorMessage = ""
        var inputArray: [Int] = []
        for arrival in inputString.split(separator: ",") {
            if let intValue = Int(arrival), intValue >= 0 {
                if intValue < 0 {
                    throw NSError(domain: "Arrival Can not be negative integer", code: 0)
                }
                else {
                    inputArray.append(intValue)
                }
            }
            else {
                throw NSError(domain: "Arrival Can not converted into integer array please check the format", code: 0)
            }
        }
        
        return inputArray
    }
    
    private func caluclateResults(arrivals: [Int], services: [Int], priorities: [Int]) -> [Customer] {
        
        var customers: [Customer] = []
        
        for i in 0 ..< arrivals.count {
            let arrival = arrivals[i]
            let service = services[i]
            let priority = priorities[i]
            let customer = Customer(id: i, arrivalTime: arrival, serviceTime: service, priority: priority)
            customers.append(customer)
        }


        var queue: [Customer] = []
        var currentTime = 0

        var isServiceEnabled = true

        while isServiceEnabled {
            
            // Check for new arrivals
            let newCustomers = customers.filter { $0.arrivalTime == currentTime }
            queue.append(contentsOf: newCustomers)
            
            // Check if there is a customer in the queue
            if let currentCustomer = queue.first {
                
                // Check if there's a higher-priority customer in the queue
                let higherPriorityCustomer = queue.min(by: { $0.priority.rawValue > $1.priority.rawValue })
//                let higherPriorityCustomer = queue.first { $0.priority.rawValue > currentCustomer.priority.rawValue }
                
                // If a higher-priority customer arrives, pause the current service
                if let higherPriorityCustomer = higherPriorityCustomer {
                    print("Higher Customer ID: \(higherPriorityCustomer.id)")
                    //print("Service paused for lower priority customer.")
                    currentCustomer.suspend()
                    
                    // Move to the higher-priority customer
                    higherPriorityCustomer.updateStartTimeIfNeeded(currentTime: currentTime)
                    higherPriorityCustomer.remainingServiceTime -= 1
                    currentTime += 1
                    
                    // Check if service is completed for the higher-priority customer
                    if higherPriorityCustomer.remainingServiceTime == 0 {
                        higherPriorityCustomer.completed(currentTime: currentTime)
                        queue.removeAll(where: { $0.id == higherPriorityCustomer.id } )
                    }
                }
                else {
                    // Continue with the current service
                    currentCustomer.updateStartTimeIfNeeded(currentTime: currentTime)
                    
                    currentCustomer.remainingServiceTime -= 1
                    currentTime += 1
                    
                    // Check if service is completed for the current customer
                    if currentCustomer.remainingServiceTime == 0 {
                        currentCustomer.completed(currentTime: currentTime)
                        queue.removeAll(where: { $0.id == currentCustomer.id })
                    }
                }
            } else {
                currentTime += 1
            }
            
            // Check if there are still customers to arrive or in the queue
            if let max = customers.map({ $0.arrivalTime }).max() {
                isServiceEnabled = currentTime <= max || !queue.isEmpty
            }
            else {
                isServiceEnabled = false
            }
        }
        return customers
    }

    /*
    func generateServiceTime(mu: Double, numCustomers: Int) -> [Double] {
        var serviceTimes: [Double] = []

        for _ in 0..<numCustomers {
            let serviceTime = generateExponentialRandomNumber(mu: mu)
            serviceTimes.append(serviceTime)
        }
        return serviceTimes
    }

    func generateExponentialRandomNumber(mu: Double) -> Double {
        return Double(-log(Double.random(in: 0..<1)) * mu) + 1
    }

    struct LCGParameters {
        var seed: Int
        var a: Int
        var c: Int
        var m: Int
        var count: Int
    }

    func generateRandomPriorities(parameters: LCGParameters) -> [Int] {
        var priorities: [Int] = []
        var currentSeed = parameters.seed

        for _ in 0..<parameters.count {
            currentSeed = (parameters.a * currentSeed + parameters.c) % parameters.m
            let priority = (currentSeed % 3) + 1
            priorities.append(priority)
        }

        return priorities
    }
     */
}

/*
enum MM1PriorityType: String {
    case none = ""
    case customers = "Number of Customers"
    /// Lambda Value
    case arrivalRate = "Arrival Rate"
    /// Mu Value
    case serviceRate = "Service Rate"
    case randomSeed = "Random Seed"
    
    func getPlaceHolder() -> String {
        switch self {
        case .none:
            return ""
        case .customers:
            return "Enter Customers"
        case .arrivalRate:
            return "Enter Arrival Rate"
        case .serviceRate:
            return "Enter Service Rate"
        case .randomSeed:
            return "Enter Random Seed"
        }
    }
}
*/
