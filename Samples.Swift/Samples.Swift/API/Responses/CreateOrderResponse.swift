//
//  CreateOrderResponse.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/16/21.
//

import Foundation

class CreateOrderResponse: NSObject {
  let orderId: String

  init(data: Data) {
    let dictionaryFromData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

    let orderId = dictionaryFromData?["id"] as? String
    self.orderId = orderId ?? ""
  }
}
