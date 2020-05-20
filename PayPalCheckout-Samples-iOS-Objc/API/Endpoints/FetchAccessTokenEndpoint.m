//
//  FetchAccessTokenEndpoint.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "FetchAccessTokenEndpoint.h"

@implementation FetchAccessTokenEndpoint

- (NSString *)path {
  return @"auth/token";
}

- (NSString *)method {
  return @"POST";
}

- (NSURLRequest *)urlRequestFor:(FetchAccessTokenRequest *)request {
  NSString *baseUrlString = [[PayPalAPI shared] nodeAppBaseURL];
  NSString *fullPath = [NSString stringWithFormat:@"%@%@", baseUrlString, [self path]];
  NSURL *url = [NSURL URLWithString:fullPath];
  
  if (!url) {
    return nil;
  }
  
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  NSMutableURLRequest *mutableRequest = [urlRequest mutableCopy];
  [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [mutableRequest setHTTPMethod:[self method]];
  [mutableRequest setHTTPBody:[request jsonData]];
  return mutableRequest;
}

@end
