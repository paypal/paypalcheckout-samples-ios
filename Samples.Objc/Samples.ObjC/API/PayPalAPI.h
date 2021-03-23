//
//  PayPalAPI.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchAccessTokenRequest.h"
#import "CreateOrderRequest.h"

NS_ASSUME_NONNULL_BEGIN

@protocol Endpoint

- (NSString *)path;
- (NSString *)method;

@end

@interface PayPalAPI : NSObject

@property NSString *clientId;
@property NSString *nodeAppBaseURL;
@property NSString *baseURLv2;
@property NSString * _Nullable accessToken;

/// Shared singleton.
+ (id)shared;

/// Fetch our access token from our node checkout server
- (void)fetchAccessToken:(FetchAccessTokenRequest *)request completion:(void (^)(NSData *data, NSError *error))completion;

/// Create our order through api.sandbox.paypal.com
- (void)createOrder:(CreateOrderRequest *)request completion:(void (^)(NSData *data, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
