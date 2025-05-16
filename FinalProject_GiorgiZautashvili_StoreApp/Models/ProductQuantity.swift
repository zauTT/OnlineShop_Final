//
//  ProductQuantity.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 29.04.25.
//


class ProductQuantity: Codable {
    var product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int = 0) {
        self.product = product
        self.quantity = quantity
    }   
}
