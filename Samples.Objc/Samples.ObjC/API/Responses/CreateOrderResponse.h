//
//  CreateOrderResponse.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderResponse : NSObject

@property (nonatomic) NSString *orderId;
- (id)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
