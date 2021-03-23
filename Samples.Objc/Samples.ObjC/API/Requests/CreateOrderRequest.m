//
//  CreateOrderRequest.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import "CreateOrderRequest.h"

@implementation CreateOrderRequest

- (id)initWithOrder:(PPCOrderRequest*)order andAccessToken:(NSString*)token {
  self = [super init];
  if (self) {
    self.order = order;
    self.accessToken = token;
  }
  return self;
}

- (NSDictionary *)properties {
  NSString *intentString = @"";
  if (intentString == PPCOrderIntentCapture) {
    intentString = @"CAPTURE";
  } else {
    intentString = @"AUTHORIZE";
  }

  NSMutableArray *purchaseUnitDictionaries = [NSMutableArray new];
  for (PPCPurchaseUnit *purchaseUnit in self.order.purchaseUnits) {
    
    NSMutableArray *itemsDictionary = [NSMutableArray new];
    
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
      
      [itemsDictionary addObject:itemDictionary];
    }
    
    NSDictionary *breakdownItemTotalDictionary = @{
      @"currency_code": @"USD",
      @"value": purchaseUnit.amount.breakdown.itemTotal.value
    };
    
    NSDictionary *breakdownDictionary = @{
      @"item_total": breakdownItemTotalDictionary
    };
    
    NSDictionary *purchaseUnitAmountDictionary = @{
      @"currency_code": @"USD",
      @"value": purchaseUnit.amount.value,
      @"breakdown": breakdownDictionary
    };
    
    NSDictionary *purchaseUnitDictionary = @{
      @"amount": purchaseUnitAmountDictionary,
      @"items": itemsDictionary
    };

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
