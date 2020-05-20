//
//  PayPalAPI.m
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/18/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPalAPI.h"
#import "FetchAccessTokenEndpoint.h"
#import "CreateOrderEndpoint.h"

@interface PayPalAPI ()
@property (nonatomic) FetchAccessTokenEndpoint *accessTokenEndpoint;
@property (nonatomic) CreateOrderEndpoint *createOrderEndpoint;
@end

@implementation PayPalAPI

// MARK: - Singleton

+ (id)shared {
  static PayPalAPI *sharedAPI = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedAPI = [[self alloc] init];
  });
  return sharedAPI;
}

// MARK: - Private Init

- (id)init {
  if (self = [super init]) {
    self.clientId = @"AS3EgF_yK_ATkJqgzs4Ydyn2kGpklCFgV4rQOaFqTR0HS3CozKznnP4dG8F2DE5ccNBWCvfxUCO5mNq3";
    self.nodeAppBaseURL = @"http://localhost:3000/";
    self.baseURLv2 = @"https://api.sandbox.paypal.com/v2/";
    self.accessTokenEndpoint = [[FetchAccessTokenEndpoint alloc] init];
    self.createOrderEndpoint = [[CreateOrderEndpoint alloc] init];
  }
  return self;
}

// MARK: - Request

- (void)fetchAccessToken:(FetchAccessTokenRequest *)request completion:(void (^)(NSData *data, NSError *error))completion {
  NSURLRequest *urlRequest = [self.accessTokenEndpoint urlRequestFor:request];
  [[[NSURLSession sharedSession]
    dataTaskWithRequest:urlRequest
    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
      completion(nil, error);
      return;
    }
    completion(data, nil);
  }] resume];
}

- (void)createOrder:(CreateOrderRequest *)request completion:(void (^)(NSData *data, NSError *error))completion {
  NSURLRequest *urlRequest = [self.createOrderEndpoint urlRequestFor:request];
  [[[NSURLSession sharedSession]
    dataTaskWithRequest:urlRequest
    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (error) {
      completion(nil, error);
      return;
    }
    completion(data, nil);
  }] resume];
}

@end
