//
//  LoginScreenViewController.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 27.04.25.
//


import UIKit

class LoginScreenViewController: UIViewController {
    
    private var welcomeTextField = UITextField()
    private var appLogoImageView = UIImageView()
    private var userEmailTextField = UITextField()
    private var userPasswordTextField = UITextField()
    private var loginButton = UIButton()
    
    private var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.goToProductsVC()
            }
        }
        
        viewModel.onLoginFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func setupUI() {
        addWelcomeTextField()
        configureWelcomeTextField()
        addAppLogoImageView()
        addUserEmailTextField()
        configureUserEmailTextField()
        addUserPasswordTextField()
        configureUserPasswordTextField()
        addLoginButton()
        configureLoginButton()
    }
    
    /// Mark: - Valiadation functions
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.login(email: userEmailTextField.text, password: userPasswordTextField.text)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "შეცდომა", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func goToProductsVC() {
        let productsVC = ProductsViewController()
        let navController = UINavigationController(rootViewController: productsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    /// Mark -  UI configuration
    
    private func addWelcomeTextField() {
        view.addSubview(welcomeTextField)
        welcomeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            welcomeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureWelcomeTextField() {
        welcomeTextField.textColor = .gray
        welcomeTextField.font = .systemFont(ofSize: 20, weight: .medium)
        welcomeTextField.textAlignment = .center
        welcomeTextField.text = "კეთილი იყოს თქვენი მობრძანება"
    }
    
    private func addAppLogoImageView() {
        
        if let largeImage = UIImage(named: "AppLogo") {
            let smallImage = largeImage.resized(to: CGSize(width: 150, height: 150))
            appLogoImageView.image = smallImage
        }
        
        view.addSubview(appLogoImageView)
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appLogoImageView.topAnchor.constraint(equalTo: welcomeTextField.bottomAnchor, constant: 60),
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addUserEmailTextField() {
        view.addSubview(userEmailTextField)
        userEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userEmailTextField.topAnchor.constraint(equalTo: appLogoImageView.bottomAnchor, constant: 30),
            userEmailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userEmailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userEmailTextField.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func configureUserEmailTextField() {
        userEmailTextField.backgroundColor = .systemBackground
        userEmailTextField.borderStyle = .roundedRect
        userEmailTextField.layer.borderColor = UIColor.gray.cgColor
        userEmailTextField.layer.borderWidth = 1
        userEmailTextField.layer.cornerRadius = 10
        userEmailTextField.clipsToBounds = true
        userEmailTextField.placeholder = "ელ-ფოსტა"
        userEmailTextField.autocapitalizationType = .none
        userEmailTextField.keyboardType = .emailAddress
    }
    
    private func addUserPasswordTextField() {
        view.addSubview(userPasswordTextField)
        userPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userPasswordTextField.topAnchor.constraint(equalTo: userEmailTextField.bottomAnchor, constant: 5),
            userPasswordTextField.leadingAnchor.constraint(equalTo: userEmailTextField.leadingAnchor),
            userPasswordTextField.trailingAnchor.constraint(equalTo: userEmailTextField.trailingAnchor),
            userPasswordTextField.heightAnchor.constraint(equalTo: userEmailTextField.heightAnchor)
        ])
    }
    
    private func configureUserPasswordTextField() {
        userPasswordTextField.backgroundColor = .systemBackground
        userPasswordTextField.borderStyle = .roundedRect
        userPasswordTextField.layer.borderColor = UIColor.gray.cgColor
        userPasswordTextField.layer.borderWidth = 1
        userPasswordTextField.layer.cornerRadius = 10
        userPasswordTextField.clipsToBounds = true
        userPasswordTextField.placeholder = "პაროლი"
        userPasswordTextField.isSecureTextEntry = true
    }
    
    private func addLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: userPasswordTextField.bottomAnchor, constant: 5),
            loginButton.leadingAnchor.constraint(equalTo: userEmailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: userEmailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalTo: userEmailTextField.heightAnchor)
        ])
    }
    
    private func configureLoginButton() {
        loginButton.setTitle("ავტორიზაცია", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    /// Mark: - Keyboard push UI
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0 {
            view.frame.origin.y = -150
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
