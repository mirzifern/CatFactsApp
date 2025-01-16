//
//  URLSessionService.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/16/25.
//

import Foundation

// MARK: - PROTOCOL
protocol NetworkService {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

//MARK: - Network Service Implementation
class NetworkServiceImplementation: NetworkService {
    func fetchData(from url: URL, completion: @escaping (Result<Data, any Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let data = data {
                        completion(.success(data))
                    }
                }.resume()
    }
}
