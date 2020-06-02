//
//  Link.h
//  PayPalCheckout-Samples-iOS-Objc
//
//  Created by Haider Khan on 5/19/20.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Link : NSObject

@property (nonatomic) NSString *href;
@property (nonatomic) NSString *rel;
@property (nonatomic) NSString *method;

- (id)initWithRef:(NSString *)href rel:(NSString *)rel method:(NSString *)method;
- (id)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
