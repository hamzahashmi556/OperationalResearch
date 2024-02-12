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
    
    @Published var grantChartModels: [GrantChartService] = []
}


extension MM1PriorityViewModel {
    
    func validateInputs() {
        
        // Arrivals
        self.arrivalMessage = ""
        self.serviceMessage = ""
        self.priorityMessage = ""
        
        // arrivals
        var arrivals: [Int] = []
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
            
            let (customers, grantChartModels) = self.caluclateResults(arrivals: arrivals, services: services, priorities: priorites)
            self.calculatedCustomers = customers
            self.grantChartModels = grantChartModels
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
    
    private func caluclateResults(arrivals: [Int], services: [Int], priorities: [Int]) -> ([Customer], [GrantChartService]) {
        
        var customers: [Customer] = []
        
        for i in 0 ..< arrivals.count {
            let arrival = arrivals[i]
            let service = services[i]
            let priority = priorities[i]
            let customer = Customer(id: i + 1, arrivalTime: arrival, serviceTime: service, priority: priority)
            customers.append(customer)
        }


        var queue: [Customer] = []
        var currentTime = 0
        
        var isServiceEnabled = true
        
        var serviceCustomer: Customer? = nil
        var grantChartService: GrantChartService? = nil
        var services: [GrantChartService] = []
        
        while isServiceEnabled {
            
            // Check for new arrivals
            let newCustomers = customers.filter { $0.arrivalTime == currentTime }
            queue.append(contentsOf: newCustomers)
            
            // Check if there's a higher-priority customer in the queue
            if let currentCustomer = queue.min(by: { $0.priority.rawValue > $1.priority.rawValue }) {
                
                // 1. Add Service For Grant Chart for the Current Customer
                if serviceCustomer == nil {
                    print("Service Started: \(currentTime)")
                    grantChartService = GrantChartService(customerID: currentCustomer.id, startTime: currentTime)
                    serviceCustomer = currentCustomer
                }
                else {
                    grantChartService?.end(endTime: currentTime)
                    
                    if currentCustomer.id != serviceCustomer?.id  {
                        
                        print("Service Ended: \(currentTime)")
                        
                        services.append(grantChartService!)
                        
                        grantChartService = GrantChartService(customerID: currentCustomer.id, startTime: currentTime)
                        
                        serviceCustomer = currentCustomer
                    }
                }
                
                // 2. Continue with the current service
                currentCustomer.updateStartTimeIfNeeded(currentTime: currentTime)
                
                currentCustomer.remainingServiceTime -= 1
                currentTime += 1
                
                // 3. Check if service is completed for the current customer
                if currentCustomer.remainingServiceTime == 0 {
                    currentCustomer.completed(currentTime: currentTime)
                    queue.removeAll(where: { $0.id == currentCustomer.id })
                    
                    // 4. Add The Service for the last customer
                    if queue.isEmpty {
                        services.append(grantChartService!)
                    }
                }
                
            }
            else {
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
        return (customers, services)
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
struct GrantChartService: Identifiable {
    
    var id = UUID().uuidString
    private var customerID: Int = 0
    private var startTime: Int
    private var endTime: Int = Int.min
    
    init(customerID: Int, startTime: Int) {
        self.customerID = customerID
        self.startTime = startTime
    }
    
    mutating func reset() {
        self.startTime = Int.min
        self.endTime = Int.min
    }
    
    mutating func start(startTime: Int, customerID: Int) {
        self.startTime = startTime
        self.customerID = customerID
    }
    
    mutating func end(endTime: Int) {
        self.endTime = endTime
    }
    
    func getID() -> String {
        return String(customerID)
    }
    
    func getStartTime() -> String {
        return String(startTime)
    }
    
    func getEndTime() -> String {
        return String(endTime)
    }

}
