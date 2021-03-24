//
//  Amount.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+CurrencyCodes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Amount : NSObject

@property (nonatomic) CurrencyCodes currencyCode;
@property (nonatomic) NSString *value;

- (id)initWithCurrencyCode:(CurrencyCodes)currencyCode value:(NSString *)value;
- (id)initWithData:(NSData *)data;
- (NSDictionary *)dictionaryRepresentation;

@end

NS_ASSUME_NONNULL_END
