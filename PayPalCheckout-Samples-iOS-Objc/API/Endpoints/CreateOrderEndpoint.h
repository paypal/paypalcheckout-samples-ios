//
//  CreateOrderEndpoint.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalAPI.h"
#import "CreateOrderRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderEndpoint : NSObject <Endpoint>

- (NSURLRequest *)urlRequestFor:(CreateOrderRequest *)request;

@end

NS_ASSUME_NONNULL_END
