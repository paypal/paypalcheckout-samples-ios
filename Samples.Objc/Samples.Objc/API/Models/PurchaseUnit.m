//
//  PurchaseUnit.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "PurchaseUnit.h"

@implementation PurchaseUnit

- (id)initWithAmount:(Amount *)amount {
  self = [super init];
  if (self) {
    self.amount = amount;
  }
  return self;
}

- (NSDictionary *)dictionaryRepresentation {
  return @{
    @"amount": [[self amount] dictionaryRepresentation]
  };
}

@end
