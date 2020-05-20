//
//  NSString+CurrencyCodes_EnumParser.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *CurrencyCodes NS_TYPED_EXTENSIBLE_ENUM;
static CurrencyCodes const USD = @"USD";

@interface NSString (EnumParser)

- (CurrencyCodes)parseCurrencyCode;

@end

NS_ASSUME_NONNULL_END
