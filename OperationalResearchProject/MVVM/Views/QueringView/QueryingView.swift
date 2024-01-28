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
                    
                    Text("Fit Test")
                        .tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            if viewModel.serverType != 3 {
                NumberOfServersView()
            }
            
            if viewModel.serverType == 0 {
                ArrivalRateView()
                
                ServiceRateView()
            }
            else if viewModel.serverType == 1 {
                ArrivalMeanExponentialDistribution()
                
                MaximumUniformDistribution()
                
                MinimumUniformDistribution()
            }
            else if viewModel.serverType == 2 {
                ArrivalMeanExponentialDistribution()
                
                ArrivalVarianceExponentialDistribution()
                
                ServiceMeanNormalDistribution()
                
                ServiceVarianceNormalDistribution()
            }
            else {
                BinsView()
                
                ObservedFrequencies()
                
                DistributionType()
                
                if viewModel.fitTestResult != nil {
                    Section {
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            
                            HStack(spacing: 5) {
                                
                                ColoumnView(title: "Deaths", data: viewModel.bins, showTotal: false)
                                
                                ColoumnView(title: "Observed Frequency", data: viewModel.observedFrequencies, showTotal: true)
                                
                                ColoumnView(title: "MLE", data: viewModel.MLE, showTotal: true)
                                
                                ColoumnView(title: "EXP.FREQ", data: viewModel.expectedFrequencies, showTotal: true)
                                
                                ColoumnView(title: "Chi Square", data: viewModel.chiSquareResults, showTotal: true)
                                
                            }
                        }
                    }
                }
            }
            
            Button {
                viewModel.calculateResults()
            } label: {
                Text("Calculate")
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
            else if let result = viewModel.fitTestResult {
                Text(result.toResult())
                    .foregroundColor(.green)
            }
            
        }
        .scrollDismissesKeyboard(.interactively)
        .listRowSeparator(.hidden, edges: .all)
        .navigationTitle(viewModel.getHeader())
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
            Text("Mean of Arrival Rate (1/ƛ)")
            
            TextField("Enter Arrival Rate (ƛ)", text: $viewModel.arrivalRate)
                .keyboardType(.decimalPad)
        }
    }
    
    func ArrivalMeanExponentialDistribution() -> some View {
        Section {
            Text("Arrival Mean Of Exponential Distribution (1/ƛ)")
            
            TextField("Enter Exponential Distribution", text: $viewModel.arrivalMeanOfExpDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func ArrivalVarianceExponentialDistribution() -> some View {
        Section {
            Text("Arrival Variance Of Exponential Distribution")
            
            TextField("Enter Arrival Variance", text: $viewModel.arrivalVariacneOfExpDist)
                .keyboardType(.decimalPad)
        }
    }

    
    func ServiceRateView() -> some View {
        Section {
            Text("Mean of Service Rate (1/μ)")
            
            TextField("Enter Service Rate (μ)", text: $viewModel.serviceRate)
                .keyboardType(.decimalPad)
        }
    }
    
    func ServiceMeanNormalDistribution() -> some View {
        Section {
            Text("Service Mean of Normal Distribution (1/μ)")
            
            TextField("Enter Service Mean", text: $viewModel.serviceMeanUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func ServiceVarianceNormalDistribution() -> some View {
        Section {
            Text("Service Variance of Normal Distribution")
            
            TextField("Enter Service Variance", text: $viewModel.serviceVarianceUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    

    
    func MinimumUniformDistribution() -> some View {
        Section {
            Text("Minimum Uniform Distribution")
            
            TextField("Enter Minimum Distribution", text: $viewModel.minimumUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func MaximumUniformDistribution() -> some View {
        Section {
            Text("Maximum Uniform Distribution")
            
            TextField("Enter Maximum Distribution", text: $viewModel.maximumUniformDist)
                .keyboardType(.decimalPad)
        }
    }
    
    func BinsView() -> some View {
        Section {
            Text("Enter Comma Seperated Bins")

            TextField("Comma Seperated Bins", text: $viewModel.tfBins)
                .keyboardType(.numberPad)
        }
    }
    
    func ObservedFrequencies() -> some View {
        Section {
            
            Text("Enter Comma seperated Observed Frequencies")
            
            TextField("Expected Frequencies", text: $viewModel.tfFrequencies)
        }
    }
    
    func DistributionType() -> some View {
        Section {
            Picker("Distribution", selection: $viewModel.distributionIndex) {
                
                Text("Poission Distribution")
                    .tag(0)
                
                Text("Uniform Distribution")
                    .tag(1)
            }
            .pickerStyle(.segmented)
        }
    }
    
    func ColoumnView(title: String, data: [Double], showTotal: Bool) -> some View {
        Group {
            VStack {
                Text(title)
                    .font(.headline)
                    .frame(height: 40)
                
                Divider()
                
                ForEach(data, id: \.self) { element in
                    
                    Text(String(element))
                        .frame(height: 40)
                    
                    Divider()
                }
                
                Text(showTotal ? String(data.reduce(0, +)) : "")
                    .frame(height: 40)
            }
            
            Divider()
        }
    }
}

struct QueryingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            QueryingView()
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(.stack)
    }
}
