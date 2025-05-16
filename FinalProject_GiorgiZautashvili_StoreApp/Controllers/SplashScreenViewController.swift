//
//  SplashScreenViewController.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//


import UIKit

class SplashScreenViewController: UIViewController {
    
    private let logoImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLogo()
        checkLoginStatus()
    }
    
    private func setupLogo() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        
        if let logo = UIImage(named: "CityMallLogo") {
            logoImageView.image = logo
        }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func checkLoginStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
            
            if isLoggedIn {
                self.goToProducts()
            } else {
                self.goToLogin()
            }
        }
    }
    
    private func goToProducts() {
        let productsVC = ProductsViewController()
        productsVC.modalPresentationStyle = .fullScreen
        present(productsVC, animated: true)
    }
    
    private func goToLogin() {
        let loginVC = LoginScreenViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}
