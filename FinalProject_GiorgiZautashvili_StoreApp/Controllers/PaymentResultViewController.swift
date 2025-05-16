//
//  PaymentResultViewController.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 04.05.25.
//


import UIKit

class PaymentResultViewController: UIViewController {
    
    var onDismiss: (() -> Void)?
    
    private let iconView = UIImageView()
    private let messageLabel = UILabel()
    private let dismissButton = UIButton(type: .system)
    
    init(success: Bool, message: String) {
        super.init(nibName: nil, bundle: nil)
        
        setupUI(success: success, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(success: Bool, message: String) {
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        iconView.image = success ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "xmark.circle")
        iconView.tintColor = success ? .systemGreen : .systemRed
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 16, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.setTitle("უკან დაბრუნება", for: .normal)
        dismissButton.backgroundColor = .systemBlue
        dismissButton.setTitleColor(.white, for: .normal)
        dismissButton.layer.cornerRadius = 10
        dismissButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [iconView, messageLabel, dismissButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            dismissButton.heightAnchor.constraint(equalToConstant: 44),
            dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
        ])
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
        onDismiss?()
    }
}
