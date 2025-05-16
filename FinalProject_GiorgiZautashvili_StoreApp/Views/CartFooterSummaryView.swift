import UIKit

class CartFooterSummaryView: UIView {
    
    private let feeLabel: UILabel = {
        let label = UILabel()
        label.text = "Fee: $0.00"
        return label
    }()
    
    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "Delivery: $5.00"
        return label
    }()
    
    private let totalWithFeesLabel: UILabel = {
        let label = UILabel()
        label.text = "Total: $0.00"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        clipsToBounds = true
        
        let stack = UIStackView(arrangedSubviews: [feeLabel, deliveryFeeLabel, totalWithFeesLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func updateSummary(fee: Double, delivery: Double, total: Double) {
        feeLabel.text = "Fee: $\(String(format: "%.2f", fee))"
        deliveryFeeLabel.text = "Delivery: $\(String(format: "%.2f", delivery))"
        totalWithFeesLabel.text = "Total: $\(String(format: "%.2f", total))"
    }
}