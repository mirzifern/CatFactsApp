//
//  CatFactsAppIntent.swift
//  CatFactsApp
//
//  Created by Mirzi Coleen Fernando on 1/17/25.
//

import Foundation
import SwiftUI

enum CatFactsAppIntent {
    case FetchCatFact
    case FetchCatFactSuccess (String, UIImage)
    case Error (String)
}
