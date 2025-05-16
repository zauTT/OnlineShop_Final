//
//  CartSummaryView.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 30.04.25.
//

import UIKit

class CartSummaryView: UIButton {
    private let cartIcon = UIImageView()
    
    private let itemsLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ნივთი"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "₾0.00"
        return label
    }()
    
    private let goToCartLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBlue
        clipsToBounds = true
        
        addSubview(cartIcon)
        cartIcon.translatesAutoresizingMaskIntoConstraints = false
        cartIcon.image = UIImage(systemName: "cart")
        cartIcon.tintColor = .white
        
        addSubview(itemsLabel)
        itemsLabel.translatesAutoresizingMaskIntoConstraints = false
        itemsLabel.font = .systemFont(ofSize: 14, weight: .medium)
        itemsLabel.textColor = .white
        
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 14, weight: .medium)
        priceLabel.textColor = .white
        
        addSubview(goToCartLabel)
        goToCartLabel.translatesAutoresizingMaskIntoConstraints = false
        goToCartLabel.text = "კალათაში გადასვლა >"
        goToCartLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        goToCartLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            cartIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            cartIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            cartIcon.widthAnchor.constraint(equalToConstant: 24),
            cartIcon.heightAnchor.constraint(equalToConstant: 24),
            
            itemsLabel.leadingAnchor.constraint(equalTo: cartIcon.trailingAnchor, constant: 16),
            itemsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 23),
            
            priceLabel.leadingAnchor.constraint(equalTo: itemsLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: itemsLabel.bottomAnchor, constant: 4),
            
            goToCartLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            goToCartLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateCart(totalItems: Int, totalPrice: Double) {
        itemsLabel.text = "\(totalItems) ნივთი"
        priceLabel.text = "\(String(format: "₾%.2f", totalPrice))"
    }
}
