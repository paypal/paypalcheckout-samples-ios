//
//  AccessTokenResponse.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/16/21.
//

import Foundation

class AccessTokenResponse: NSObject {
  let accessToken: String

  init(data: Data) {
    let dictionaryFromData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

    let accessToken = dictionaryFromData?["access_token"] as? String
    self.accessToken = accessToken ?? ""
  }

}
