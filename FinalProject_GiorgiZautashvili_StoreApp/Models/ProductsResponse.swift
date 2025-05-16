//
//  ProductsResponse.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//


struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    var stock: Int
    let tags: [String]?
    let brand: String?
    let sku: String?
    let weight: Double?
    let dimensions: Dimensions?
    let images: [String]
    
    struct Dimensions: Codable {
        let width: Double?
        let height: Double?
        let depth: Double?
    }
}
