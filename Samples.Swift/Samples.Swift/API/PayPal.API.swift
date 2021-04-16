//
//  PayPal.API.swift
//  PayPalCheckout-Samples-iOS
//
//  Created by Haider Khan on 5/17/20.
//  Copyright © 2020 PayPal. All rights reserved.
//
import Foundation
import PayPalCheckout

class PayPal {

  // MARK: - Singleton
  static let shared = PayPal()
  private init() {}

  // MARK: - JSON
  static let jsonDecoder: JSONDecoder = {
    JSONDecoder()
  }()

  static let jsonEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
  }()

  // MARK: - Attributes
  static let clientId: String = "<client_id>"
  static let returnUrl: String = "<redirect_uri>"
  private static let nodeAppBaseURL: String = "http://localhost:3000/"
  private static let baseURLv2: String = "https://api.sandbox.paypal.com/v2/"

  private var _accessToken: String?

  // MARK: - Errors
  enum Errors: String, Error {
    case noData
    case decodingError
  }

  // MARK: - API
  enum API {

    case fetchAccessToken(AccessTokenRequest)
    case createOrder(OrderRequest)

    var path: String {
      switch self {
      case .fetchAccessToken:
        return PayPal.nodeAppBaseURL + "auth/token"

      case .createOrder:
        return PayPal.baseURLv2 + "checkout/orders"
      }
    }

    var method: String {
      return "POST"
    }

    var urlRequest: URLRequest? {
      guard let url = URL(string: self.path) else { return nil }
      switch self {
      case .fetchAccessToken(let request):
        guard
          let encoded = try? PayPal.jsonEncoder.encode(request)
          else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = encoded
        urlRequest.httpMethod = self.method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest

      case .createOrder(let request):
        guard
          let encoded = try? PayPal.jsonEncoder.encode(request)
          else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = encoded
        urlRequest.httpMethod = self.method
        urlRequest.addValue(
          "Bearer \(PayPal.shared.getAccessToken())",
          forHTTPHeaderField: "Authorization"
        )
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
      }
    }
  }

  // MARK: - Request
  func request(
    on endpoint: PayPal.API,
    with completion: @escaping (Data?, Error?) -> Void) {

    // Get our url request
    guard
      let request = endpoint.urlRequest
      else { return }

    URLSession.shared.dataTask(with: request) { (data, response, error) in
      guard error == nil else {
        completion(nil, error)
        return
      }

      guard let data = data else {
        completion(nil, Errors.noData)
        return
      }

      completion(data, nil)
    }.resume()
  }

  // MARK: - Credentials
  func setAccessToken(_ token: String) {
    self._accessToken = token
  }

  private func getAccessToken() -> String {
    return self._accessToken ?? ""
  }
}
