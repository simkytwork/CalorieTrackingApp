//
//  EdamamFood.swift
//  CalorieTrackingApp
//
//  Created by Simonas Kytra on 04/03/2024.
//

import Foundation

// for the Edamam API
struct EdamamItem: Decodable {
    let foodId: String
    let label: String
    let nutrients: Nutrients
    
    enum CodingKeys: String, CodingKey {
        case foodId
        case label
        case nutrients
    }
}

struct Nutrients: Decodable {
    let ENERC_KCAL: Double
    let PROCNT: Double
    let FAT: Double
    let CHOCDF: Double
    
    enum CodingKeys: String, CodingKey {
        case ENERC_KCAL
        case PROCNT
        case FAT
        case CHOCDF
    }
}

struct EdamamResponse: Decodable {
//    let parsed: [ParsedItem]
    let hints: [HintItem]
}

struct HintItem: Decodable {
    let food: EdamamItem
}

//struct ParsedItem: Decodable {
//    let food: EdamamItem
//}
