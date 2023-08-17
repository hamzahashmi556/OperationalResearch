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
                    
                    Text("M/G/C")
                        .tag(1)
                    
                    Text("G/G/C")
                        .tag(2)
                }
                .pickerStyle(.segmented)
            }
            
            NumberOfServersView()
            
            if viewModel.serverType == 0 {
                ArrivalRateView()
                
                ServiceRateView()
            }
            else if viewModel.serverType == 1 {
                ArrivalMeanExponentialDistribution()
                
                MaximumUniformDistribution()
                
                MinimumUniformDistribution()
            }
            else {
                ArrivalMeanExponentialDistribution()
                
                ArrivalVarianceExponentialDistribution()
                
                ServiceMeanNormalDistribution()
                
                ServiceVarianceNormalDistribution()
            }
            
            Button {
                viewModel.calculateResults()
            } label: {
                Text("Show Results")
            }
            .tint(.blue)
            
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
        .navigationBarTitleDisplayMode(.large)
        .tint(.black)
    }
    
    func NumberOfServersView() -> some View {
        Section {
            Stepper("Number of Servers: \(viewModel.numberOfServers)", value: $viewModel.numberOfServers, in: 0...10)
        }
    }
    
    func ArrivalRateView() -> some View {
        Section {
            Text("Arrival Rate (ƛ)")
            
            TextField("Mean of Arrival Rate", text: $viewModel.arrivalRate)
                .keyboardType(.decimalPad)
        }
    }
    
    func ArrivalMeanExponentialDistribution() -> some View {
        Section {
            Text("Arrival Mean Of Exponential Distribution (ƛ)")
            
            TextField("Arrival Mean Exponential Distribution", text: $viewModel.arrivalMeanOfExpDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func ArrivalVarianceExponentialDistribution() -> some View {
        Section {
            Text("Arrival Variance Of Exponential Distribution")
            
            TextField("Arrival Variance Exponential Distribution", text: $viewModel.arrivalVariacneOfExpDist)
                .keyboardType(.decimalPad)
        }
    }

    
    func ServiceRateView() -> some View {
        Section {
            Text("Mean of Service Rate (μ)")
            
            TextField("Service Rate (μ)", text: $viewModel.serviceRate)
                .keyboardType(.decimalPad)
        }
    }
    
    func ServiceMeanNormalDistribution() -> some View {
        Section {
            Text("Service Mean of Normal Distribution")
            
            TextField("Service Mean Normal Distribution", text: $viewModel.serviceMeanUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func ServiceVarianceNormalDistribution() -> some View {
        Section {
            Text("Service Variance of Normal Distribution")
            
            TextField("Service Variance Normal Distribution", text: $viewModel.serviceVarianceUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    

    
    func MinimumUniformDistribution() -> some View {
        Section {
            Text("Minimum Uniform Distribution")
            
            TextField("Minimum Uniform Distribution", text: $viewModel.minimumUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func MaximumUniformDistribution() -> some View {
        Section {
            Text("Maximum Uniform Distribution")
            
            TextField("Maximum Uniform Distribution", text: $viewModel.maximumUniformDist)
                .keyboardType(.decimalPad)
        }
    }
}

struct QueryingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QueryingView()
        }
        .preferredColorScheme(.dark)
    }
}
