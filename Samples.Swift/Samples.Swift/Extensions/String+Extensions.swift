//
//  String+Extensions.swift
//  Samples.Swift
//
//  Created by Jax DesMarais-Leder on 3/25/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

extension String {
  func convertDoubleToCurrency(withQuantity quantity: String) -> String? {
    guard let amount = Double(self), let quantity = Double(quantity) else { return nil
    }

    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.locale = Locale(identifier: "en_US")
    
    return numberFormatter.string(from: NSNumber(value: amount * quantity))
  }
}
