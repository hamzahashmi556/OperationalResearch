//
//  OperationalResearchProjectApp.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 14/08/2023.
//

import SwiftUI

@main
struct OperationalResearchProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onAppear(perform: {
                    let customers = [
                        Customer(id: 1, arrivalTime: 1, serviceTime: 5, priority: 3),
                        Customer(id: 2, arrivalTime: 8, serviceTime: 4, priority: 2),
                        Customer(id: 3, arrivalTime: 10, serviceTime: 3, priority: 3)
                    ]

                    var queue: [Customer] = []
                    var currentTime = 1

                    var isServiceEnabled = true

                    while isServiceEnabled {
                        
                        // Check for new arrivals
                        let newCustomers = customers.filter { $0.arrivalTime == currentTime }
                        queue.append(contentsOf: newCustomers)
                        
                        // Check if there is a customer in the queue
                        if let currentCustomer = queue.first {
                            
                            // Check if there's a higher-priority customer in the queue
                            let higherPriorityCustomer = queue.first { $0.priority.rawValue > currentCustomer.priority.rawValue }
                            
                            // If a higher-priority customer arrives, pause the current service
                            if let higherPriorityCustomer = higherPriorityCustomer {
                                print("Service paused for lower priority customer.")
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
                        isServiceEnabled = currentTime <= customers.map { $0.arrivalTime }.max()! || !queue.isEmpty
                        
                    }

//                    for customer in customers {
//                        customer.calculateMetrics()
//                    }
                })
        }
    }
}


