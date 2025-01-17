//
//  CatFactsViewModel.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/16/25.
//

import Foundation
import SwiftUI

class CatFactsViewModel: ObservableObject {
    @Published private(set) var state = CatFactsAppState()
    
    private let networkService: NetworkService
    private var catFact: CatFact? = nil
    private var catImage: [CatImage] = []
    
    private let catFactUrl = "https://meowfacts.herokuapp.com/"
    private let catImageUrl = "https://api.thecatapi.com/v1/images/search"
    
    init (networkService: NetworkService = NetworkServiceImplementation()) {
        self.networkService = networkService
    }
    
    func send(intent: CatFactsAppIntent) {
        DispatchQueue.main.async {
            CatFactsAppIntentHandler(state: &self.state, intent: intent)
        }
    }
    
    func fetchCatFactAndImage() {
        self.send(intent: .FetchCatFact)
        fetchCatFact(from: self.catFactUrl)
        fetchCatImage(from: self.catImageUrl)
    }
    
    func fetchCatFact (from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.send(intent: .Error("Invalid URL"))
            return
        }
        
        self.networkService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.send(intent: .Error(error.localizedDescription))
                case .success(let data):
                    do {
                        self.catFact = try JSONDecoder().decode(CatFact.self, from: data)
                    } catch {
                        self.send(intent: .Error("Failed to decode data: \(error.localizedDescription)"))
                    }
                }
            }
        }
    }
    
    func fetchCatImage (from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.send(intent: .Error("Invalid URL"))
            return
        }
        
        self.networkService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.send(intent: .Error(error.localizedDescription))
                case .success(let data):
                    do {
                        self.catImage = try JSONDecoder().decode([CatImage].self, from: data)
                        // Download the image using the image URL
                        self.downloadImage(from: self.catImage.first?.url ?? "")
                    } catch {
                        self.send(intent: .Error("Failed to decode data: \(error.localizedDescription)"))
                    }
                }
            }
        }
    }
    
    private func downloadImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else {
            self.send(intent: .Error("Invalid URL"))
            return
        }
        
        self.networkService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.send(intent: .Error(error.localizedDescription))
                case .success(let data):
                    if let downloadedImage = UIImage(data: data) {
                        if let catFact = self.catFact?.data.first {
                            self.send(intent: .FetchCatFactSuccess(catFact, downloadedImage))
                        } else {
                            self.send(intent: .FetchCatFact)
                        }
                    } else {
                        self.send(intent: .Error("Failed to load image"))
                    }
                }
            }
        }
    }
}
