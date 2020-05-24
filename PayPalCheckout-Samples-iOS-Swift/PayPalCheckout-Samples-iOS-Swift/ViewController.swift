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
      self.startNativeCheckout(with: createOrderResponse)
    }
  }

  func startNativeCheckout(with orderResponse: CreateOrderResponse) {

    // Our order response contains our EC-Token / Order id requried to start
    // a checkout experience
    let config = Config(
      clientID: PayPal.clientId,
      payToken: orderResponse.id,
      universalLink: "",
      uriScheme: "<redirect_url>",
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
    config.presentingViewController = self
    Checkout.set(config: config)
    Checkout.start()
  }
}
