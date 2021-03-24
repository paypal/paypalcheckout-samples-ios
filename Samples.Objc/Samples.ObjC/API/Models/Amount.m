//
//  Amount.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "Amount.h"

@implementation Amount

- (id)initWithCurrencyCode:(CurrencyCodes)currencyCode value:(NSString *)value {
  self = [super init];
  if (self) {
    self.currencyCode = currencyCode;
    self.value = value;
  }
  return self;
}

- (id)initWithData:(NSData *)data {
  self = [super init];
  if (self) {
    NSError *error;
    NSDictionary *dictionaryFromData = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                        error:&error];
    if (error == nil) {
      if ([dictionaryFromData valueForKey:@"currency_code"]) {
        NSString *currencyCode = [dictionaryFromData valueForKey:@"currency_code"];
        self.currencyCode = [currencyCode parseCurrencyCode];
      }
      if ([dictionaryFromData valueForKey:@"value"]) {
        NSString *value = [dictionaryFromData valueForKey:@"value"];
        self.value = value;
      }
    }
    else {
      self.currencyCode = USD;
      self.value = @"";
    }
  }
  return self;
}

- (NSDictionary *)dictionaryRepresentation {
  return @{
    @"currency_code": [self currencyCode],
    @"value": [self value]
  };
}

@end
