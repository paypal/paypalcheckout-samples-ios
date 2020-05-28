//
//  ViewController.swift
//  PayPalCheckout-Samples-iOS
//
//  Created by Haider Khan on 5/8/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

import UIKit
import PayPalCheckout

class ViewController: UIViewController {

  lazy var config: Config = {
    let config = Config(
      clientID: PayPal.clientId,
      payToken: "",
      universalLink: "",
      uriScheme: "<redirect_uri>",
      onApprove: {
        print("approved")
      },
      onCancel: {
        print("cancelled")
      },
      onError: { error in
        print(error)
      },
      environment: .sandbox
    )
    return config
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Fetch our Access token and store it.
    let tokenRequest = AccessTokenRequest(clientId: PayPal.clientId)
    PayPal.shared.request(on: .fetchAccessToken(tokenRequest)) {
      data, error in
      guard
        let data = data,
        let tokenResponse = try? PayPal.jsonDecoder.decode(AccessTokenResponse.self, from: data)
        else {
          return
      }

      PayPal.shared.setAccessToken(tokenResponse.accessToken)
      self.createOrders()
    }
  }

  func createOrders() {
    
    // Create EC-Tokens
    let createOrderRequest = CreateOrderRequest(
      intent: .capture,
      purchaseUnits: [
        PurchaseUnit(
          amount: Amount(
            currencyCode: .usd,
            value: "9.99"
          )
        )
      ]
    )

    PayPal.shared.request(on: .createOrder(createOrderRequest)) {
      data, error in
      guard
        let data = data,
        let createOrderResponse = try? PayPal.jsonDecoder.decode(CreateOrderResponse.self, from: data)
        else { return }
      
      // Ensure we are setting presenting view controller on main thread
      DispatchQueue.main.async {
        self.startNativeCheckout(with: createOrderResponse)
      }
    }
  }

  func startNativeCheckout(with orderResponse: CreateOrderResponse) {

    // Set our presenting view controller
    config.presentingViewController = self

    // Set our pay token in config
    config.payToken = orderResponse.id

    // Our order response contains our EC-Token / Order id requried to start
    // a checkout experience
    Checkout.set(config: config)
    Checkout.start()
  }
}
