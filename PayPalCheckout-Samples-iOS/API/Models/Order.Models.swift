//
//  Order.Models.swift
//  PayPalCheckout-Samples-iOS
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

import Foundation

public enum OrderIntent: String, Codable {
    case capture = "CAPTURE"
    case authorize = "AUTHORIZE"
}

public enum CurrencyCode: String, Codable {
    case usd = "USD"
}

public struct Amount: Codable {
    
  private enum RootKeys: String, CodingKey {
    case currencyCode = "currency_code"
    case value
  }

  public let currencyCode: CurrencyCode
  public let value: String
  // Add more properties based on API docs

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: RootKeys.self)
    try container.encode(self.currencyCode, forKey: .currencyCode)
    try container.encode(self.value, forKey: .value)
  }
}

public struct PurchaseUnit: Codable {
    public let amount: Amount
    // Add more properties based on API docs
}
