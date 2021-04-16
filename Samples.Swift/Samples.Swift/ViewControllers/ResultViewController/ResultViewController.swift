//
//  ResultViewController.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/16/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

  let resultView = UIView()

  lazy var resultLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    return label
  }()

  lazy var messageLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 7, y: 200, width: 370, height: 100))
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    return label
  }()

  lazy var backToCheckoutButton: UIButton = {
    let button = UIButton(type: .system)
    button.layer.cornerRadius = 8
    button.backgroundColor = .systemBlue
    button.tintColor = .white
    button.frame.size.height = 40
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.setTitle("Back to Checkout", for: .normal)
    button.addTarget(self, action: #selector(backToCheckoutTapped), for: .touchUpInside)
    return button
  }()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        resultLabel,
        messageLabel,
        backToCheckoutButton
      ]
    )
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fill
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(
      top: 5.0,
      left: 16.0,
      bottom: 16.0,
      right: 16.0
    )
    return stackView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    configure()
  }

  @objc
  func backToCheckoutTapped() {
    self.dismiss(animated: true)
  }

  private func configure() {
    view.addSubview(resultView)
    resultView.addSubview(stackView)

    resultView.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate(getConstraints())
  }

  // MARK: - Constraints

  func getConstraints() -> [NSLayoutConstraint] {
    [
      resultView.heightAnchor.constraint(equalTo: view.heightAnchor),
      resultView.widthAnchor.constraint(equalTo: view.heightAnchor),
      resultView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      resultView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      stackView.centerXAnchor.constraint(equalTo: resultView.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: resultView.centerYAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ]
  }
}
