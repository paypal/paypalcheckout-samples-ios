//
//  UIViewController+Extension.h
//  Samples.ObjC
//
//  Created by Nguyen, The Nhat Minh on 4/7/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Views)
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;
+ (UIButton *)buttonWithColor:(UIColor *)color textColor:(UIColor *)textColor title:(NSString *)title font:(UIFont *)font;
@end
