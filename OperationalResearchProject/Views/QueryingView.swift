//
//  QueryingView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 14/08/2023.
//

import SwiftUI

let width = UIScreen.main.bounds.width

struct QueryingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = QueuingViewModel()
    
    var body: some View {
        
        List {
            
            Section {
                
                Text("Server Type")
                
                Picker(selection: $viewModel.serverType, label: Text("Picker")) {
                    
                    Text("M/M/C")
                        .tag(0)
                    
                    Text("M/M/G")
                        .tag(1)
                    
                    Text("G/G/C")
                        .tag(2)
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                
                Stepper("Number of Servers: \(viewModel.numberOfServers)", value: $viewModel.numberOfServers, in: 0...10)
            }
            
            Section {
                Text("Arrival Rate (ƛ)")
                
                TextField("Mean of Arrival Rate", text: $viewModel.arrivalRate)
                    .keyboardType(.numberPad)
            }
            
            Section {
                Text("Service Rate (μ)")
                
                TextField("Mean of Service Rate", text: $viewModel.serviceRate)
                    .keyboardType(.numberPad)
            }
            
            Button {
                viewModel.calculateResults()
            } label: {
                Text("Calculate Results")
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            else if let result = viewModel.result {
                Text(result.toText())
                    .foregroundColor(.green)
            }
            
        }
        .scrollDismissesKeyboard(.interactively)
        .listRowSeparator(.hidden, edges: .all)
        .navigationTitle("Quering Model")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "arrow.left")
                        .padding(.leading, 5)
                        .padding([.vertical, .trailing])
                }
                .tint(.black)
            }
        }
    }
}

struct QueryingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QueryingView()
        }
    }
}
