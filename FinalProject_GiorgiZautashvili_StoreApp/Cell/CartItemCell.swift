//
//  CartItemCell.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 01.05.25.
//


import UIKit

class CartItemCell: UITableViewCell {
    
    static let identifier = "CartItemCell"
    
    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let quantityLabel = UILabel()
    private let priceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        
        quantityLabel.font = .systemFont(ofSize: 14, weight: .regular)
        quantityLabel.textColor = .label
        
        priceLabel.font = .systemFont(ofSize: 15, weight: .bold)
        priceLabel.textColor = .label
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, quantityLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        contentView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            
            stack.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -10),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: ProductQuantity) {
        titleLabel.text = item.product.title
        quantityLabel.text = "x\(item.quantity)"
        priceLabel.text = String(format: "₾%.2f", item.product.price * Double(item.quantity))
        
        if let urlString = item.product.images.first, let url = URL(string: urlString) {
            productImageView.loadImage(from: url.absoluteString)
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
}
