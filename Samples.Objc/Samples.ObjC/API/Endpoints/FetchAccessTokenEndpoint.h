//
//  FetchAccessTokenEndpoint.h
//  PayPalNativeCheckoutObjC
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FetchAccessTokenRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FetchAccessTokenEndpoint : NSObject
- (NSURLRequest *)urlRequestFor:(FetchAccessTokenRequest *)request;
@end

NS_ASSUME_NONNULL_END
