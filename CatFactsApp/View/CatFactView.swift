//
//  CatFactView.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/16/25.
//

import Foundation
import SwiftUI

struct CatFactView: View {
    @StateObject var catFactsViewModel: CatFactsViewModel = CatFactsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.4)]),
                                startPoint: .top,
                                endPoint: .bottom)
                     .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Cat Fact")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            if catFactsViewModel.isLoading && catFactsViewModel.errorMessage == nil {
                                ProgressView("Loading")
                            } else {
                                if let errorMessage = catFactsViewModel.errorMessage {
                                    Text(errorMessage)
                                        .font(.headline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .frame(maxWidth: geometry.size.width * 0.9)
                                } else {
                                    if let image = catFactsViewModel.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: geometry.size.width * 0.8)
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                            .padding(.horizontal)
                                    } else {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.gray)
                                            .opacity(0.7)
                                            .padding(.horizontal)
                                    }
                                    
                                    if let fact = catFactsViewModel.catFact?.data.first {
                                        Text(fact)
                                            .font(.headline)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.black.opacity(0.5))
                                            .cornerRadius(10)
                                            .shadow(radius: 5)
                                            .frame(maxWidth: geometry.size.width * 0.9)
                                    }
                                    
                                    Spacer(minLength: 20)
                                }
                            }
                        }
                        .padding(.top, 40)
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }
            .onTapGesture {
                // Fetch new fact and image
                    self.catFactsViewModel.fetchCatFactAndImage()
            }
        }
        .onAppear {
            self.catFactsViewModel.fetchCatFactAndImage()
        }
    }
}

#Preview {
    CatFactView()
}

