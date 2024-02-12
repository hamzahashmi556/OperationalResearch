//
//  RandomNumberView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 18/08/2023.
//

import SwiftUI

struct RandomNumberView: View {
    
    @StateObject var viewModel = RandomViewModel()
    
    @State var lambda = ""
    @State var meo = ""
    
    var body: some View {
        List {
            
            lambdaView()
            
            
            MeoView()
            
            Section {
                Button {
                    viewModel.calculateValues(lambda: self.lambda, meo: self.meo)
                } label: {
                    Text("Calculate")
                }
            }
            
            if viewModel.showResult {
                Section {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 5) {
                            
                            Group {
                                ColoumnView(title: "X", data: [0,1,2,3,4,5,6,7,8,9], showTotal: false)
                                
                                ColoumnView(title: "CP", data: viewModel.cumulativeList, showTotal: false)
                                
                                ColoumnView(title: "Lookup", data: viewModel.lookUpList, showTotal: false)
                                
                                ColoumnView(title: "Avg Time b/w arrivals", data: viewModel.avgTimeBtwArrivals, showTotal: false)
                                
                                ColoumnView(title: "IA", data: viewModel.interArrivals, showTotal: true)
                                
                                ColoumnView(title: "AT", data: viewModel.arrivalTimes, showTotal: false)
                            }
                            
                            Group {
                                
                                ColoumnView(title: "Service Times", data: viewModel.serviceTimes, showTotal: true)
                                
                                ColoumnView(title: "Start Time", data: viewModel.startTimes, showTotal: false)
                                
                                ColoumnView(title: "End Times", data: viewModel.endTimes, showTotal: false)
                                
                                ColoumnView(title: "Turn Around", data: viewModel.turnArounds, showTotal: true)
                                
                                
                                ColoumnView(title: "Wait Times", data: viewModel.waitTimes, showTotal: true)
                                
                                ColoumnView(title: "Response Times", data: viewModel.responseTimes, showTotal: true)
                            }
                        }
                    }
                }
                
                
                Section {
                    let totalIA = viewModel.interArrivals.reduce(0, +)
                    Text("Average Inter Arrival Time: \(String(format: "%.2f", totalIA / 10))")
                    
                    let totalService = viewModel.serviceTimes.reduce(0, +)
                    Text("Service Time: \(String(format: "%.2f", totalService / 10))")
                    
                    let totalTA = viewModel.turnArounds.reduce(0, +)
                    Text("Turn Around Time: \(String(format: "%.2f", totalTA / 10))")
                    
                    
                    let totalWT = viewModel.waitTimes.reduce(0, +)
                    Text("Wait Time: \(String(format: "%.2f", totalWT / 10))")
                    
                    
                    let totalResponse = viewModel.responseTimes.reduce(0, +)
                    Text("Response Time Time: \(String(format: "%.2f", totalResponse / 10))")
                    
                    let probWaitingCustomers = Double(viewModel.waitTimes.filter({ $0 != 0 }).count) / Double(10)
                    Text("Probabilty of Waiting Customers: \(String(format: "%.2f", probWaitingCustomers))")
                    
                    let probNonWaitingCustomers = Double(viewModel.waitTimes.filter({ $0 == 0 }).count) / Double(10)
                    Text("Probabilty of Non Waiting Customers: \(String(format: "%.2f", probNonWaitingCustomers))")
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
//            viewModel.calculateValues(lambda: lambda, meo: meo)
        }
    }
    
    func lambdaView() -> some View {
        Section {
            
            Text("Enter Lambda")
            
            TextField("Enter Lambda Value", text: $lambda)
            
        }
    }
    
    func MeoView() -> some View {
        Section {
            Text("Enter Meo")
            
            TextField("Enter Meo Value", text: $meo)
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

struct RandomNumberView_Previews: PreviewProvider {
    static var previews: some View {
        RandomNumberView()
    }
}
