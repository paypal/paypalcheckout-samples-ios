//
//  CreateOrderResponse.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Link.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *OrderStatus NS_TYPED_EXTENSIBLE_ENUM;
static OrderStatus const OrderStatusCreated = @"CREATED";
static OrderStatus const OrderStatusAuthorized = @"AUTHORIZED";

@interface CreateOrderResponse : NSObject

@property (nonatomic) NSString *id;
@property (nonatomic) NSArray<Link *> *links;
@property (nonatomic) OrderStatus _Nullable orderStatus;

- (id)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
