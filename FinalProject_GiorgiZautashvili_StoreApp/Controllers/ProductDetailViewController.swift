//
//  ProductDetailViewController.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 29.04.25.
//


import UIKit

class ProductDetailViewController: UIViewController {
    private let viewModel: ProductDetailViewModel
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()
    
    init(viewModel: ProductDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        configure()
    }
    
    func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        descriptionLabel.font = .systemFont(ofSize: 16)
        
        priceLabel.textColor = .gray
        stockLabel.textColor = .gray
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel, priceLabel, stockLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configure() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = "ფასი: \(viewModel.price)₾"
        stockLabel.text = viewModel.stock
        
        if let imageUrl = viewModel.imageURL {
            imageView.loadImage(from: imageUrl)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
