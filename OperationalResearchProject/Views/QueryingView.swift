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
    
    //    @State var serverType: ServerType = .none
    @State private var serverType = 0
    @State private var numberOfServers = ""
    
    var body: some View {
        
//        ZStack {
            
            List {
                
                VStack {
                    
                    Text("Server Type")
                    
                    Picker(selection: $serverType, label: Text("Picker")) {
                        Text(ServerType.mmc.rawValue)
                            .tag(0)
                        
                        Text(ServerType.mmg.rawValue)
                            .tag(1)
                        
                        Text(ServerType.ggc.rawValue)
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                }
                .frame(width: width - 50, alignment: .leading)
                .background(.white)
                
                Section {
                    
                    Text("Number of Servers")
                    
                    TextField("Enter Number of Servers", text: $numberOfServers)
                        .keyboardType(.numberPad)
                }
                
                Text("Mean of InterArrival")
            }
            .listRowSeparator(.hidden, edges: .all)
//        }
        .navigationTitle("Quering Model")
        .navigationBarBackButtonHidden(true)
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

struct NavigationBar: View {
    
    @State var title: String
    @State var showBackButton: Bool
    
    var body: some View {
        
        ZStack {
            
            HStack {
                
                Image(systemName: "arrow.left")
                    .padding()
                
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 20, weight: .black))
                .lineLimit(1)
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
