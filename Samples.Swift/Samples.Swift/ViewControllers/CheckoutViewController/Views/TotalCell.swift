//
//  TotalCell.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

class TotalCell: UITableViewCell {
  let subtotalLabel = UILabel()
  let taxLabel = UILabel()
  let totalLabel = UILabel()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        subtotalLabel,
        taxLabel,
        totalLabel
      ]
    )
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.distribution = .fill
    stackView.alignment = .trailing
    stackView.isLayoutMarginsRelativeArrangement = true
    return stackView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none

    stackView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(stackView)
    NSLayoutConstraint.activate(getConstraints())
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUIWithTotal(withSubtotal subtotal: String, withTax tax: String, withTotal total: String) {
    subtotalLabel.textColor = .black
    subtotalLabel.font = .systemFont(ofSize: 14)
    subtotalLabel.text = "Subtotal: \(subtotal)"
    subtotalLabel.sizeToFit()

    taxLabel.textColor = .black
    taxLabel.font = .systemFont(ofSize: 14)
    taxLabel.text = "Tax: \(tax)"
    taxLabel.sizeToFit()

    totalLabel.textColor = .black
    totalLabel.font = .boldSystemFont(ofSize: 16)
    totalLabel.text = "Total: \(total)"
    totalLabel.sizeToFit()
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
