//
//  CreateOrderEndpoint.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import "CreateOrderEndpoint.h"

@implementation CreateOrderEndpoint

- (NSURLRequest *)urlRequestFor:(CreateOrderRequest *)request {
  NSString *urlString = @"https://api.sandbox.paypal.com/v2/checkout/orders";
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
