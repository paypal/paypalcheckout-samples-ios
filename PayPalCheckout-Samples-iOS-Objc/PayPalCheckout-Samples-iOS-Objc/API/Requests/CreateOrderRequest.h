//
//  CreateOrderRequest.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PurchaseUnit.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateOrderRequest : NSObject

@property (nonatomic) OrderIntent intent;
@property (nonatomic) NSArray *purchaseUnits;

- (id)initWith:(OrderIntent)intent purchaseUnits:(NSArray<PurchaseUnit *> *)purchaseUnits;
- (NSDictionary *)properties;
- (NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
