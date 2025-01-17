//
//  CatFactsAppTests.swift
//  CatFactsAppTests
//
//  Created by Mirzi Coleen Fernando on 1/16/25.
//

import Testing
import XCTest
import Foundation
@testable import CatFactsApp

class CatFactsAppTests: XCTestCase, Sendable {
    var viewModel: CatFactsViewModel!
    var networkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        viewModel = CatFactsViewModel(networkService: networkService)
    }
    
    override func tearDown() {
        viewModel = nil
        networkService = nil
        super.tearDown()
    }
    
   func testFetchCatFactSuccess() async throws {
        let catFact = "The color of the points in Siamese cats is heat related. Cool areas are darker."
        let json = """
          {
            "data": [
              "\(catFact)"
            ]
          }
""".data(using: .utf8)!
        
        self.networkService.mockData = json
        
        let expectation = XCTestExpectation(description: "Fetch Cat Fact")
        viewModel.fetchCatFact(from: "https://meowfacts.herokuapp.com/")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.state.isLoading, false)
            expectation.fulfill()
        }

        await fulfillment(of:[expectation], timeout: 1.0, enforceOrder: false)
    }
    
    func testFetchCatFactFail() async throws {
        self.networkService.mockError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        let expectation = XCTestExpectation(description: "Fetch Cat Fact Fail")
        viewModel.fetchCatFact(from: "https://meowfacts.herokuapp.com/")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertNil(self.viewModel.state.catFact)
            XCTAssertEqual(self.viewModel.state.errorMessage, "Network error")
            expectation.fulfill()
        }

        await fulfillment(of:[expectation], timeout: 1.0, enforceOrder: false)
    }
    
    func testFetchCatImageSuccess() async throws {
        let catImageURL = "https://cdn2.thecatapi.com/images/4tp.jpg"
        let json = """
[
  {
    "id": "4tp",
    "url": "\(catImageURL)",
    "width": 500,
    "height": 335
  }
]
""".data(using: .utf8)!
        
        self.networkService.mockData = json
        
        let expectation = XCTestExpectation(description: "Fetch Cat Image")
        viewModel.fetchCatImage(from: "https://meowfacts.herokuapp.com/")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.state.isLoading, false)
            expectation.fulfill()
        }

        await fulfillment(of:[expectation], timeout: 1.0, enforceOrder: false)
    }
    
    func testFetchCatImageFailure() async throws {
        self.networkService.mockError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        
        let expectation = XCTestExpectation(description: "Fetch Cat Image")
        viewModel.fetchCatImage(from: "https://meowfacts.herokuapp.com/")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.state.isLoading, false)
            XCTAssertEqual(self.viewModel.state.errorMessage, "Network error")
            expectation.fulfill()
        }

        await fulfillment(of:[expectation], timeout: 1.0, enforceOrder: false)
    }
}

//MARK: Mock Network Service
class MockNetworkService: NetworkService {
    var mockData: Data?
    var mockError: Error?

    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let data = mockData {
            completion(.success(data))
        }
    }
}
