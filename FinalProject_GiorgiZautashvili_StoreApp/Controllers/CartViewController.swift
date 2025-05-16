//
//  CartViewController.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 01.05.25.
//

import UIKit

class CartViewController: UIViewController {
    
    private let tableView = UITableView()
    public private(set) var viewModel = CartViewModel()
    private var titleTextField = UITextField()
    private let payButton = UIButton()
    private let summaryView = CartFooterSummaryView()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "კალათა ცარიელია"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    var productsViewModel: ProductsViewModel?
    
    private let userBalanceKey = "userBalance"
    private var userBalance: Double {
        get {
            UserDefaults.standard.object(forKey: userBalanceKey) as? Double ?? 30.0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userBalanceKey)
        }
    }
    
    var onCartUpdated: (() -> Void)?
    var onCartItemRemoved: ((ProductQuantity) -> Void)?
    var onCartClearedAfterPayment: (() -> Void)?
    
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if UserDefaults.standard.object(forKey: userBalanceKey) == nil {
            userBalance = 30.0
        }
        
        setupUI()
        bindViewModel()
        updateEmptyState()
        
        payButton.addTarget(self, action: #selector(handlePayment), for: .touchUpInside)
        
        
        
        let balanceButton = UIBarButtonItem(
            image: UIImage(systemName: "creditcard"),
            style: .plain,
            target: self,
            action: #selector(updateBalanceTapped)
        )
        navigationItem.rightBarButtonItem = balanceButton
    }
    
    func configure(with cartProducts: [ProductQuantity]) {
        viewModel.fetchCartItems(from: cartProducts)
        updateSummaryLabels()
    }
    
    private func bindViewModel() {
        viewModel.onCartChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.updateSummaryLabels()
                self?.payButton.isEnabled = !(self?.viewModel.cartItems.isEmpty ?? true)
                self?.payButton.alpha = self?.payButton.isEnabled == true ? 1.0 : 0.5
                self?.updateEmptyState()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onCartUpdated?()
    }
    
    private func updateSummaryLabels() {
        let totalPrice = viewModel.cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
        let fee = totalPrice * 0.10
        let deliveryFee = 5.0
        let totalWithFees = totalPrice + fee + deliveryFee
        let balance = userBalance
        
        summaryView.updateSummary(
            totalPrice: totalPrice,
            balance: balance,
            fee: fee,
            delivery: deliveryFee,
            totalWithFees: totalWithFees
        )
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.cartItems.isEmpty
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        payButton.isEnabled = !isEmpty
        payButton.alpha = isEmpty ? 0.5 : 1.0
    }
    
    private func setupUI() {
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.text = "გადახდის გვერდი"
        titleTextField.font = .systemFont(ofSize: 18, weight: .bold)
        titleTextField.textAlignment = .center
        
        view.addSubview(payButton)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.setTitle("გადახდა", for: .normal)
        payButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.layer.cornerRadius = 20
        
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.isHidden = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        view.addSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 20),
            
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            payButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.widthAnchor.constraint(equalToConstant: 340),
            
            tableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -5),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
    }
    
    @objc private func handlePayment() {
        let totalPrice = viewModel.cartItems.reduce(0) { $0 + $1.product.price * Double($1.quantity) }
        let fee = totalPrice * 0.10
        let deliveryFee = 5.0
        let totalWithFees = totalPrice + fee + deliveryFee
        let balance = userBalance
        
        let success = totalWithFees <= balance
        let message = success ? "გადახდა წარმატებით შესრულდა!" : "გადახდა ვერ მოხერხდა, სცადეთ თავიდან."
        
        let paymentResultVC = PaymentResultViewController(success: success, message: message)
        paymentResultVC.onDismiss = { [weak self] in
            self?.onCartUpdated?()
        }
        
        if success {
            userBalance -= totalWithFees
            updateSummaryLabels()
            
            productsViewModel?.reduceStockAfterPurchase()
            onCartClearedAfterPayment?()
        }
        
        paymentResultVC.modalPresentationStyle = .pageSheet
        if let sheet = paymentResultVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(paymentResultVC, animated: true, completion: nil)
    }
    
    @objc private func updateBalanceTapped() {
        let alert = UIAlertController(title: "ბალანსის შეცვლა", message: "შეიყვანეთ ახალი თანხა", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "ახალი თანხა"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "გაუქმება", style: .cancel))
        alert.addAction(UIAlertAction(title: "განახლება", style: .default, handler: { [weak self] _ in
            guard let self = self,
                  let text = alert.textFields?.first?.text,
                  let newBalance = Double(text) else {
                self?.showInvalidBalanceAlert()
                return
            }
            
            self.userBalance = newBalance
            UserDefaults.standard.set(newBalance, forKey: self.userBalanceKey)
            self.updateSummaryLabels()
        }))
        
        present(alert, animated: true)
    }
    
    private func showInvalidBalanceAlert() {
        let errorAlert = UIAlertController(
            title: "არასწორად შევსებული ბალანსი",
            message: "გთხოვთ შეიყვანოთ ვალიდური რიცხვი. სიტყვები ან სიმბოლოები არ არის მხარდაჭერილი.",
            preferredStyle: .alert
        )
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(errorAlert, animated: true)
    }
}

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.cartItems[indexPath.row]
        let detailVM = ProductDetailViewModel(product: item)
        let detailVC = ProductDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.cartItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            if let removedItem = self.viewModel.removeItem(at: indexPath.row) {
                removedItem.quantity = 0
                self.onCartItemRemoved?(removedItem)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.onCartUpdated?()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

