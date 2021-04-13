//
//  CreateOrderResponse.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CreateOrderResponse.h"

@implementation CreateOrderResponse

- (id)initWithData:(NSData *)data {
  self = [super init];
  if (self) {
    NSError *error;
    NSDictionary *dictionaryFromData = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                        error:&error];
    if (error == nil) {
      if ([dictionaryFromData valueForKey:@"id"]) {
        NSString *orderId = [dictionaryFromData valueForKey:@"id"];
        self.orderId = orderId;
      }
    }
    else {
      self.orderId = @"";
    }
  }
  return self;
}

@end
