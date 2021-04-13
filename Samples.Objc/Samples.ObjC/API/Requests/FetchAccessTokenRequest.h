//
//  FetchAccessTokenRequest.h
//  PayPalNativeCheckoutObjC
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FetchAccessTokenRequest : NSObject

@property (nonatomic) NSString *clientId;
- (NSDictionary *)requestHeader;
- (NSData *)requestBody;
- (id)initWith:(NSString *)clientId;

@end

NS_ASSUME_NONNULL_END
