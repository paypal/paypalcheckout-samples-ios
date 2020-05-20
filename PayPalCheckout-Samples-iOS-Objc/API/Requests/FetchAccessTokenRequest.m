//
//  FetchAccessTokenRequest.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "FetchAccessTokenRequest.h"

@implementation FetchAccessTokenRequest

- (id)initWith:(NSString *)clientId {
  self = [super init];
  if (self) {
    self.clientId = clientId;
  }
  return self;
}

- (NSDictionary *)properties {
  return @{
    @"clientId": [self clientId]
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
