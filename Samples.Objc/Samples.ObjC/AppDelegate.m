//
//  AppDelegate.m
//  PayPalNativeCheckoutObjC
//
//  Created by Haider Khan on 5/23/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "AppDelegate.h"
#import "PayPalAPI.h"
@import PayPalCheckout;

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  PPCheckoutConfig *config = [[PPCheckoutConfig alloc] initWithClientID:[PayPalAPI.shared clientId]
                                                              returnUrl:@"<return_url>"
                                                            createOrder:nil
                                                              onApprove:nil
                                                               onCancel:nil
                                                                onError:nil
                                                            environment:PPCEnvironmentSandbox];
  [PPCheckout setConfig:config];
  return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13)) {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13)) {
  // Called when the user discards a scene session.
  // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
  // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
