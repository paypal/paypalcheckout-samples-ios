//
//  FetchAccessTokenRequest.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FetchAccessTokenRequest : NSObject

@property (nonatomic) NSString *clientId;

- (id)initWith:(NSString *)clientId;
- (NSDictionary *)properties;
- (NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
