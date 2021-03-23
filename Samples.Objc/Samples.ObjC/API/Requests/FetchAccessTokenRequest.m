//
//  FetchAccessTokenRequest.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import "FetchAccessTokenRequest.h"

@implementation FetchAccessTokenRequest

- (id)initWith:(NSString *)clientId {
  self = [super init];
  if (self) {
    self.clientId = clientId;
  }
  return self;
}

- (NSDictionary *)requestHeader {
  return @{@"Authorization": [NSString stringWithFormat:@"Basic %@", [[self.clientId dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]]};
}

- (NSData *)requestBody {
  return [@"grant_type=client_credentials" dataUsingEncoding:NSUTF8StringEncoding];
}

@end
