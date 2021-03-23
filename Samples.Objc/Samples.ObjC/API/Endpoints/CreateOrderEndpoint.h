//
//  CreateOrderEndpoint.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import <Foundation/Foundation.h>
#import "CreateOrderRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderEndpoint : NSObject
- (NSURLRequest *)urlRequestFor:(CreateOrderRequest *)request;
@end

NS_ASSUME_NONNULL_END
