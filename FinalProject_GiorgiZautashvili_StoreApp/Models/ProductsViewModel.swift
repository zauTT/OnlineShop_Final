import Foundation

class ProductsViewModel {
    
    var onLogout: (() -> Void)?
    
    func logout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        onLogout?()
    }
}