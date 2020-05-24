//
//  AccessToken.Response.swift
//  PayPalCheckout-Samples-iOS
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

import Foundation

struct AccessTokenResponse: Codable {

  private enum RootKeys: String, CodingKey {
    case scope
    case accessToken = "access_token"
    case tokenType = "token_type"
    case appId = "app_id"
    case expiresIn = "expires_in"
    case nonce
  }
  
  let scopes: [String]
  let accessToken: String
  let tokenType: String?
  let appId: String
  let expiresIn: Int
  let nonce: String

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: RootKeys.self)

    // Decode scopes
    let scopeString = try container.decode(String.self, forKey: .scope)
    self.scopes = scopeString.split(separator: " ").compactMap { String($0) }

    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType)
    self.appId = try container.decode(String.self, forKey: .appId)
    self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
    self.nonce = try container.decode(String.self, forKey: .nonce)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: RootKeys.self)
    try container.encode(self.scopes.joined(separator: " "), forKey: .scope)
    try container.encode(self.accessToken, forKey: .accessToken)
    try container.encode(self.appId, forKey: .appId)
    try container.encode(self.expiresIn, forKey: .expiresIn)
    try container.encode(self.nonce, forKey: .nonce)
  }
}
