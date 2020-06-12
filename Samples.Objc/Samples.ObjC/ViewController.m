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
@property (nonatomic) Link *captureLink;
@property (nonatomic) PPCConfig *config;
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    PayPalAPI *api = [PayPalAPI shared];
    self.config = [
      [PPCConfig alloc]
        initWithClientID:[api clientId]
        payToken:@""
        universalLink:@""
        uriScheme:@"<redirect_uri>"
        onApprove:^(Approval *approval){
            [self processCaptureOrderWith:approval.captureLink];
        }
        onCancel:^{
          NSLog(@"Cancelled");
        }
        onError:^(NSError * _Nonnull error) {
          NSLog(@"Error: %@", error.localizedDescription);
        }
        environment:PPCEnvironmentSandbox
    ];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  PayPalAPI *api = [PayPalAPI shared];
  NSString *clientId = [api clientId];
  FetchAccessTokenRequest *tokenRequest = [[FetchAccessTokenRequest alloc] initWith:clientId];
  
  [api fetchAccessToken:tokenRequest completion:^(NSData * _Nonnull data, NSError * _Nonnull error) {

    if (data == nil) {
      NSLog(@"⚠️: No data received. Check if server is running.");
      return;
    }
    
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

    // Ensure we are setting our presentation controller on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      [self startNativeCheckout:createOrderResponse];
    });
  }];
}

- (void)startNativeCheckout:(CreateOrderResponse *)createOrderResponse {
  
  // Set our capture link
  for (Link *link in createOrderResponse.links) {
    if ([link.rel isEqualToString:@"capture"]) {
      self.captureLink = link;
      break;
    }
  }

  // Set our presentation controler
  self.config.presentingViewController = self;
    
  // Our order response contains our EC-Token / Order id requried to start
  // a checkout experience
  self.config.payToken = createOrderResponse.id;

  [PPCheckout setConfig:self.config];
  [PPCheckout start];
}

- (void)processCaptureOrderWith:(NSString *)captureLink {

  Link *link = [[Link alloc] initWithRef:captureLink rel:@"capture" method:@"POST"];

  // Create request
  CaptureOrderRequest *request = [[CaptureOrderRequest alloc] initWith:link];

  PayPalAPI *api = [PayPalAPI shared];
  [api captureOrder:request completion:^(NSData * _Nonnull data, NSError * _Nonnull error) {
    if (error != nil) {
      NSLog(@"%@", error.localizedDescription);
      return;
    }

    if (data == nil) {
      NSLog(@"No data.");
      return;
    }

    NSError *serializationError;
    NSDictionary *captureResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&serializationError];

    // Success capture / or related response
    NSLog(@"%@", captureResponse);
  }];
}

@end
