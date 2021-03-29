//
//  CheckoutViewController.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//

import UIKit
import PayPalCheckout

class CheckoutViewController: UIViewController, AddItemViewControllerDelegate {

  let tableView = UITableView()
  let checkoutButton = UIButton()
  var checkoutFlowOption = UISegmentedControl()
  var items = [PurchaseUnit.Item]()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSampleItem()
    setupUI()
    setupTableView()
    setupConstraints()
  }

  @objc
  func tapCheckout() {
    if items.count == 0 {
      let ac = UIAlertController(title: "Cannot checkout", message: "Please add at least 1 item to the cart", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Ok", style: .default))
      self.present(ac, animated: true)
    }

    Checkout.setOnApproveCallback { approval in
      self.processOrderActions(with: approval)
    }

    Checkout.setOnCancelCallback {
      print("Checkout cancelled")
    }

    Checkout.setOnErrorCallback { errorInfo in
      print("Checkout failed with error info \(errorInfo.error.localizedDescription)")
    }

    startNativeCheckout()
  }

  func startNativeCheckout() {
    let order = getOrder()

    switch checkoutFlowOption.selectedSegmentIndex {
    case 0:
    /**
    Checkout with a cart created and let the SDK handle
      passing in the order ID
    */
      Checkout.start(createOrder: { action in
        action.create(order: order) { orderId in
          if orderId == nil {
            print("There was an error with the format of your order object")
          }
          else {
            print("Order created with order ID \(String(describing: orderId))")
          }
        }
      })

    /**
    Request an ECToken/orderID/payToken with PayPal Orders API,
    then checkout with `ECToken`/`orderID`/`payToken`
     */
    case 1:
      Checkout.start(createOrder: { action in
        let tokenRequest = AccessTokenRequest(clientId: PayPal.clientId)

        PayPal.shared.request(on: .fetchAccessToken(tokenRequest)) { data, error in

          guard
            let data = data,
            let tokenResponse = try? PayPal.jsonDecoder.decode(AccessTokenResponse.self, from: data)
          else {
            print("Fetch access token failed with no data")
            return
          }

          PayPal.shared.setAccessToken(tokenResponse.accessToken)

          PayPal.shared.request(on: .createOrder(order)) {
            data, error in
            guard
              let data = data,
              let createOrderResponse = try? PayPal.jsonDecoder.decode(CreateOrderResponse.self, from: data)
            else {
              print("Create order failed with no data")
              return
            }

            action.set(orderId: createOrderResponse.id)
          }
        }
      })

    default:
      break
    }
  }

  func getOrder() -> OrderRequest {
    var itemsList = [PurchaseUnit.Item]()

    for item in items {
      let item = PurchaseUnit.Item(
        name: item.name,
        unitAmount: UnitAmount(currencyCode: .usd, value: item.unitAmount.value),
        quantity: item.quantity,
        tax: PurchaseUnit.Tax(currencyCode: .usd, value: String(item.tax?.value ?? ""))
      )
      itemsList.append(item)
    }

    let purchaseUnit: PurchaseUnit = PurchaseUnit(
      amount: PurchaseUnit.Amount(
        currencyCode: .usd,
        value: String(self.getTotal()),
        breakdown: PurchaseUnit.Breakdown(
          itemTotal: UnitAmount(
            currencyCode: .usd,
            value: String(self.getItemTotal())
          ),
          taxTotal: UnitAmount(
            currencyCode: .usd,
            value: String(self.getTaxTotal())
          )
        )
      ),
      items: itemsList
    )


    let order: OrderRequest = OrderRequest(
      intent: .authorize,
      purchaseUnits: [purchaseUnit]
    )

    return order
  }

  func setupTableView() {
    tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
    tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
    tableView.register(TotalCell.self, forCellReuseIdentifier: "TotalCell")

    tableView.delegate = self
    tableView.dataSource = self
  }

  func setupSampleItem() {
    let item: PurchaseUnit.Item = PurchaseUnit.Item(
      name: "Sample item",
      unitAmount: UnitAmount(
        currencyCode: .usd, value: "5.99"
      ),
      quantity: "1",
      tax: PurchaseUnit.Tax(
        currencyCode: .usd,
        value: "1.23"
      )
    )

    items.append(item)
  }

  func setupUI() {
    view.backgroundColor = .white
    let checkoutFlowOptions = ["Order", "ECToken"]
    checkoutFlowOption = UISegmentedControl(items: checkoutFlowOptions)
    checkoutButton.setTitle("Checkout with Order", for: .normal)

    checkoutFlowOption.addTarget(
      self,
      action: #selector(checkoutFlowOptionChanged),
      for: .valueChanged
    )

    checkoutFlowOption.selectedSegmentIndex = 0
    checkoutFlowOption.translatesAutoresizingMaskIntoConstraints = false

    tableView.translatesAutoresizingMaskIntoConstraints = false

    checkoutButton.layer.cornerRadius = 8
    checkoutButton.backgroundColor = .systemBlue
    checkoutButton.tintColor = .white
    checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    checkoutButton.addTarget(self, action: #selector(tapCheckout), for: .touchUpInside)
    checkoutButton.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(checkoutFlowOption)
    view.addSubview(tableView)
    view.addSubview(checkoutButton)
  }

  func setupConstraints() {
    checkoutFlowOption.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
    checkoutFlowOption.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    checkoutFlowOption.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    checkoutFlowOption.heightAnchor.constraint(equalToConstant: 32).isActive = true
    checkoutFlowOption.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -24).isActive = true


    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: 20).isActive = true

    checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    checkoutButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }

  @objc
  func checkoutFlowOptionChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      checkoutButton.isHidden = false
      checkoutButton.setTitle("Checkout with Order", for: .normal)

    case 1:
      checkoutButton.isHidden = false
      checkoutButton.setTitle("Checkout with ECToken", for: .normal)

    default:
      break
    }
  }

  private func processOrderActions(with approval: Approval) {
    switch approval.data.intent {
    case "AUTHORIZE":
      approval.actions.authorize { success, error in
        if let error = error {
          print("Authorize Action Error Response: \(error.localizedDescription)")

          let resultViewController = ResultViewController()
          resultViewController.resultLabel.text = "Error 😕"
          resultViewController.messageLabel.text = "Your order failed with \(error.localizedDescription)"
          resultViewController.modalPresentationStyle = .fullScreen
          self.present(resultViewController, animated: true)
        }
        else if let success = success {
          print("Successful Response Data: \(success.data.orderData)")

          let resultViewController = ResultViewController()
          resultViewController.resultLabel.text = "Success 😎"
          resultViewController.messageLabel.text = "Your order number is \(success.data.id)"
          resultViewController.modalPresentationStyle = .fullScreen
          self.present(resultViewController, animated: true)
        }
        else {
          print("Unhandled State: No Error and No Success Response")
        }
      }

    case "CAPTURE", "SALE":
      approval.actions.capture { success, error in
        if let error = error {
          print("Capture Action Error Response: \(error.localizedDescription)")

          let resultViewController = ResultViewController()
          resultViewController.resultLabel.text = "Error 😕"
          resultViewController.messageLabel.text = "Your order failed with \(error.localizedDescription)"
          resultViewController.modalPresentationStyle = .fullScreen
          self.present(resultViewController, animated: true)
        }
        else if let success = success {
          print("Successful Response Data: \(success.data.orderData)")
          let resultViewController = ResultViewController()
          resultViewController.resultLabel.text = "Success 😎"
          resultViewController.messageLabel.text = "Your order number is \(success.data.id)"
          resultViewController.modalPresentationStyle = .fullScreen
          self.present(resultViewController, animated: true)
        }
        else {
          print("Unhandled State: No Error and No Success Response")
        }
      }

    default:
      break
    }
  }

  func getItemTotal() -> String {
    var total: Double = 0

    for item in items {
      guard let unitPrice = Double(item.unitAmount.value) else { return "" }
      guard let quantity = Double(item.quantity) else { return "" }

      let itemTotalPrice = unitPrice * quantity
      total += itemTotalPrice
    }
    return String(format: "%.2f", total)
  }

  func getTaxTotal() -> String {
    var total: Double = 0

    for item in items {
      guard let taxPrice = Double(item.tax!.value) else { return "" }
      guard let quantity = Double(item.quantity) else { return "" }

      let totalTaxPrice = taxPrice * quantity
      total += totalTaxPrice
    }
    return String(format: "%.2f", total)
  }

  func getTotal() -> String {
    var total: Double = 0

    for item in items {
      guard let unitPrice = Double(item.unitAmount.value) else { return "" }
      guard let taxPrice = Double(item.tax!.value) else { return "" }
      guard let quantity = Double(item.quantity) else { return "" }

      let totalUnitPrice = unitPrice * quantity
      let totalTaxPrice = taxPrice * quantity

      total += totalUnitPrice + totalTaxPrice
    }
    return String(format: "%.2f", total)
  }

  // MARK: AddItemViewControllerDelegate
  func didTapSaveWithItem(item: PurchaseUnit.Item, at index: Int) {
    if index < items.count {
      items[index] = item
    }
    else {
      items.append(item)
    }
    tableView.reloadData()
  }

  deinit { }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
      return 2
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Items"

    case 1:
      return "Cart total"

    default:
      return ""
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if indexPath.row >= items.count {
        guard
          let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as? AddItemCell
          else { return UITableViewCell() }
        return cell
      }
      else {
        guard
          let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell
          else { return UITableViewCell() }
        cell.setupUIWithItem(withItem: items[indexPath.row])
        return cell
      }
    }
    else {
      guard
        let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCell", for: indexPath) as? TotalCell
        else { return UITableViewCell() }
      cell.setupUIWithTotal(withSubtotal: "$\(getItemTotal())", withTax: "$\(getTaxTotal())", withTotal: "$\(getTotal())")
      return cell
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      if indexPath.row >= items.count {
        return 48
      }
      return UITableView.automaticDimension
    }
    else  {
      return UITableView.automaticDimension
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return items.count + 1
    }
    else {
      return 1
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      if indexPath.row >= items.count {
        let addItemViewController = AddItemViewController()
        addItemViewController.modalPresentationStyle = .overFullScreen
        addItemViewController.delegate = self
        addItemViewController.index = indexPath.row
        present(addItemViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
      }
      else {
        let addItemViewController = AddItemViewController(item: items[indexPath.row])

        addItemViewController.modalPresentationStyle = .overFullScreen
        addItemViewController.delegate = self
        addItemViewController.index = indexPath.row

        present(addItemViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == 0 && indexPath.row < self.items.count {
      return true
    }
    else {
      return false
    }
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.items.remove(at: indexPath.row)
      tableView.performBatchUpdates {
        tableView.deleteRows(at: [indexPath], with: .fade)
      } completion: { (Bool) in
        tableView.reloadData()
      }
    }
  }
}
