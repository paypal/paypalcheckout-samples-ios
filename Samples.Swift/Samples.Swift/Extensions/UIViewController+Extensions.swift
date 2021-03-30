//
//  UIViewController+Extensions.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/8/21.
// Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

extension UIViewController {

  func textField(
    placeholder: String? = nil,
    defaultValue: String? = nil,
    clearButton: UITextField.ViewMode = .never
  ) -> UITextField {
    let result = UITextField()
    result.translatesAutoresizingMaskIntoConstraints = false
    result.borderStyle = .roundedRect
    result.placeholder = placeholder
    result.text = defaultValue
    result.clearButtonMode = clearButton
    if let textDelegate = self as? UITextFieldDelegate {
      result.delegate = textDelegate
    }
    return result
  }
}
