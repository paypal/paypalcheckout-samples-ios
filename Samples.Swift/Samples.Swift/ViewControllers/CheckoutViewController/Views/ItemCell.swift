//
//  ItemCell.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit
import PayPalCheckout

class ItemCell: UITableViewCell {
  let nameLabel = UILabel()
  let priceLabel = UILabel()
  let taxLabel = UILabel()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        nameLabel,
        priceLabel,
        taxLabel
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
    NSLayoutConstraint.activate(getConstraints())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUIWithItem(withItem item: PurchaseUnit.Item) {
    nameLabel.textColor = .black
    nameLabel.font = .systemFont(ofSize: 16)
    nameLabel.text = "\(item.quantity) x \(item.name)"
    nameLabel.sizeToFit()

    priceLabel.textColor = .black
    priceLabel.font = .systemFont(ofSize: 12)
    priceLabel.text = "Price: \(item.unitAmount.value?.convertDoubleToCurrency(withQuantity: item.quantity) ?? "")"
    priceLabel.sizeToFit()

    taxLabel.textColor = .black
    taxLabel.font = .systemFont(ofSize: 12)
    taxLabel.text = "Tax: \(item.tax?.value.convertDoubleToCurrency(withQuantity: item.quantity) ?? "")"
    taxLabel.sizeToFit()
  }

  func getConstraints() -> [NSLayoutConstraint] {
    [
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
    ]
  }
}
