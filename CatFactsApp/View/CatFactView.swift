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
        ZStack{
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    //download new fact and image
                    self.catFactsViewModel.fetchCatFactAndImage()
                }
            
            
            ProgressView()
                .opacity(self.catFactsViewModel.isLoading && self.catFactsViewModel.errorMessage == nil ? 1: 0)
            
            Text(self.catFactsViewModel.errorMessage ?? "")
            
            VStack {
                
                Spacer()
                
                Text("Cat Fact")
                    .multilineTextAlignment(.center)
                    .font(.title)
                
                VStack {
                    
                    if let image = self.catFactsViewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                    
                    Text(self.catFactsViewModel.catFact?.data.first ?? "")
                        .multilineTextAlignment(.center)
                        .padding(.all, 10)
                    
                    Spacer()
                }.opacity(self.catFactsViewModel.isLoading && self.catFactsViewModel.errorMessage == nil ? 0: 1)
            }
        }.onAppear{
            //initial fact and image
            self.catFactsViewModel.fetchCatFactAndImage()
        }
    }
}

#Preview {
    CatFactView()
}

