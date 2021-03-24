//
//  Link.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "Link.h"

@implementation Link

- (id)initWithRef:(NSString *)href rel:(NSString *)rel method:(NSString *)method {
  self = [super init];
  if (self) {
    self.href = href;
    self.rel = rel;
    self.method = method;
  }
  return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    if ([dict valueForKey:@"href"]) {
      NSString *href = [dict valueForKey:@"href"];
      self.href = href;
    }
    if ([dict valueForKey:@"rel"]) {
      NSString *rel = [dict valueForKey:@"rel"];
      self.rel = rel;
    }
    if ([dict valueForKey:@""]) {
      NSString *method = [dict valueForKey:@"method"];
      self.method = method;
    }
  }
  return self;
}

@end
