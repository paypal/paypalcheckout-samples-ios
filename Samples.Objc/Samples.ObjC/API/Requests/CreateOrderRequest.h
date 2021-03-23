//
//  CreateOrderRequest.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import <Foundation/Foundation.h>
@import PayPalCheckout;

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderRequest : NSObject

@property (nonatomic) PPCOrderRequest *order;
@property (nonatomic) NSString *accessToken;
- (NSDictionary *)requestHeader;
- (NSData *)requestBody;
- (id)initWithOrder:(PPCOrderRequest*)order andAccessToken:(NSString*)token;

@end

NS_ASSUME_NONNULL_END
