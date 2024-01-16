//
//  ContentView.swift
//  OperationalResearchProject
//
//  Created by Hamza Hashmi on 14/08/2023.
//

import SwiftUI
import Charts

struct ContentView: View {
    
    private let width = UIScreen.main.bounds.width
    private let height = UIScreen.main.bounds.height
    
    @State var foregroundColor = Color.black
    @State var backgroundColor = Color.white
    
    @State var imageSize: CGFloat = 80.0
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Image("UBIT")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 25)
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "scissors.circle")
                            .resizable()
                            .frame(width: imageSize, height: imageSize)
                            .foregroundStyle(foregroundColor)
                            .rotationEffect(.degrees(-90))
                        
                        Text("STYLO HAIR SALOON")
                            .font(.system(size: 50, weight: .bold))
                            .padding()
                            .cornerRadius(20)
                            .foregroundStyle(foregroundColor)
                        
                        
                        Circle()
                            .frame(width: imageSize, height: imageSize)
                            .foregroundStyle(foregroundColor)
                            .overlay {
                                Image(systemName: "comb")
                                    .scaleEffect(2)
                                    .rotationEffect(.degrees(135))
                                    .foregroundColor(backgroundColor)
                            }
                    }
                    
                    Spacer()
                }
                
                ZStack {
                    
                    VStack(spacing: 10) {
                        
                        Text("Group Members")
                            .font(.system(size: 50, weight: .bold))
                        
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
                    .font(.system(size: 30, weight: .medium))
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
                                .frame(width: 250)
                                .font(.system(size: 30, weight: .bold))

                            
                            Spacer()
                        }
                        .foregroundColor(.white)
                        .frame(width: width * 0.8, height: 100)
                        .background(.black.opacity(0.8))
                        .cornerRadius(50)
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
                                .frame(width: 250)
                                .font(.system(size: 30, weight: .bold))
                            
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .frame(width: width * 0.8, height: 100)
                        .background(.white)
                        .cornerRadius(50)
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
