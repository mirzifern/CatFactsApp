//
//  CatFactsViewModel.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/16/25.
//

import Foundation
import SwiftUI

class CatFactsViewModel: ObservableObject {
    @Published var catFact: CatFact? = nil
    @Published var catImage: [CatImage] = []
    @Published var image: UIImage? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = true
    
    private let networkService: NetworkService
    
    private let catFactUrl = "https://meowfacts.herokuapp.com/"
    private let catImageUrl = "https://api.thecatapi.com/v1/images/search"
    
    init (networkService: NetworkService = NetworkServiceImplementation()) {
        self.networkService = networkService
    }
    
    func fetchCatFactAndImage() {
        self.errorMessage = nil
        self.isLoading = true
        fetchCatFact(from: self.catFactUrl)
        fetchCatImage(from: self.catImageUrl)
    }
    
    func fetchCatFact (from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        self.networkService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let data):
                    do {
                        self.catFact = try JSONDecoder().decode(CatFact.self, from: data)
                    } catch {
                        self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func fetchCatImage (from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        self.networkService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let data):
                    do {
                        self.catImage = try JSONDecoder().decode([CatImage].self, from: data)
                        // Download the image using the image URL
                        self.downloadImage(from: self.catImage.first?.url ?? "")
                    } catch {
                        self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    private func downloadImage(from imageURL: String) {
        guard let url = URL(string: imageURL) else {
            errorMessage = "Invalid URL"
            return
        }
        
        self.networkService.fetchData(from: url) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .success(let data):
                    if let downloadedImage = UIImage(data: data) {
                        self.image = downloadedImage
                    } else {
                        self.errorMessage = "Failed to load image"
                    }
                }
            }
        }
    }
}
