//
//  FetchAccessTokenEndpoint.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import <Foundation/Foundation.h>
#import "FetchAccessTokenRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FetchAccessTokenEndpoint : NSObject
- (NSURLRequest *)urlRequestFor:(FetchAccessTokenRequest *)request;
@end

NS_ASSUME_NONNULL_END
