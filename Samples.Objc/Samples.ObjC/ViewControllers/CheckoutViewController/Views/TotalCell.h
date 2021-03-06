//
//  TotalCell.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TotalCell : UITableViewCell
- (instancetype)initWithTotal:(NSString *)total subtotal:(NSString *)subtotal tax:(NSString *)tax;
@end

NS_ASSUME_NONNULL_END
