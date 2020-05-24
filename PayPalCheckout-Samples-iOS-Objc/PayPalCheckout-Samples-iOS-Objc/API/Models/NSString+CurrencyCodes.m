//
//  NSString+CurrencyCodes_EnumParser.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "NSString+CurrencyCodes.h"

@implementation NSString (EnumParser)

- (CurrencyCodes)parseCurrencyCode {
  NSDictionary<NSString *, NSString *> *currencies = @{
    @"USD": USD
  };
  return currencies[self];
}

@end
