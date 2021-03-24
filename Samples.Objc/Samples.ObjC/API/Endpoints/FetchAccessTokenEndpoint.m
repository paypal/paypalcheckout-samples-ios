//
//  FetchAccessTokenEndpoint.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import "FetchAccessTokenEndpoint.h"
#import "PayPalAPI.h"

@implementation FetchAccessTokenEndpoint

- (NSString *)path {
  return @"auth/token";
}

- (NSURLRequest *)urlRequestFor:(FetchAccessTokenRequest *)request {
  NSString *urlString = [NSString stringWithFormat:@"%@%@", [PayPalAPI.shared nodeAppBaseURL], [self path]];
  NSURL *url = [NSURL URLWithString:urlString];
  
  if (!url) {
    return nil;
  }
  
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  NSMutableURLRequest *mutableRequest = [urlRequest mutableCopy];
  [mutableRequest setHTTPMethod:@"POST"];
  [mutableRequest setAllHTTPHeaderFields:request.requestHeader];
  [mutableRequest setHTTPBody:request.requestBody];
  return mutableRequest;
}

@end
