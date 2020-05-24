//
//  AccessTokenResponse.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "AccessTokenResponse.h"

@implementation AccessTokenResponse

- (id)initWithData:(NSData *)data {
  self = [super init];
  if (self) {
    NSError *error;
    NSDictionary *dictionaryFromData = [NSJSONSerialization
                                        JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                        error:&error];
    if (error == nil) {
      if ([dictionaryFromData valueForKey:@"access_token"]) {
        NSString *accessToken = [[dictionaryFromData valueForKey:@"access_token"] stringValue];
        self.accessToken = accessToken;
      }
      if ([dictionaryFromData valueForKey:@"app_id"]) {
        NSString *appId = [[dictionaryFromData valueForKey:@"app_id"] stringValue];
        self.appId = appId;
      }
      if ([dictionaryFromData valueForKey:@"expires_in"]) {
        NSInteger expiresIn = [[dictionaryFromData valueForKey:@"expires_in"] intValue];
        self.expiresIn = expiresIn;
      }
      if ([dictionaryFromData valueForKey:@"nonce"]) {
        NSString *nonce = [[dictionaryFromData valueForKey:@"nonce"] stringValue];
        self.nonce = nonce;
      }
      if ([dictionaryFromData valueForKey:@"scopes"]) {
        NSString *scopesString = [[dictionaryFromData valueForKey:@"scopes"] stringValue];
        self.scopes = [scopesString componentsSeparatedByString:@" "];
      }
      if ([dictionaryFromData valueForKey:@"tokenType"]) {
        NSString *tokenType = [[dictionaryFromData valueForKey:@"token_type"] stringValue];
        self.tokenType = tokenType;
      }
    }
    else {
      self.accessToken = @"";
      self.appId = @"";
      self.expiresIn = 0;
      self.nonce = @"";
      self.scopes = [NSArray new];
      self.tokenType = nil;
    }
  }
  return self;
}

@end
