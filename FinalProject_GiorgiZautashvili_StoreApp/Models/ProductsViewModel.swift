//
//  ProductsViewModel.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//


import Foundation

class ProductsViewModel {
    
    private let cartKey = "SavedCart"
    
    private(set) var products: [ProductQuantity] = []
    var grouppedProducts: [String: [ProductQuantity]] = [:]
    var sortedCategories: [String] = []
    
    var onLogout: (() -> Void)?
    var onProductsFetched: (() -> Void)?
    var onCartUpdated: ((Int, Double) -> Void)?
    var onCartClearedAfterPayment: (() -> Void)?
    
    var cartViewModel = CartViewModel()
    
    func makeCartViewController() -> CartViewController {
        let cartVC = CartViewController(viewModel: cartViewModel)
        cartVC.productsViewModel = self
        return cartVC
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        onLogout?()
    }
    
    private func loadCartFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: cartKey),
              let savedItems = try? JSONDecoder().decode([ProductQuantity].self, from: data) else {
            return
        }
        
        for savedItem in savedItems {
            if let index = products.firstIndex(where: { $0.product.id == savedItem.product.id }) {
                products[index].quantity = savedItem.quantity
            }
        }
        
        cartViewModel.fetchCartItems(from: products)
    }
    
    func fetchProducts() {
        NetworkManager.shared.fetchProducts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedProducts):
                    let wrapped = fetchedProducts.map { ProductQuantity(product: $0) }
                    self?.products = wrapped
                    self?.loadCartFromUserDefaults()
                    self?.grouppedProductsByCategory(wrapped)
                    self?.onProductsFetched?()
                    self?.updateCartSummery()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func increaseQuantity(at indexPath: IndexPath) {
        let category = sortedCategories[indexPath.section]
        guard var items = grouppedProducts[category] else { return }
        
        let item = items[indexPath.row]
        if item.quantity < item.product.stock {
            item.quantity += 1
            items[indexPath.row] = item
            grouppedProducts[category] = items
            
            if let index = products.firstIndex(where: { $0.product.id == item.product.id }) {
                products[index].quantity = item.quantity
            }
            
            cartViewModel.fetchCartItems(from: products)
            onProductsFetched?()
            updateCartSummery()
            saveCartToUserDefaults()
        }
    }
    
    func decreaseQuantity(at indexPath: IndexPath) {
        let category = sortedCategories[indexPath.section]
        guard var items = grouppedProducts[category] else { return }
        
        let item = items[indexPath.row]
        if item.quantity > 0 {
            item.quantity -= 1
            items[indexPath.row] = item
            
            cartViewModel.fetchCartItems(from: products)
            
            grouppedProducts[category] = items
            onProductsFetched?()
            updateCartSummery()
            saveCartToUserDefaults()
        }
    }
    
    func removeFromCart(at index: Int) {
        guard index >= 0 && index < cartViewModel.cartItems.count else { return }
        
        let removedItem = cartViewModel.cartItems[index]
        
        _ = cartViewModel.removeItem(at: index)
        if let matchIndex = products.firstIndex(where: { $0.product.id == removedItem.product.id }) {
            products[matchIndex].quantity = 0
        }
        for (category, items) in grouppedProducts {
            if let itemIndex = items.firstIndex(where: { $0.product.id == removedItem.product.id }) {
                grouppedProducts[category]?[itemIndex].quantity = 0
            }
        }
        grouppedProductsByCategory(products)
        onProductsFetched?()
        updateCartSummery()
        saveCartToUserDefaults()
    }
    
    private func grouppedProductsByCategory(_ products: [ProductQuantity]) {
        let grouped = Dictionary(grouping: products, by: { $0.product.category })
        self.grouppedProducts = grouped
        self.sortedCategories = grouped.keys.sorted()
    }
    
    private func updateCartSummery() {
        let allItems = cartViewModel.cartItems
        let totalQuantity = allItems.reduce(0) { $0 + $1.quantity }
        let totalPrice = allItems.reduce(0) { $0 + (Double($1.quantity) * $1.product.price) }
        
        onCartUpdated?(totalQuantity, totalPrice)
    }
    
    func saveCartToUserDefaults() {
        let cartData = products.filter { $0.quantity > 0 }
        if let data = try? JSONEncoder().encode(cartData) {
            UserDefaults.standard.set(data, forKey: cartKey)
        }
    }
    
    func refreshCartSummary() {
        let totalQuantity = cartViewModel.cartItems.reduce(0) { $0 + $1.quantity }
        let totalPrice = cartViewModel.cartItems.reduce(0) { $0 + (Double($1.quantity) * $1.product.price) }
        onCartUpdated?(totalQuantity, totalPrice)
    }
    
    func removeProductCompletely(_ item: ProductQuantity) {
        if let index = products.firstIndex(where: { $0.product.id == item.product.id }) {
            products[index].quantity = 0
        }
        
        for (category, items) in grouppedProducts {
            if let i = items.firstIndex(where: { $0.product.id == item.product.id }) {
                grouppedProducts[category]?[i].quantity = 0
            }
        }
        
        cartViewModel.fetchCartItems(from: products)
        onProductsFetched?()
        updateCartSummery()
        saveCartToUserDefaults()
    }
    
    func reduceStockAfterPurchase() {
        for index in products.indices {
            let quantity = products[index].quantity
            if quantity > 0 {
                products[index].product.stock -= quantity
                products[index].quantity = 0
            }
        }
        
        for (category, items) in grouppedProducts {
            for i in items.indices {
                let quantity = items[i].quantity
                if quantity > 0 {
                    grouppedProducts[category]?[i].product.stock -= quantity
                    grouppedProducts[category]?[i].quantity = 0
                }
            }
        }
        cartViewModel.clearCart()
        saveCartToUserDefaults()
        grouppedProductsByCategory(products)
        onProductsFetched?()
        updateCartSummery()
        
        onCartClearedAfterPayment?()
    }
    
    func clearCartAfterPayment() {
        cartViewModel.clearCart()

        for index in products.indices {
            products[index].quantity = 0
        }

        for (category, items) in grouppedProducts {
            for index in items.indices {
                grouppedProducts[category]?[index].quantity = 0
            }
        }

        grouppedProductsByCategory(products)
        onProductsFetched?()
        updateCartSummery()
        saveCartToUserDefaults()
        onCartClearedAfterPayment?()
    }
}
