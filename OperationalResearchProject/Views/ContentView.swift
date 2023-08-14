//
//  ContentView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 14/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    private let width = UIScreen.main.bounds.width
    private let height = UIScreen.main.bounds.height
    
    var body: some View {
        
        NavigationView {
            
            BackgroundView {
                VStack(spacing: 15) {
                    
                    Spacer()
                    
                    NavigationLink {
                        QueryingView()
                    } label: {
                        Text("Quering Model")
                            .foregroundColor(.white)
                            .frame(width: width - 50, height: 50)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Random Number")
                            .foregroundColor(.white)
                            .frame(width: width - 50, height: 50)
                            .background(.green)
                            .cornerRadius(20)
                    }
                }
                .padding()
            }
        }
    }
}

struct BackgroundView<Content : View>: View {

    var content: () -> Content
    
    var body: some View {
        
        ZStack {
            
            Image("UBIT")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(x: -140)
                .ignoresSafeArea()
                .blur(radius: 10)
            
            
            content()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
