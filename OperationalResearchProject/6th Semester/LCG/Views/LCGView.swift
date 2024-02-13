//
//  LCGView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 28/01/2024.
//

import SwiftUI

/// View for managing Linear Congruential Generator (LCG) simulation inputs and displaying results.
struct LCGView: View {
    
    @StateObject var viewModel = LCGViewModel()
    
    var body: some View {
        List {
            // Input fields for LCG parameters
            LCGInputView(viewModel: viewModel, type: .a, text: $viewModel.inputA)
            
            LCGInputView(viewModel: viewModel, type: .m, text: $viewModel.inputM)
            
            LCGInputView(viewModel: viewModel, type: .c, text: $viewModel.inputC)
            
            LCGInputView(viewModel: viewModel, type: .priority, text: $viewModel.inputPriority)
            
            LCGInputView(viewModel: viewModel, type: .noOfSimulation, text: $viewModel.inputIteration)
            
            // Button to trigger calculation of results
            Button("Show Results") {
                viewModel.calculateResults()
            }
            .frame(height: 80)
            .padding(.horizontal)
        }
        .navigationTitle("LCG")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .keyboardType(.decimalPad)
        .font(.appFont())
        .padding()
        
        // Navigation to the results view
        .navigationDestination(isPresented: $viewModel.showResults) {
            LCGTableView(viewModel: viewModel)
        }
    }
}

/// View for input fields in LCG simulation.
struct LCGInputView: View {
    
    @ObservedObject var viewModel: LCGViewModel
    @State var type: LCGFieldType
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Placeholder text for input field
            Text(type.getPlaceHolder())
                .padding(.horizontal)
                .frame(height: 50)
            
            ZStack {
                // Input field with border color indicating validation error
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .foregroundStyle(viewModel.errorType == type ? .red : .white)
                    .foregroundStyle(.red)
                
                TextField("", text: $text)
                    .padding(.leading)
            }
            .frame(height: Constants.textFieldHeight)
            
            // Error message display
            if viewModel.errorType == type {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
            }
        }
    }
}

/// View for displaying results of LCG simulation.
struct LCGTableView: View {
    
    @ObservedObject var viewModel: LCGViewModel
    
    var body: some View {
        
        TableView(headers: ["Simulation", "Z", "R (LCG)", "Random Number (X)", "Priority (Y)"])
        /*
        if #available(iOS 17.0, *) {
            // Table view to display simulation results
            Table(viewModel.lcgModels) {
                TableColumn("Simulation", value: \.simulation)
                    .alignment(.center)
                
                TableColumn("Z", value: \.z)
                    .alignment(.center)
                
                TableColumn("R (LCG)", value: \.r)
                    .alignment(.center)
                
                TableColumn("Random Number (X)", value: \.random)
                    .alignment(.center)
                
                TableColumn("Priority (Y)", value: \.priority)
                    .alignment(.center)
            }
            .tableStyle(.automatic)
            .frame(width: UIScreen.main.bounds.width)
        }
         */
    }
    
    /// Helper function to create column titles for the table.
    func ColumnTitle(_ title: String) -> some View {
        Text(title)
            .frame(width: Constants.tableColumnWidth, height: 80, alignment: .center)
            .multilineTextAlignment(.center)
    }
    
    /// A view for displaying the table of calculated results.
    func TableView(headers: [String]) -> some View {
        
        ScrollView(.vertical) {
            
            VStack {
                
                ScrollView(.horizontal) {
                    
                    VStack(spacing: 0) {
                        
                        // Headers
                        HStack(spacing: 0) {
                            
                            ForEach(0..<headers.count, id: \.self) { index in
                                ColumnTitle(headers[index])
                                Divider()
                            }
                        }
                        
                        Divider()
                        
                        VStack(spacing: 0) {
                            ForEach(viewModel.lcgModels, id: \.id) { model in
                                
                                // Horizontal Values
                                HStack(spacing: 0) {
                                    ColumnTitle(String(model.simulation))
                                    Divider().frame(height: 80)
                                    ColumnTitle(model.z)
                                    Divider().frame(height: 80)
                                    ColumnTitle(model.r)
                                    Divider().frame(height: 80)
                                    ColumnTitle(model.random)
                                    Divider().frame(height: 80)
                                    ColumnTitle(model.priority)
                                    Divider().frame(height: 80)
                                }
                                
                                // Then Line Seperator
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LCGView().preferredColorScheme(.dark)
    }
}
