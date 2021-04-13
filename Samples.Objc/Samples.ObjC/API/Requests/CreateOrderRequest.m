//
//  CreateOrderRequest.m
//  PayPalNativeCheckoutObjC
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CreateOrderRequest.h"

@implementation CreateOrderRequest

- (id)initWithOrder:(PPCOrderRequest*)order accessToken:(NSString*)token {
  self = [super init];
  if (self) {
    self.order = order;
    self.accessToken = token;
  }
  return self;
}

- (NSDictionary *)properties {
  NSString *intentString = [self intentStringFromIntent:self.order.intent];
  NSArray *purchaseUnitDictionaries = [self purchaseUnitDictionariesFromPurchaseUnits:self.order.purchaseUnits];

  return @{
    @"intent": intentString,
    @"purchase_units": purchaseUnitDictionaries
  };
}

- (NSDictionary *)requestHeader {
  return @{
    @"Content-Type": @"application/json",
    @"Authorization": [NSString stringWithFormat:@"Bearer %@", self.accessToken]
  };
}

- (NSData *)requestBody {
  NSError *error;
  NSData *jsonData = [NSJSONSerialization
                      dataWithJSONObject:[self properties]
                      options:0
                      error:&error];
  return jsonData;
}

// MARK: - Utility
- (NSString *)intentStringFromIntent:(PPCOrderIntent)intent {
  if (intent == PPCOrderIntentCapture) {
    return @"CAPTURE";
  } else {
    return @"AUTHORIZE";
  }
}

- (NSArray *)purchaseUnitDictionariesFromPurchaseUnits:(NSArray<PPCPurchaseUnit *> *)purchaseUnits {
  NSMutableArray *purchaseUnitDictionaries = [NSMutableArray new];

  for (PPCPurchaseUnit *purchaseUnit in purchaseUnits) {
    NSArray *itemDictionaries = [self itemDictionariesFromItems:purchaseUnit.items];
    NSDictionary *breakdownDictionary = [self breakdownDictionaryFromBreakdown:purchaseUnit.amount.breakdown];
    NSDictionary *purchaseUnitAmountDictionary = [self purchaseUnitAmountDictionaryFromBreakdownDictionary:breakdownDictionary value:purchaseUnit.amount.value];
    NSDictionary *purchaseUnitDictionary = [self purchaseUnitDictionaryFromPurchaseUnitAmountDictionary:purchaseUnitAmountDictionary itemDictionaries:itemDictionaries];

    [purchaseUnitDictionaries addObject:purchaseUnitDictionary];
  }

  return purchaseUnitDictionaries;
}

- (NSArray *)itemDictionariesFromItems:(NSArray<PPCPurchaseUnitItem *> *  _Nullable)items {
  NSMutableArray *itemDictionaries = nil;

  if (items) {
    itemDictionaries = [NSMutableArray new];

    for (PPCPurchaseUnitItem *item in items) {
      NSDictionary *itemDictionary = [self itemDictionaryFromItem:item];
      [itemDictionaries addObject:itemDictionary];
    }
  }

  return itemDictionaries;
}

- (NSDictionary *)itemDictionaryFromItem:(PPCPurchaseUnitItem *)item {
  NSDictionary *itemUnitAmountDictionary = @{
    @"currency_code": @"USD",
    @"value": item.unitAmount.value
  };
  
  NSString *itemCategoryString = nil;
  if (item.category == PPCPurchaseUnitCategoryDigitalGoods) {
    itemCategoryString = @"DIGITAL_GOODS";
  } else {
    itemCategoryString = @"PHYSICAL_GOODS";
  }
  
  NSDictionary *itemDictionary = @{
    @"name": item.name,
    @"unit_amount": itemUnitAmountDictionary,
    @"quantity": item.quantity,
    @"category": itemCategoryString
  };

  return itemDictionary;
}

- (NSDictionary *)breakdownDictionaryFromBreakdown:(PPCPurchaseUnitBreakdown * _Nullable)breakdown {
  NSMutableDictionary *breakdownDictionary = nil;

  if (breakdown) {
    NSMutableDictionary *itemTotalDictionary = nil;
    if (breakdown.itemTotal) {
      itemTotalDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"currency_code": @"USD",
        @"value": breakdown.itemTotal.value
      }];
    }

    if (itemTotalDictionary) {
      breakdownDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"item_total": itemTotalDictionary,
      }];
    }

    NSMutableDictionary *taxDictionary = nil;
    if (breakdown.taxTotal) {
      taxDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
          @"currency_code": @"USD",
          @"value": breakdown.taxTotal.value
      }];
    }
    
    if (taxDictionary) {
      if (breakdownDictionary) {
        [breakdownDictionary setValue:taxDictionary forKey:@"tax_total"];
      } else {
        breakdownDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
          @"tax_total": taxDictionary,
        }];
      }
    }
  }

  return breakdownDictionary;
}

- (NSDictionary *)purchaseUnitAmountDictionaryFromBreakdownDictionary:(NSDictionary * _Nullable)breakdownDictionary value:(NSString *)value {
  NSMutableDictionary *purchaseUnitAmountDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
    @"currency_code": @"USD",
    @"value": value,
  }];

  if (breakdownDictionary) {
    [purchaseUnitAmountDictionary setValue:breakdownDictionary forKey:@"breakdown"];
  }

  return purchaseUnitAmountDictionary;
}

- (NSDictionary *)purchaseUnitDictionaryFromPurchaseUnitAmountDictionary:(NSDictionary *)purchaseUnitAmountDictionary itemDictionaries:(NSArray * _Nullable)itemDictionaries {
  NSMutableDictionary *purchaseUnitDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
    @"amount": purchaseUnitAmountDictionary,
  }];
  
  if (itemDictionaries) {
    [purchaseUnitDictionary setValue:itemDictionaries forKey:@"items"];
  }

  return purchaseUnitDictionary;
}

@end
