//
//  MM1PriorityView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 29/01/2024.
//

import SwiftUI

struct MM1PriorityView: View {
    
    @StateObject var viewModel = MM1PriorityViewModel()
    
    var body: some View {
        List {
            
            // Inputs
            
            // Arrival Times
            Section("Arrival Time") {
                VStack(alignment: .leading) {
                    Text("Enter Comma Seperated Arrival Times")
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(viewModel.arrivalMessage.isEmpty ? .green : .red)
                        
                        TextField("e.g: 10, 20, 30, 40", text: $viewModel.inputArrivals)
                            .padding(.leading)
                    }
                    .frame(height: 80)
                    
                    if !viewModel.arrivalMessage.isEmpty {
                        Text(viewModel.arrivalMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            // Service Times
            Section("Service Time") {
                VStack(alignment: .leading) {
                    Text("Enter Comma Seperated Service Times")
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(viewModel.serviceMessage.isEmpty ? .green : .red)
                        
                        TextField("e.g: 10, 20, 30, 40", text: $viewModel.inputServices)
                            .padding(.leading)
                    }
                    .frame(height: 80)
                    
                    if !viewModel.serviceMessage.isEmpty {
                        Text(viewModel.serviceMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            // Priorities
            Section("Priorities") {
                VStack(alignment: .leading) {
                    Text("Priority From Highest to Lowest -> 3...1")
                    Text("Enter Comma Seperated Priorities")
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundStyle(viewModel.priorityMessage.isEmpty ? .green : .red)
                        
                        TextField("e.g: 10, 20, 30, 40", text: $viewModel.inputPriorities)
                            .padding(.leading)
                    }
                    .frame(height: 80)
                    
                    if !viewModel.priorityMessage.isEmpty {
                        Text(viewModel.priorityMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            //            Button("Calculate") {
            //                viewModel.validateInputs()
            //            }
            //            .padding()
            
            Section("Table") {
                TableView()
            }
            
            Section("Gant Chart") {
                GantChartView()
            }
        }
        .font(.title)
        .bold()
        .onAppear(perform: {
            /*
            viewModel.inputArrivals = "0,4,8,10"
            viewModel.inputServices = "5,6,7,8"
            viewModel.inputPriorities = "1,2,3,1"
             */
        })
    }
    
    func ColumnTitle(_ title: String) -> some View {
        Text(title)
            .frame(width: 200, height: 50, alignment: .center)
    }
    
    func TableView() -> some View {
        ScrollView(.horizontal) {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ColumnTitle("ID")
                    Divider()
                    ColumnTitle("Arrival Time")
                    Divider()
                    ColumnTitle("Service Time")
                    Divider()
                    ColumnTitle("Priority")
                    Divider()
                    ColumnTitle("Start Time")
                    Divider()
                    ColumnTitle("End Time")
                    Divider()
                    ColumnTitle("Response Time")
                    Divider()
                    ColumnTitle("Wait Time")
                }
                
                Divider()
                
                VStack(spacing: 0) {
                    ForEach(viewModel.calculatedCustomers, id: \.id) { customer in
                        HStack(spacing: 0) {
                            ColumnTitle(String(customer.id))
                            Divider()
                            ColumnTitle(customer.getArrivalTime())
                            Divider()
                            ColumnTitle(customer.getServiceTime())
                            Divider()
                            ColumnTitle(customer.getPriority())
                            Divider()
                            ColumnTitle(customer.getStartTime())
                            Divider()
                            ColumnTitle(customer.getEndTime())
                            Divider()
                            ColumnTitle(customer.getResponseTime())
                            Divider()
                            ColumnTitle(customer.getWaitTime())
                        }
                        .foregroundStyle(customer.priority == .high ? .red : customer.priority == .medium ? .yellow : .green)

                        
                        Divider()
                    }
                }
            }
        }
    }
    
    func GantChartView() -> some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.grantChartModels) { model in
                    if let customer = viewModel.calculatedCustomers.first(where: { "\($0.id)" == model.getID() }) {
                        
                        VStack(spacing: 0) {
                            
                            Text("Customer ID: \(model.getID())")
                            
                            Divider()
                                .padding(.vertical, 5)
                            
                            HStack {
                                Text(model.getStartTime())
                                Rectangle()
                                    .frame(height: 1)
                                Text(model.getEndTime())
                            }
                            .padding(.horizontal)
                        }
                        .frame(width: 220, height: 100, alignment: .center)
                        .background {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke()
                        }
                        .foregroundStyle(customer.priority == .high ? .red : customer.priority == .medium ? .yellow : .green)
                    }
                }
            }
        }
    }
}
/*
struct MM1PriorityInputView: View {
    
    @ObservedObject var viewModel: MM1PriorityViewModel
    var type: MM1PriorityType
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(type.getPlaceHolder())
                .padding(.horizontal)
                .font(.title)
                .frame(height: 50)
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
//                    .foregroundStyle(viewModel.errorType == type ? .red : .white)
                    .foregroundStyle(.red)
                
                TextField("", text: $text)
                    .padding(.leading)
            }
            .frame(height: 80)
        }
    }
}
*/
#Preview {
    MM1PriorityView(viewModel: MM1PriorityViewModel())
        .preferredColorScheme(.dark)
}
