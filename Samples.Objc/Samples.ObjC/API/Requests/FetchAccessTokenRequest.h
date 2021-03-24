//
//  FetchAccessTokenRequest.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
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
