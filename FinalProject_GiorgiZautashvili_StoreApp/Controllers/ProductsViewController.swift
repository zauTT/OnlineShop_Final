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
    private var products: [ProductQuantity] = []
    private var tableView = UITableView()
    private var cartView = CartSummaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        addLogoutButton()
        configureLogoutButton()
        bindViewModel()
        setupCartView()
        setupTableView()
        viewModel.fetchProducts()
    }
    
    func onCartClearedAfterPayment() {
        viewModel.reduceStockAfterPurchase()
        tableView.reloadData()
    }
    
    private func bindViewModel() {
        viewModel.onLogout = { [weak self] in
            DispatchQueue.main.async {
                self?.goToLoginScreen()
            }
        }
        
        viewModel.onProductsFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.products = self?.viewModel.products ?? []
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onCartUpdated = { [weak self] itemCount, totalPrice in
            DispatchQueue.main.async {
                self?.cartView.updateCart(totalItems: itemCount, totalPrice: totalPrice)
            }
        }
    }
    
    private func goToLoginScreen() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else { return }
        
        let loginVC = LoginScreenViewController()
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }
    
    private func setupUI() {
        addApplogoImageView()
    }
    
    private func addApplogoImageView() {
        if let largeImage = UIImage(named: "AppLogo") {
            let smallImage = largeImage.resized(to: CGSize(width: 90, height: 90))
            appLogoImageView.image = smallImage
        }
        
        view.addSubview(appLogoImageView)
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.widthAnchor.constraint(equalToConstant: 45),
            logoutButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func configureLogoutButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right", withConfiguration: config)
        logoutButton.setImage(image, for: .normal)
        logoutButton.tintColor = .systemBlue
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "ექაუნთიდან გამოსვლა", message: "გსურთ გამოსვლა?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "გაუქმება", style: .cancel))
        alert.addAction(UIAlertAction(title: "გამოსვლა", style: .destructive) { _ in
            self.viewModel.logout()
        })
        present(alert, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        tableView.register(ProductsCell.self, forCellReuseIdentifier: ProductsCell.identifier)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshProducts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: appLogoImageView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: cartView.topAnchor)
        ])
    }
    
    private func setupCartView() {
        view.addSubview(cartView)
        cartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cartView.heightAnchor.constraint(equalToConstant: 80)
        ])
        cartView.addTarget(self, action: #selector(goToCartTapped), for: .touchUpInside)
    }
    
    @objc private func refreshProducts() {
        viewModel.fetchProducts()
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc private func goToCartTapped() {
        let cartItems = viewModel.products.filter { $0.quantity > 0 }
        let cartVC = CartViewController(viewModel: viewModel.cartViewModel)
        cartVC.configure(with: cartItems)
        
        cartVC.onCartUpdated = { [weak self] in
            self?.viewModel.refreshCartSummary()
        }
        
        cartVC.onCartItemRemoved = { [weak self] removedItem in
            self?.viewModel.removeProductCompletely(removedItem)
        }
        
        cartVC.onCartClearedAfterPayment = { [weak self] in
            self?.onCartClearedAfterPayment()
        }
        
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    @objc private func paymentSuccess() {
        
        viewModel.clearCartAfterPayment()

        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sortedCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = viewModel.sortedCategories[section]
        return viewModel.grouppedProducts[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sortedCategories[section].capitalized
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.sortedCategories[indexPath.section]
        if let item = viewModel.grouppedProducts[category]?[indexPath.row] {
            let detailVM = ProductDetailViewModel(product: item)
            let detailVC = ProductDetailViewController(viewModel: detailVM)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductsCell.identifier, for: indexPath) as? ProductsCell else {
            return UITableViewCell()
        }
        
        let category = viewModel.sortedCategories[indexPath.section]
        
        guard let productQuantity = viewModel.grouppedProducts[category]?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let product = productQuantity.product
        
        cell.titleLabel.text = product.title
        cell.priceLabel.text = "₾\(product.price)"
        cell.stockLabel.text = "მარაგშია: \(product.stock)"
        
        cell.backgroundColor = .systemBackground
        
        cell.configure(with: productQuantity.quantity)
        
        cell.onIncrease = { [weak self] in
            self?.viewModel.increaseQuantity(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.onDecrease = { [weak self] in
            self?.viewModel.decreaseQuantity(at: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let imageUrl = product.images.first {
            cell.productImageView.loadImage(from: imageUrl)
        } else {
            cell.productImageView.image = UIImage(named: "placeholder")
        }
        
        cell.onQuantityChange = { newQuantity in
            productQuantity.quantity = newQuantity
        }
        
        return cell
    }
}
