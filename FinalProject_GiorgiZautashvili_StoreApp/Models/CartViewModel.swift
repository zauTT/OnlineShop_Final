//
//  CartViewModel.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 01.05.25.
//

import Foundation

class CartViewModel {
    private let cartKey = "SavedCart"
    
    var cartItems: [ProductQuantity] = []
    
    var onCartChanged: (() -> Void)?
    
    var onCartUpdated: ((Int, Double) -> Void)?
    
    func fetchCartItems(from allProducts: [ProductQuantity]) {
        cartItems = allProducts.filter { $0.quantity > 0 }
        onCartChanged?()
        saveCartToUserDefaults()
    }
    
    func totalPrice() -> Double {
        return cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    func removeItem(at index: Int) -> ProductQuantity? {
        guard index < cartItems.count else { return nil }
        let removedItem = cartItems.remove(at: index)
        saveCartToUserDefaults()
        onCartChanged?()
        return removedItem
    }
    
    func saveCartToUserDefaults() {
        let data = try? JSONEncoder().encode(cartItems)
        UserDefaults.standard.set(data, forKey: cartKey)
    }
    
    func clearCart() {
        cartItems.removeAll()
        saveCartToUserDefaults()
        onCartChanged?()
    }
}
