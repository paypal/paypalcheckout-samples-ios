//
//  UIViewController+Extension.m
//  Samples.ObjC
//
//  Created by Nguyen, The Nhat Minh on 4/7/21.
//  Copyright © 2021 PayPal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+Extension.h"

@implementation UIViewController (Views)

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
  UILabel *label = [[UILabel alloc] init];
  label.text = text;
  label.font = font;
  label.textColor = color;
  [label sizeToFit];
  return label;
}

+ (UIButton *)buttonWithColor:(UIColor *)color textColor:(UIColor *)textColor title:(NSString *)title font:(UIFont *)font {
  UIButton *button = [[UIButton alloc] init];
  button.backgroundColor = color;
  button.tintColor = textColor;
  [button setTitle:title forState:UIControlStateNormal];
  [button.titleLabel setFont:font];
  button.layer.cornerRadius = 8;
  return button;
}

@end
