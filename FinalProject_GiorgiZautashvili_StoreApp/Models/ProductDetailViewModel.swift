//
//  ProductDetailViewModel.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 29.04.25.
//


import Foundation

class ProductDetailViewModel {
    let product: ProductQuantity
    
    init(product: ProductQuantity) {
        self.product = product
    }
    
    var title: String {
        product.product.title
    }
    
    var description: String {
        product.product.description
    }
    
    var price: String {
        String(format: "%.2f", product.product.price)
    }
    
    var stock: String {
        "მარაგშია: \(product.product.stock)"
    }
    
    var imageURL: String? {
        product.product.images.first
    }
}
