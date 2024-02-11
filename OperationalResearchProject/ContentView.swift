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
        
        NavigationStack {
            
            ZStack {
                
                // 1. Background Image
                Image("UBIT")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .blur(radius: 25)
                
                
                VStack {
                    
                    // Top Bar
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
                    
                    // Group Members
                    ZStack {
                        
                        VStack(spacing: 10) {
                            
                            Text("Group Members")
                                .font(.system(size: 50, weight: .bold))
                            
                            NameView(name: "Arham Sharif", seatNo: "EB21102022")
                            
                            NameView(name: "Hamza Alam Hashmi", seatNo: "EB21102031")
                            
                            NameView(name: "Muhammad Riaz Akram", seatNo: "EB21102077")
                            
                        }
                        .font(.system(size: 30, weight: .medium))
                    }
                    .frame(width: width - 80)
                    .padding()
                    .background(.black.opacity(0.7))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    VStack {
                        
                        NavigationLink {
                            MM1PriorityView()
                        } label: {
                            CustomButton(imageName: "arrowshape.turn.up.backward.badge.clock", title: "MM1 With Priority")
                        }

                        
                        NavigationLink {
                            LCGView()
                        } label: {
                            CustomButton(imageName: "arrow.circlepath", title: "LCG")
                        }
                        
                        NavigationLink {
                            QueryingView()
                        } label: {
                            CustomButton(imageName: "doc.text.magnifyingglass", title: "Quering Model")
                        }
                        
                        NavigationLink {
                            RandomNumberView()
                        } label: {
                            CustomButton(imageName: "dice", title: "Random Number")
                        }
                    }
                    .padding()
                    .cornerRadius(25)
                }
            }
        }
    }
    
    func NameView(name: String, seatNo: String) -> some View {
        HStack {
            Text(name)
            
            Spacer()
            
            Text(seatNo)
        }
    }
    
    func CustomButton(imageName: String, title: String) -> some View {
        HStack(spacing: 20) {
            
            Image(systemName: imageName)
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(title)
                .frame(width: 250, alignment: .leading)
                .font(.system(size: 30, weight: .bold))
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 30)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 50)
        .frame(width: width * 0.8, height: 100)
        .background(.black.opacity(0.7))
        .cornerRadius(50)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
