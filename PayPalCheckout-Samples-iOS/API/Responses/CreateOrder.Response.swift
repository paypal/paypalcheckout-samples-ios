//
//  CreateOrder.Response.swift
//  PayPalCheckout-Samples-iOS
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

import Foundation

struct Link: Codable {
  let href: String
  let rel: String
  let method: String
}

enum OrderStatus: String, Codable {
  case created = "CREATED"
  case authorized = "AUTHORIZED"
}

struct CreateOrderResponse: Codable {
  let id: String
  let links: [Link]
  let status: OrderStatus
}
