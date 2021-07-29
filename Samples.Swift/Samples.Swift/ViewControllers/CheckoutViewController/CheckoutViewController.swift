//
//  CheckoutViewController.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/10/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit
import PayPalCheckout

class CheckoutViewController: UIViewController, AddItemViewControllerDelegate {

  var items = [PurchaseUnit.Item]()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(AddItemCell.self, forCellReuseIdentifier: "AddItemCell")
    tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
    tableView.register(TotalCell.self, forCellReuseIdentifier: "TotalCell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  lazy var checkoutButton: UIButton = {
    let checkoutButton = UIButton()
    checkoutButton.setTitle("Checkout with Order", for: .normal)
    checkoutButton.layer.cornerRadius = 8
    checkoutButton.backgroundColor = .systemBlue
    checkoutButton.tintColor = .white
    checkoutButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
    checkoutButton.addTarget(self, action: #selector(tapCheckout), for: .touchUpInside)
    checkoutButton.translatesAutoresizingMaskIntoConstraints = false
    return checkoutButton
  }()

  lazy var paypalButton: PayPalButton = {
    let paypalButton = PayPalButton(size: .expanded)
    paypalButton.addTarget(self, action: #selector(tapCheckout), for: .touchUpInside)
    paypalButton.translatesAutoresizingMaskIntoConstraints = false
    return paypalButton
  }()

  lazy var checkoutFlowOption: UISegmentedControl = {
    let checkoutFlowOptions = ["Order", "ECToken", "Payment Button"]
    let checkoutFlowOption = UISegmentedControl(items: checkoutFlowOptions)

    checkoutFlowOption.addTarget(
      self,
      action: #selector(checkoutFlowOptionChanged),
      for: .valueChanged
    )

    checkoutFlowOption.selectedSegmentIndex = 0
    checkoutFlowOption.translatesAutoresizingMaskIntoConstraints = false
    return checkoutFlowOption
  }()


  override func viewDidLoad() {
    super.viewDidLoad()
    paypalButton.isHidden = true

    setupSampleItem()
    configure()
  }

  @objc
  func tapCheckout() {
    if items.count == 0 {
      let alertController = UIAlertController(title: "Cannot checkout", message: "Please add at least 1 item to the cart", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Ok", style: .default))
      self.present(alertController, animated: true)
      return
    }

    startNativeCheckout()
  }

  func startNativeCheckout() {
    let order = createNewOrder()

    switch self.checkoutFlowOption.selectedSegmentIndex {
    /// Checkout with a cart created and let the SDK handle passing in the order ID
    case 0:
      Checkout.start(
        createOrder: { action in
          action.create(order: order) { orderId in
            if orderId == nil {
              print("There was an error with the format of your order object")
            }
            else {
              print("Order created with order ID \(String(describing: orderId))")
            }
          }
        },
        onApprove: { approval in
          self.processOrderActions(with: approval)
        },
        onCancel: {
          print("Checkout cancelled")
        },
        onError: { errorInfo in
          print("Checkout failed with error info \(errorInfo.error.localizedDescription)")
        }
      )

    /// Request an ECToken/orderID/payToken with PayPal Orders API,
    /// then checkout with `ECToken`/`orderID`/`payToken`
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
      },
      onApprove: { approval in
        self.processOrderActions(with: approval)
      },
      onCancel: {
        print("Checkout cancelled")
      },
      onError: { errorInfo in
        print("Checkout failed with error info \(errorInfo.error.localizedDescription)")
      }
      )

    /// Checkout with payment buttons
    case 2:
      Checkout.setCreateOrderCallback { action in
        action.create(order: order) { orderId in
          if orderId == nil {
            print("There was an error with the format of your order object")
          }
          else {
            print("Order created with order ID \(String(describing: orderId))")
          }
        }
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

    default:
      break
    }
  }

  func createNewOrder() -> OrderRequest {
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
      items: items
    )


    let order: OrderRequest = OrderRequest(
      intent: .authorize,
      purchaseUnits: [purchaseUnit]
    )

    return order
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

  func configure() {
    view.backgroundColor = .white

    view.addSubview(checkoutFlowOption)
    view.addSubview(tableView)
    view.addSubview(checkoutButton)
    view.addSubview(paypalButton)

    NSLayoutConstraint.activate(getConstraints())
  }

  func getConstraints() -> [NSLayoutConstraint] {
    [
      checkoutFlowOption.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
      checkoutFlowOption.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      checkoutFlowOption.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      checkoutFlowOption.heightAnchor.constraint(equalToConstant: 32),
      checkoutFlowOption.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -24),

      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: 20),

      checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      checkoutButton.heightAnchor.constraint(equalToConstant: 40),

      paypalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      paypalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      paypalButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      paypalButton.heightAnchor.constraint(equalToConstant: 40),
    ]
  }

  @objc
  func checkoutFlowOptionChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      checkoutButton.isHidden = false
      paypalButton.isHidden = true
      checkoutButton.setTitle("Checkout with Order", for: .normal)

    case 1:
      checkoutButton.isHidden = false
      paypalButton.isHidden = true
      checkoutButton.setTitle("Checkout with ECToken", for: .normal)

    case 2:
      checkoutButton.isHidden = true
      paypalButton.isHidden = false

    default:
      break
    }
  }

  private func processOrderActions(with approval: Approval) {
    switch approval.data.intent {
    case "AUTHORIZE":
      approval.actions.authorize { success, error in
        if let error = error {
          self.errorResultAction(errorMessage: error.localizedDescription)
        }
        else if let success = success {
          self.successResultAction(orderData: success.data.orderData, orderId: success.data.id)
        }
        else {
          print("Unhandled State: No Error and No Success Response")
        }
      }

    case "CAPTURE", "SALE":
      approval.actions.capture { success, error in
        if let error = error {
          self.errorResultAction(errorMessage: error.localizedDescription)
        }
        else if let success = success {
          self.successResultAction(orderData: success.data.orderData, orderId: success.data.id)
        }
        else {
          print("Unhandled State: No Error and No Success Response")
        }
      }

    default:
      break
    }
  }

  func successResultAction(orderData: [String: Any], orderId: String) {
    print("Successful Response Data: \(orderData)")

    let resultViewController = ResultViewController()
    resultViewController.resultLabel.text = "Success 😎"
    resultViewController.messageLabel.text = "Your order number is \(orderId)"
    resultViewController.modalPresentationStyle = .fullScreen

    self.present(resultViewController, animated: true)
  }

  func errorResultAction(errorMessage: String) {
      print("Capture Action Error Response: \(errorMessage)")

      let resultViewController = ResultViewController()
      resultViewController.resultLabel.text = "Error 😕"
      resultViewController.messageLabel.text = "Your order failed with \(errorMessage)"
      resultViewController.modalPresentationStyle = .fullScreen

    self.present(resultViewController, animated: true)
  }

  func getItemTotal() -> String {
    let total = items.reduce(0) { (runningTotal, item) -> Double in
       let unitAmount = Double(item.unitAmount.value ?? "0") ?? 0
       let quantity = Double(item.quantity) ?? 0
       return runningTotal + (quantity * unitAmount)
     }

    return String(format: "%.2f", total)
  }

  func getTaxTotal() -> String {
    let total = items.reduce(0) { (runningTotal, item) -> Double in
      let taxPrice = Double(item.tax?.value ?? "0") ?? 0
      let quantity = Double(item.quantity) ?? 0
      return runningTotal + (taxPrice * quantity)
    }
    
    return String(format: "%.2f", total)
  }

  func getTotal() -> String {
    let total = items.reduce(0) { (runningTotal, item) -> Double in
      let unitPrice = Double(item.unitAmount.value ?? "0") ?? 0
      let taxPrice = Double(item.tax?.value ?? "0") ?? 0
      let quantity = Double(item.quantity) ?? 0
      return runningTotal + ((unitPrice * quantity) + (taxPrice * quantity))
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
      return nil
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
    if indexPath.section == 0 && indexPath.row >= items.count {
      return 48
    } else {
      return UITableView.automaticDimension
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return section == 0 ? items.count + 1 : 1
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == 0 else { return }
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

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return indexPath.section == 0 && indexPath.row < self.items.count
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
