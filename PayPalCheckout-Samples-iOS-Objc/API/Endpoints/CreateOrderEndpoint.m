//
//  CreateOrderEndpoint.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CreateOrderEndpoint.h"

@implementation CreateOrderEndpoint

- (NSString *)path {
  return @"checkout/orders";
}

- (NSString *)method {
  return @"POST";
}

- (NSURLRequest *)urlRequestFor:(CreateOrderRequest *)request {
  NSString *baseUrlString = [[PayPalAPI shared] baseURLv2];
  NSString *fullPath = [NSString stringWithFormat:@"%@%@", baseUrlString, [self path]];
  NSURL *url = [NSURL URLWithString:fullPath];
  
  if (!url) {
    return nil;
  }
  
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  NSMutableURLRequest *mutableRequest = [urlRequest mutableCopy];
  [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  NSString *accessToken = [[PayPalAPI shared] accessToken];
  [mutableRequest addValue:[NSString stringWithFormat:@"Bearer %@", accessToken] forHTTPHeaderField:@"Authorization"];
  [mutableRequest setHTTPMethod:[self method]];
  [mutableRequest setHTTPBody:[request jsonData]];
  return mutableRequest;
}

@end
