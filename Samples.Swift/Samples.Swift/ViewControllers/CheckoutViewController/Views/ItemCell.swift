//
//  ItemCell.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//

import UIKit
import PayPalCheckout

class ItemCell: UITableViewCell {
  let nameLabel = UILabel()
  let priceLabel = UILabel()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        nameLabel,
        priceLabel
      ]
    )
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.distribution = .fill
    stackView.isLayoutMarginsRelativeArrangement = true
    return stackView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  func setupUIWithItem(withItem item: PurchaseUnit.Item) {
    nameLabel.textColor = .black
    nameLabel.font = .systemFont(ofSize: 16)
    nameLabel.text = item.name
    nameLabel.sizeToFit()

    priceLabel.textColor = .black
    priceLabel.font = .systemFont(ofSize: 12)
    let unitAmount = Double(item.unitAmount.value)
    priceLabel.text = "Unit price: $\(String(format: "%.2f", unitAmount!)) USD"
    priceLabel.sizeToFit()
  }

  func setupConstraints() {
    stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
    stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
    stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
    stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
  }
}
