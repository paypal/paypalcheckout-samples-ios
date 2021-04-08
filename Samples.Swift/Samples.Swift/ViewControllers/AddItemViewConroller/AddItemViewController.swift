//
//  AddItemViewController.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/9/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import PayPalCheckout
import UIKit

protocol AddItemViewControllerDelegate {
  func didTapSaveWithItem(item: PurchaseUnit.Item, at index: Int)
}

class AddItemViewController: UIViewController {

  var delegate: AddItemViewControllerDelegate?
  var index: Int?

  lazy var popupBox: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    view.layer.cornerRadius = 8
    return view
  }()

  lazy var createItemLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.text = "Create Item"
    label.textAlignment = .center
    return label
  }()

  lazy var nameField: UITextField = {
    let nameField = newTextField(
      placeholder: "Item name"
    )
    return nameField
  }()

  lazy var amountField: UITextField = {
    let amountField = newTextField(
      placeholder: "Amount"
    )
    return amountField
  }()

  lazy var quantityField: UITextField = {
    let quantityField = newTextField(
      placeholder: "Quantity"
    )
    return quantityField
  }()

  lazy var taxAmountField: UITextField = {
    let taxAmountField = newTextField(
      placeholder: "Tax amount"
    )
    return taxAmountField
  }()

  lazy var addItemButton: UIButton = {
    let button = UIButton(type: .system)
    button.layer.cornerRadius = 8
    button.backgroundColor = .systemBlue
    button.tintColor = .white
    button.frame.size.height = 40
    button.titleLabel?.font = .boldSystemFont(ofSize: 16)
    button.setTitle("Add", for: .normal)
    button.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
    return button
  }()

  lazy var stackView: UIStackView = {
    let stackView = UIStackView(
      arrangedSubviews: [
        createItemLabel,
        nameField,
        amountField,
        quantityField,
        taxAmountField,
        addItemButton
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
    view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    configure()
  }

  init() {
    super.init(nibName: nil, bundle: nil)
    self.nameField.text = ""
    self.amountField.text = ""
    self.quantityField.text = ""
    self.taxAmountField.text = ""

    createItemLabel.text = "Create Item"
    addItemButton.setTitle("Add", for: .normal)
  }

  init(item: PurchaseUnit.Item) {
    super.init(nibName: nil, bundle: nil)
    self.nameField.text = item.name
    self.amountField.text = item.unitAmount.value
    self.quantityField.text = item.quantity
    self.taxAmountField.text = item.tax?.value

    createItemLabel.text = "Edit Item"
    addItemButton.setTitle("Save", for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  func addItemTapped() {
    if nameField.isEmpty || amountField.isEmpty || quantityField.isEmpty || taxAmountField.isEmpty {
      let ac = UIAlertController(title: "Cannot add item", message: "Please ensure all item fields are filled out", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default))
      self.present(ac, animated: true)
    }
    else {
      let item: PurchaseUnit.Item = PurchaseUnit.Item(
        name: nameField.text ?? "",
        unitAmount: UnitAmount(
          currencyCode: .usd,
          value: amountField.text ?? ""
        ),
        quantity: quantityField.text ?? "",
        tax: PurchaseUnit.Tax(
          currencyCode: .usd,
          value: taxAmountField.text ?? ""
        )
      )
      delegate?.didTapSaveWithItem(item: item, at: index ?? 0)
      self.dismiss(animated: true)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    guard let location = touches.first?.location(in: self.view) else { return }
    if !popupBox.frame.contains(location) {
      dismiss(animated: true)
    }
  }

  private func configure() {
    view.addSubview(popupBox)
    popupBox.addSubview(stackView)

    popupBox.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(getConstraints())
  }

  // MARK: - Constraints

  private func getConstraints() -> [NSLayoutConstraint] {
    [
      popupBox.heightAnchor.constraint(equalToConstant: 300),
      popupBox.widthAnchor.constraint(equalToConstant: 300),
      popupBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      popupBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      stackView.topAnchor.constraint(equalTo: popupBox.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: popupBox.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: popupBox.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: popupBox.trailingAnchor),
    ]
  }
}
