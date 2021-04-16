//
//  AddItemCell.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

class AddItemCell: UITableViewCell {

  lazy var addItemLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .systemBlue
    label.text = "Add Item"
    label.sizeToFit()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(addItemLabel)
    NSLayoutConstraint.activate(getConstraints())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func getConstraints() -> [NSLayoutConstraint] {
    [
      addItemLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      addItemLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ]
  }
}
