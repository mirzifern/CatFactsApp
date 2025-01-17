//
//  CatFactsAppIntentHandler.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/17/25.
//

import Foundation

func CatFactsAppIntentHandler (state: inout CatFactsAppState, intent: CatFactsAppIntent){
    switch intent {
    case .FetchCatFact:
        state.isLoading = true
        state.errorMessage = nil
        state.catImage = nil
        state.catFact = nil
    case .FetchCatFactSuccess(let fact, let image):
        state.isLoading = false
        state.errorMessage = nil
        state.catFact = fact
        state.catImage = image
    case .Error(let error):
        state.isLoading = false
        state.errorMessage = error
        state.catImage = nil
        state.catFact = nil
    }
}
