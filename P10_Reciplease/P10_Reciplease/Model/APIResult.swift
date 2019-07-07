//
//  APIResult.swift
//  P10_Reciplease
//
//  Created by macbook pro on 07/06/2019.
//  Copyright © 2019 macbook pro. All rights reserved.
//

import Foundation

struct APIResult: Decodable {
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe?
}

struct Recipe: Decodable {
    let label: String
    let image: URL?
    let url: URL
    let ingredientLines: [String]
    let totalTime: Double
}

