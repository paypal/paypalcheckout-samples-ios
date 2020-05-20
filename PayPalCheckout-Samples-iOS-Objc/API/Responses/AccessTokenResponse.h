//
//  AccessTokenResponse.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccessTokenResponse : NSObject

@property (nonatomic) NSArray *scopes;
@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSString *appId;
@property (nonatomic) NSString  * _Nullable tokenType;
@property (nonatomic) NSInteger expiresIn;
@property (nonatomic) NSString *nonce;

- (id)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
