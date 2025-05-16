//
//  ProductsViewController.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//


import UIKit

class ProductsViewController: UIViewController {
    
    private var appLogoImageView = UIImageView()
    private var logoutButton = UIButton()
    
    private var viewModel = ProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        addLogoutButton()
        configureLogoutButton()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onLogout = { [weak self] in
            DispatchQueue.main.async {
                self?.goToLoginScreen()
            }
        }
    }
    
    private func goToLoginScreen() {
        let loginVC = LoginScreenViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    private func setupUI() {
        addApplogoImageView()
    }
    
    private func addApplogoImageView() {
        if let largeImage = UIImage(named: "CityMallLogo") {
            let smallImage = largeImage.resized(to: CGSize(width: 90, height: 90))
            appLogoImageView.image = smallImage
        }
        
        view.addSubview(appLogoImageView)
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.widthAnchor.constraint(equalToConstant: 45),
            logoutButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureLogoutButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: config)
        logoutButton.setImage(image, for: .normal)
        logoutButton.tintColor = .black
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonTapped() {
        viewModel.logout()
    }
    
}

import SwiftUI

#Preview {
    ProductsViewController()
}
