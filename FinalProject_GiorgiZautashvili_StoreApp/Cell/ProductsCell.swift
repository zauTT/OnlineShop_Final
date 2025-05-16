//
//  ProductsCell.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 28.04.25.
//

import UIKit

class ProductsCell: UITableViewCell {
    
    static let identifier = "ProductCell"
    
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let stockLabel = UILabel()
    let priceLabel = UILabel()
    
    let decreaseButton = UIButton()
    let quantityLabel = UILabel()
    let increaseButton = UIButton()
    
    var onQuantityChange: ((Int) -> Void)?
    private var currentQuantity = 0
    
    var onIncrease: (() -> Void)?
    var onDecrease: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .label
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 8
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .label
        
        stockLabel.font = .systemFont(ofSize: 14)
        stockLabel.textColor = .label
        
        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .label
        
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.setTitleColor(.blue, for: .normal)
        decreaseButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        
        increaseButton.setTitle("+", for: .normal)
        increaseButton.setTitleColor(.blue, for: .normal)
        increaseButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        quantityLabel.text = "0"
        quantityLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [decreaseButton, quantityLabel, increaseButton])
        stack.axis = .horizontal
        stack.spacing = 1
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stack)
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            
            stockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            stockLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            stockLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
        ])
    }
    
    func configure(with quantity: Int) {
        currentQuantity = quantity
        quantityLabel.text = "\(quantity)"
    }
    
    @objc private func plusTapped() {
        onIncrease?()
    }

    @objc private func minusTapped() {
        onDecrease?()
    }
}

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(from urlString: String) {
        self.image = UIImage(named: "placeholder")
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self?.image = downloadedImage
                }
            }
        }.resume()
    }
}
