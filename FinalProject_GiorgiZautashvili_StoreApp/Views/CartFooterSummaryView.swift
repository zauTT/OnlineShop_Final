//
//  CartFooterSummaryView.swift
//  FinalProject_GiorgiZautashvili_StoreApp
//
//  Created by Giorgi Zautashvili on 04.05.25.
//

import UIKit

class CartFooterSummaryView: UIView {
    private let balanceLabel = UILabel()
    private let balanceValueLabel = UILabel()
    
    private let totalPriceLabel = UILabel()
    private let totalPriceValueLabel = UILabel()
    
    private let feeLabel = UILabel()
    private let feeValueLabel = UILabel()
    
    private let deliveryLabel = UILabel()
    private let deliveryValueLabel = UILabel()
    
    private let finalTotalLabel = UILabel()
    private let finalTotalValueLabel = UILabel()
    
    private let mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
        
        addRow(label: balanceLabel, valueLabel: balanceValueLabel, title: "ბალანსი")
        addRow(label: totalPriceLabel, valueLabel: totalPriceValueLabel, title: "სრული ღირებულება")
        addRow(label: feeLabel, valueLabel: feeValueLabel, title: "საფასური (10%)")
        addRow(label: deliveryLabel, valueLabel: deliveryValueLabel, title: "მიტანის საფასური")
        addRow(label: finalTotalLabel, valueLabel: finalTotalValueLabel, title: "საბოლოო ფასი", isBold: true)
    }
    
    private func addRow(label: UILabel, valueLabel: UILabel, title: String, isBold: Bool = false) {
        label.text = title
        valueLabel.textAlignment = .right
        
        if isBold {
            label.font = .boldSystemFont(ofSize: 16)
            valueLabel.font = .boldSystemFont(ofSize: 16)
        } else {
            label.font = .systemFont(ofSize: 14)
            valueLabel.font = .systemFont(ofSize: 14)
        }
        
        let rowStack = UIStackView(arrangedSubviews: [label, valueLabel])
        rowStack.axis = .horizontal
        rowStack.distribution = .fillEqually
        
        mainStackView.addArrangedSubview(rowStack)
    }
    
    func updateSummary(totalPrice: Double, balance: Double, fee: Double, delivery: Double, totalWithFees: Double) {
        balanceValueLabel.text = String(format: "₾%.2f", balance)
        totalPriceValueLabel.text = String(format: "₾%.2f", totalPrice)
        feeValueLabel.text = String(format: "₾%.2f", fee)
        deliveryValueLabel.text = String(format: "₾%.2f", delivery)
        finalTotalValueLabel.text = String(format: "₾%.2f", totalWithFees)
    }
}
