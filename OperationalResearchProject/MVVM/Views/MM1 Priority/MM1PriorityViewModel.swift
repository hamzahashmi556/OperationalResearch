//
//  MM1PriorityViewModel.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 29/01/2024.
//

import Foundation

/// View model for the MM1PriorityView, responsible for managing inputs, validating them, and calculating results.
class MM1PriorityViewModel: ObservableObject {
    
    /// Published property for input arrival times.
    @Published var inputArrivals = "" {
        didSet {
            self.validateInputs()
        }
    }
    
    /// Published property for arrival message to display validation errors.
    @Published var arrivalMessage = ""
    
    /// Published property for input service times.
    @Published var inputServices = ""{
        didSet {
            self.validateInputs()
        }
    }
    
    /// Published property for service message to display validation errors.
    @Published var serviceMessage = ""
    
    /// Published property for input priorities.
    @Published var inputPriorities = ""{
        didSet {
            self.validateInputs()
        }
    }
    
    /// Published property for priority message to display validation errors.
    @Published var priorityMessage = ""
    
    /// Published property for the list of calculated customers.
    @Published var calculatedCustomers: [Customer] = []
    
    /// Published property for the list of Gantt chart data.
    @Published var grantChartModels: [GrantChartData] = []
}

// MARK: - Extensions

extension MM1PriorityViewModel {
    
    /// Validates the input strings for arrivals, services, and priorities.
    func validateInputs() {
        // Reset error messages
        self.arrivalMessage = ""
        self.serviceMessage = ""
        self.priorityMessage = ""
        
        // Parse input strings into arrays of integers
        
        // check if the arrival input is correct
        var arrivals: [Int] = []
        do {
            arrivals = try self.checkInput(inputString: self.inputArrivals)
        }
        catch {
            self.arrivalMessage = error.localizedDescription
        }
        
        // check if the service input is correct
        var services: [Int] = []
        do {
            services = try self.checkInput(inputString: self.inputServices)
        }
        catch {
            self.serviceMessage = error.localizedDescription
        }
        
        // check if the priority input is correct
        var priorites: [Int] = []
        do {
            priorites = try self.checkInput(inputString: self.inputPriorities)
        }
        catch {
            self.priorityMessage = error.localizedDescription
        }
        
        // To Make Sure the Data are of equal sizes for equal number of customers
        // We Validate inputs and calculate results if inputs are valid
        if arrivals.count == services.count && services.count == priorites.count {
            self.arrivalMessage = ""
            self.serviceMessage = ""
            self.priorityMessage = ""
            
            let (customers, grantChartModels) = self.caluclateResults(arrivals: arrivals, services: services, priorities: priorites)
            self.calculatedCustomers = customers
            self.grantChartModels = grantChartModels
        }
        else {
            // Handle mismatched input lengths
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
    
    /// Parses the input string into an array of integers.
    /// - Parameter inputString: The input string to parse.
    /// - Returns: An array of integers parsed from the input string.
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
    
    /// Calculates the results based on input arrival times, service times, and priorities.
    /// - Parameters:
    ///   - arrivals: The array of arrival times.
    ///   - services: The array of service times.
    ///   - priorities: The array of priorities.
    /// - Returns: A tuple containing the list of calculated customers and the list of Gantt chart data.
    private func caluclateResults(arrivals: [Int], services: [Int], priorities: [Int]) -> ([Customer], [GrantChartData]) {
        var customers: [Customer] = []
        
        // Create customers based on input data
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
        var grantChartData: GrantChartData? = nil
        var chartDataList: [GrantChartData] = []
        
        // Process customers until no more arrivals or customers in queue
        while isServiceEnabled {
            // Check for new arrivals
            let newCustomers = customers.filter { $0.arrivalTime == currentTime }
            queue.append(contentsOf: newCustomers)
            
            // Check if there's a higher-priority customer in the queue
            if let currentCustomer = queue.min(by: { $0.priority.rawValue > $1.priority.rawValue }) {
                
                // Add service for Gantt chart
                
                // if no cutomer is on service
                if serviceCustomer == nil {
                    print("Service Started: \(currentTime)")
                    grantChartData = GrantChartData(customerID: currentCustomer.id, startTime: currentTime)
                    serviceCustomer = currentCustomer
                }
                // if customer is being served
                else {
                    // update the endtime
                    grantChartData?.end(endTime: currentTime)
                    // if the customer being served was interrupted, add a service to the list and make a new grant chart model and also set the current customer in service
                    if currentCustomer.id != serviceCustomer?.id  {
                        print("Service Ended: \(currentTime)")
                        
                        // adding service to the list
                        chartDataList.append(grantChartData!)
                        
                        // initializing the new service
                        grantChartData = GrantChartData(customerID: currentCustomer.id, startTime: currentTime)
                        
                        // setting the current customer to serivce customer
                        serviceCustomer = currentCustomer
                    }
                }
                
                // Continue with the current service
                currentCustomer.updateStartTimeIfNeeded(currentTime: currentTime)
                currentCustomer.remainingServiceTime -= 1
                currentTime += 1
                
                // Check if service is completed for the current customer
                if currentCustomer.remainingServiceTime == 0 {
                    currentCustomer.completed(currentTime: currentTime)
                    queue.removeAll(where: { $0.id == currentCustomer.id })
                    
                    // Add the service for the last customer
                    if queue.isEmpty {
                        chartDataList.append(grantChartData!)
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
        return (customers, chartDataList)
    }
}
