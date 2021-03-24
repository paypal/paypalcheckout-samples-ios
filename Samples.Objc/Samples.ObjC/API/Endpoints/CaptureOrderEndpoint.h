//
//  CaptureOrderEndpoint.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/29/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalAPI.h"
#import "CaptureOrderRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaptureOrderEndpoint : NSObject <Endpoint>

- (NSURLRequest *)urlRequestFor:(CaptureOrderRequest *)request;

@end

NS_ASSUME_NONNULL_END
