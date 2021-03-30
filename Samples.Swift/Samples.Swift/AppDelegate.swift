//
//  AppDelegate.swift
//  paypalcheckout-iOS-swift-sample
//
//  Created by Jax DesMarais-Leder on 3/4/21.
// Copyright © 2021 PayPal. All rights reserved.
//

import UIKit
import PayPalCheckout

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window : UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if #available(iOS 13, *) {
      setConfig()
    }
    else {
      setConfig()
      self.window = UIWindow()
      let viewController = CheckoutViewController()
      window?.rootViewController = viewController
      window?.makeKeyAndVisible()
    }
    return true
  }

  func setConfig() {
    let config: Config = {
      let config = Config(clientID: PayPal.clientId, returnUrl: PayPal.returnUrl, environment: .sandbox)
      return config
    }()

    Checkout.set(config: config)
  }

  // MARK: UISceneSession Lifecycle
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
