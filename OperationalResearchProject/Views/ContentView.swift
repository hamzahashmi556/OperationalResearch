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
            
            ZStack {
                
                Image("UBIT")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 13)
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "scissors.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(-90))
                        
                        Text("STYLO HAIR SALOON")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                        //                            .background(.black.opacity(0.1))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                        
                        
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .overlay {
                                Image(systemName: "comb")
                                    .scaleEffect(2)
                                    .rotationEffect(.degrees(135))
                                    .foregroundColor(.black)
                            }
                        
                        
                    }
                    
                    Spacer()
                }
                
                ZStack {
                    
                    VStack(spacing: 10) {
                        
                        Text("Group Members")
                            .font(.headline)
                        
                        HStack {
                            Text("Arham Sharif")
                            
                            Spacer()
                            
                            Text("EB21102022")
                        }
                        
                        HStack {
                            Text("Hamza Alam Hashmi")
                            
                            Spacer()
                            
                            Text("EB21102031")
                        }
                        
                        HStack {
                            Text("Muhammad Riaz Akram")
                            
                            Spacer()
                            
                            Text("EB21102077")
                        }
                    }
                }
                .frame(width: width - 80)
                .padding()
                .background(.black.opacity(0.7))
                .cornerRadius(10)
                
                
                VStack(spacing: 15) {
                    
                    Spacer()
                    
                    NavigationLink {
                        QueryingView()
                    } label: {
                        HStack {
                            
                            Spacer()
                            
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text("Quering Model")
                                .frame(width: 150)
                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .frame(width: width - 50, height: 50)
                        .background(.black.opacity(0.5))
                        .cornerRadius(30)
                    }
                    
                    NavigationLink {
                        RandomNumberView()
                    } label: {
                        HStack {
                            
                            Spacer()
                            
                            Image(systemName: "dice")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text("Random Number")
                                .frame(width: 150)
                            
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .frame(width: width - 50, height: 50)
                        .background(.white)
                        .cornerRadius(30)
                    }
                }
                .padding()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
