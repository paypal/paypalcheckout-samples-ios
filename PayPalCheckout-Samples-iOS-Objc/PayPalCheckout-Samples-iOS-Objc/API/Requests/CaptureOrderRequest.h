//
//  CaptureOrderRequest.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/29/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Link.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaptureOrderRequest : NSObject

@property (nonatomic) Link *captureLink;

- (id)initWith:(Link *)captureLink;
- (NSDictionary *)properties;
- (NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
