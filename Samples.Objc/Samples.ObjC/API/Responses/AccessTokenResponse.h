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

@property (nonatomic) NSString *accessToken;
- (id)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
