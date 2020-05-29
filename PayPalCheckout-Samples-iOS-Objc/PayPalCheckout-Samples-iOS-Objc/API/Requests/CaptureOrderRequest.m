//
//  CaptureOrderRequest.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/29/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "CaptureOrderRequest.h"

@implementation CaptureOrderRequest

- (id)initWith:(Link *)captureLink {
  self = [super init];
  if (self) {
    self.captureLink = captureLink;
  }
  return self;
}

- (NSDictionary *)properties {
  return @{};
}

- (NSData *)jsonData {
  return [[NSData alloc] init];
}

@end
