//
//  CaptureOrderEndpoint.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/29/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CaptureOrderEndpoint.h"

@implementation CaptureOrderEndpoint

/// Not needed as `href` in CaptureOrderRequest has our path.
- (NSString *)path {
  return @"";
}

- (NSString *)method {
  return @"POST";
}

- (NSURLRequest *)urlRequestFor:(CaptureOrderRequest *)request {
  NSString *fullPath = request.captureLink.href;
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
  return mutableRequest;
}

@end
