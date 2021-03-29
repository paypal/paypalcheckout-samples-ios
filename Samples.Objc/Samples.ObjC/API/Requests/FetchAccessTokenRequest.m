//
//  FetchAccessTokenRequest.m
//  PayPalNativeCheckoutObjC
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

- (NSDictionary *)requestHeader {
  return @{@"Content-Type": @"application/json"};
}

- (NSData *)requestBody {
  NSError *error;
  NSData *data = [NSJSONSerialization dataWithJSONObject:[self properties] options:0 error:&error];
  return data;
}

@end
