//
//  FetchAccessTokenRequest.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/16/21.
//

import Foundation

class FetchAccessTokenRequest: NSObject {
  let clientId: String

  init(clientId: String) {
    self.clientId = clientId
  }

  func requestHeaders() -> [String: String] {
    [
      "Authorization" : "Basic \(self.clientId.data(using: .utf8)?.base64EncodedString() ?? "")",
    ]
  }

  func requestBody() -> Data? {
    "grant_type=client_credentials".data(using: .utf8)
  }

}
