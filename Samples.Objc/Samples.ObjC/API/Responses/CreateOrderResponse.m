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
        NSString *id = [dictionaryFromData valueForKey:@"id"];
        self.id = id;
      }
      if ([dictionaryFromData valueForKey:@"links"]) {
        NSArray *linkDictionaries = [dictionaryFromData valueForKey:@"links"];
        NSMutableArray *links = [NSMutableArray new];
        for (NSDictionary *dictionary in linkDictionaries) {
          Link *link = [[Link alloc] initWithDictionary:dictionary];
          [links addObject:link];
        }
        self.links = links;
      }
      if ([dictionaryFromData valueForKey:@"status"]) {
        NSString *orderStatus = [dictionaryFromData valueForKey:@"status"];
        self.orderStatus = orderStatus;
      }
    }
    else {
      self.id = @"";
      self.links = @[];
      self.orderStatus = nil;
    }
  }
  return self;
}

@end
