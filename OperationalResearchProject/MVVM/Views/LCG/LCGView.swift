//
//  LCGView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 28/01/2024.
//

import SwiftUI

struct LCGView: View {
    
    @StateObject var viewModel = LCGViewModel()
    
    var body: some View {
        List {
            
            LCGInputView(viewModel: viewModel, type: .a, text: $viewModel.inputA)
            
            LCGInputView(viewModel: viewModel, type: .m, text: $viewModel.inputM)
            
            LCGInputView(viewModel: viewModel, type: .c, text: $viewModel.inputC)
            
            LCGInputView(viewModel: viewModel, type: .priority, text: $viewModel.inputPriority)
            
            LCGInputView(viewModel: viewModel, type: .noOfSimulation, text: $viewModel.inputIteration)
            
            Button("Show Results") {
                viewModel.calculateResults()
            }
            .frame(height: 80)
            .padding(.horizontal)
        }
        .navigationTitle("LCG")
        .navigationBarTitleDisplayMode(.large)
//        .toolbarBackground(.visible, for: .navigationBar)
        .keyboardType(.numberPad)
        .font(.title)
        .padding()
        .navigationDestination(isPresented: $viewModel.showResults) {
            LCGTableView(viewModel: viewModel)
        }
    }
}

struct LCGInputView: View {
    
    @ObservedObject var viewModel: LCGViewModel
    @State var type: LCGFieldType
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
                    .foregroundStyle(viewModel.errorType == type ? .red : .white)
                    .foregroundStyle(.red)
                
                TextField("", text: $text)
                    .padding(.leading)
            }
            .frame(height: 80)
            
            if viewModel.errorType == type {
                Text(viewModel.errorMessage)
                    .foregroundStyle(.red)
            }
        }
    }
}

struct LCGTableView: View {
    
    @ObservedObject var viewModel: LCGViewModel
    
    
    var body: some View {
        if #available(iOS 17.0, *) {
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
            .font(.title3)
        }
    }
}

#Preview {
    NavigationStack {
        LCGView().preferredColorScheme(.dark)
    }
}
