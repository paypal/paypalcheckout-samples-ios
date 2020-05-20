//
//  CreateOrderRequest.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CreateOrderRequest.h"

@implementation CreateOrderRequest

- (id)initWith:(OrderIntent)intent purchaseUnits:(NSArray *)purchaseUnits {
  self = [super init];
  if (self) {
    self.intent = intent;
    self.purchaseUnits = purchaseUnits;
  }
  return self;
}

- (NSDictionary *)properties {

  // Convert purchase units to json
  NSMutableArray *purchaseUnitDictionaries = [NSMutableArray new];
  for (PurchaseUnit *purchaseUnit in [self purchaseUnits]) {
    NSDictionary *purchaseUnitDictionary = [purchaseUnit dictionaryRepresentation];
    [purchaseUnitDictionaries addObject:purchaseUnitDictionary];
  }
 
  return @{
    @"intent": [self intent],
    @"purchase_units": purchaseUnitDictionaries
  };
}

- (NSData *)jsonData {
  NSError *error;
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:[self properties]
                      options:0 // Pass 0 if you don't care about the readability of the generated string
                      error:&error];
  return jsonData;
}

@end
