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
    }
    else {
      self.accessToken = @"";
    }
  }
  return self;
}

@end
