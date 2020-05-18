//
//  Order.Request.swift
//  PayPalCheckout-Samples-iOS
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

import Foundation

public struct CreateOrderRequest: Codable {

    private enum CodingKeys: String, CodingKey {
        case intent
        case purchaseUnits = "purchase_units"
    }

    public let intent: OrderIntent
    public let purchaseUnits: [PurchaseUnit]
    // Add more properties based on API docs
}
