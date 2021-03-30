//
//  AccessTokenResponse.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/16/21.
// Copyright © 2021 PayPal. All rights reserved.
//

import Foundation

struct AccessTokenResponse: Codable {
  let accessToken: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
  }
}
