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
  NSString *intentString;
  if (self.order.intent == PPCOrderIntentCapture) {
    intentString = @"CAPTURE";
  } else {
    intentString = @"AUTHORIZE";
  }

  NSMutableArray *purchaseUnitDictionaries = [NSMutableArray new];
  for (PPCPurchaseUnit *purchaseUnit in self.order.purchaseUnits) {
    
    NSMutableArray *itemDictionaries = [NSMutableArray new];
    
    if (purchaseUnit.items) {
      for (PPCPurchaseUnitItem *item in purchaseUnit.items) {
        
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
        
        [itemDictionaries addObject:itemDictionary];
      }
    }

    NSMutableDictionary *breakdownDictionary = nil;
    if (purchaseUnit.amount.breakdown) {
      NSMutableDictionary *itemTotalDictionary = nil;
      if (purchaseUnit.amount.breakdown.itemTotal) {
        itemTotalDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
          @"currency_code": @"USD",
          @"value": purchaseUnit.amount.breakdown.itemTotal.value
        }];
      }

      if (itemTotalDictionary) {
        breakdownDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
          @"item_total": itemTotalDictionary,
        }];
      }

      NSMutableDictionary *taxDictionary = nil;
      if (purchaseUnit.amount.breakdown.taxTotal) {
        taxDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
            @"currency_code": @"USD",
            @"value": purchaseUnit.amount.breakdown.taxTotal.value
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
        
    NSMutableDictionary *purchaseUnitAmountDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
      @"currency_code": @"USD",
      @"value": purchaseUnit.amount.value,
    }];

    if (breakdownDictionary) {
      [purchaseUnitAmountDictionary setValue:breakdownDictionary forKey:@"breakdown"];
    }
    
    NSMutableDictionary *purchaseUnitDictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
      @"amount": purchaseUnitAmountDictionary,
    }];
    
    if ([itemDictionaries count] != 0) {
      [purchaseUnitDictionary setValue:itemDictionaries forKey:@"items"];
    }

    [purchaseUnitDictionaries addObject:purchaseUnitDictionary];
  }
  
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

@end
