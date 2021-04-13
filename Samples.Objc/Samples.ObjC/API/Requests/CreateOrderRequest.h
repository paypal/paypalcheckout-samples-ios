//
//  CreateOrderRequest.h
//  PayPalNativeCheckoutObjC
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
@import PayPalCheckout;

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderRequest : NSObject

@property (nonatomic) PPCOrderRequest *order;
@property (nonatomic) NSString *accessToken;
- (NSDictionary *)requestHeader;
- (NSData *)requestBody;
- (id)initWithOrder:(PPCOrderRequest*)order accessToken:(NSString*)token;

@end

NS_ASSUME_NONNULL_END
