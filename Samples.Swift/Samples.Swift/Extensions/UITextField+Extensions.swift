//
//  UITextField+Extensions.swift
//  Samples.Swift
//
//  Created by Jax DesMarais-Leder on 4/8/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

import UIKit

extension UITextField {

  var isEmpty: Bool {
    return text?.isEmpty ?? true
  }
}
