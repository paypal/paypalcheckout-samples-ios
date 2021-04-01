//
//  UIViewController+Extensions.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/8/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

extension UIViewController {

  func newTextField(
    placeholder: String? = nil,
    defaultValue: String? = nil,
    clearButton: UITextField.ViewMode = .never
  ) -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.borderStyle = .roundedRect
    textField.placeholder = placeholder
    textField.text = defaultValue
    textField.clearButtonMode = clearButton
    if let textDelegate = self as? UITextFieldDelegate {
      textField.delegate = textDelegate
    }
    return textField
  }
}
