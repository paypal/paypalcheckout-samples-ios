//
//  PurchaseUnit.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Amount.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *OrderIntent NS_TYPED_EXTENSIBLE_ENUM;
static OrderIntent const OrderIntentCapture = @"CAPTURE";
static OrderIntent const OrderIntentAuthorize = @"AUTHORIZE";

@interface PurchaseUnit : NSObject

@property (nonatomic) Amount *amount;

- (id)initWithAmount:(Amount *)amount;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
