//
//  QuantityView.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuantityView : UIView
@property (nonatomic) NSInteger quantity;
- (instancetype)initWithQuantity:(NSInteger)quantity;
@end

NS_ASSUME_NONNULL_END
