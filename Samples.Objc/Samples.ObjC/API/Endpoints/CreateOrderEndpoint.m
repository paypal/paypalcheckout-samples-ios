//
//  CreateOrderEndpoint.m
//  PayPalNativeCheckoutObjC
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CreateOrderEndpoint.h"
#import "PayPalAPI.h"

@implementation CreateOrderEndpoint

- (NSString *)path {
  return @"checkout/orders";
}

- (NSURLRequest *)urlRequestFor:(CreateOrderRequest *)request {
  NSString *urlString = [NSString stringWithFormat:@"%@%@", [PayPalAPI.shared baseURLv2], [self path]];
  NSURL *url = [NSURL URLWithString:urlString];
  
  if (!url) {
    return nil;
  }
  
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  NSMutableURLRequest *mutableRequest = [urlRequest mutableCopy];
  [mutableRequest setHTTPMethod:@"POST"];
  [mutableRequest setAllHTTPHeaderFields:[request requestHeader]];
  [mutableRequest setHTTPBody:[request requestBody]];
  return mutableRequest;
}

@end
