//
//  ViewController.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "ViewController.h"
#import "FetchAccessTokenRequest.h"
#import "PayPalAPI.h"
#import "AccessTokenResponse.h"
#import "CreateOrderRequest.h"
#import "CreateOrderResponse.h"

@import PayPalCheckout;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  PayPalAPI *api = [PayPalAPI shared];
  NSString *clientId = [api clientId];
  FetchAccessTokenRequest *tokenRequest = [[FetchAccessTokenRequest alloc] initWith:clientId];
  
  [api fetchAccessToken:tokenRequest completion:^(NSData * _Nonnull data, NSError * _Nonnull error) {
    
    // Decode
    AccessTokenResponse *tokenResponse = [[AccessTokenResponse alloc] initWithData:data];

    // Set our access token
    [api setAccessToken:tokenResponse.accessToken];

    // Create orders with access token response
    [self createOrdersWith:tokenResponse];
  }];
}

- (void)createOrdersWith:(AccessTokenResponse *)tokenResponse {

  Amount *amount = [[Amount alloc] initWithCurrencyCode:USD value:@"9.99"];
  PurchaseUnit *purchaseUnit = [[PurchaseUnit alloc] initWithAmount:amount];
  NSArray<PurchaseUnit *> *purchaseUnits = @[purchaseUnit];
  CreateOrderRequest *createOrderRequest = [[CreateOrderRequest alloc]
                                            initWith:OrderIntentCapture
                                            purchaseUnits:purchaseUnits];

  PayPalAPI *api = [PayPalAPI shared];
  [api createOrder:createOrderRequest completion:^(NSData * _Nonnull data, NSError * _Nonnull error) {

    // Decode
    CreateOrderResponse *createOrderResponse = [[CreateOrderResponse alloc] initWithData:data];
    [self startNativeCheckout:createOrderResponse];
  }];
}

- (void)startNativeCheckout:(CreateOrderResponse *)createOrderResponse {
  
  PayPalAPI *api = [PayPalAPI shared];
  
  // Our order response contains our EC-Token / Order id requried to start
  // a checkout experience
  PPCConfig *config = [
    [PPCConfig alloc]
      initWithClientID:[api clientId]
      payToken:createOrderResponse.id
      universalLink:@""
      uriScheme:@"<redirect_uri>"
      onApprove:^{
        NSLog(@"Approved");
      }
      onCancel:^{
        NSLog(@"Cancelled");
      }
      onError:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error.localizedDescription);
      }
      environment:PPCEnvironmentSandbox
  ];
  config.presentingViewController = self;
  [PPCheckout setConfig:config];
  [PPCheckout start];
}

@end
