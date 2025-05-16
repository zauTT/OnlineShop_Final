//
//  LoginViewModel.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//


import Foundation

class LoginViewModel {
    var onLoginSuccess: (() -> Void)?
    var onLoginFailure: ((String) -> Void)?
    
    func login(email: String?, password: String?) {
        guard let email = email, !email.isEmpty else {
            onLoginFailure?("გთხოვთ შეიყვანოთ ელ-ფოსტა")
            return
        }
        
        if !isValidEmail(email) {
            onLoginFailure?("ელ-ფოსტის ფორმატი არასწორია")
            return
        }
        
        guard let password = password, !password.isEmpty else {
            onLoginFailure?("გთხოვთ შეიყვანოთ პაროლი")
            return
        }
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        onLoginSuccess?()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
