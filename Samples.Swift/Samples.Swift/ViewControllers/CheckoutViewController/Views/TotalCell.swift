//
//  TotalCell.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//

import UIKit

class TotalCell: UITableViewCell {
  let totalLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    totalLabel.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(totalLabel)
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

  func setupUIWithTotal(withTotal total: String) {
    totalLabel.textColor = .black
    totalLabel.font = .boldSystemFont(ofSize: 16)
    totalLabel.text = "Total: \(total)"
    totalLabel.sizeToFit()
  }

  func setupConstraints() {
    totalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
    totalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
    totalLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
  }

}
