//
//  CatFactsAppState.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/17/25.
//

import Foundation
import SwiftUI

struct CatFactsAppState {
    var catFact: String? = nil
    var catImage: UIImage? = nil
    var errorMessage: String? = nil
    var isLoading: Bool = false
}
