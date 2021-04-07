//
//  TotalCell.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "TotalCell.h"
#import "UIViewController+Extension.h"

@interface TotalCell ()

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UILabel *subtotalLabel;
@property (nonatomic) UILabel *taxLabel;
@property (nonatomic) UILabel *totalLabel;

@end

@implementation TotalCell

- (instancetype)initWithTotal:(NSString *)total subtotal:(NSString *)subtotal tax:(NSString *)tax {
  self = [super init];
  self.selectionStyle = UITableViewCellAccessoryNone;
  [self setupUIWithTotal:total subtotal:subtotal tax:tax];
  [self setupConstraints];
  return self;
}

- (void)setupUIWithTotal:(NSString *)total subtotal:(NSString *)subtotal tax:(NSString *)tax {
  self.subtotalLabel = [UIViewController labelWithText:[NSString stringWithFormat:@"Subtotal: $%.2lf", [subtotal doubleValue]]
                                                  font:[UIFont systemFontOfSize:14]
                                                 color:[UIColor blackColor]];
  self.taxLabel = [UIViewController labelWithText:[NSString stringWithFormat:@"Tax: $%.2lf", [tax doubleValue]]
                                             font:[UIFont systemFontOfSize:14]
                                            color:[UIColor blackColor]];
  self.totalLabel = [UIViewController labelWithText:[NSString stringWithFormat:@"Total: $%.2lf", [total doubleValue]]
                                               font:[UIFont boldSystemFontOfSize:16]
                                              color:[UIColor blackColor]];
  
  self.stackView = [[UIStackView alloc] init];
  self.stackView.axis = UILayoutConstraintAxisVertical;
  self.stackView.distribution = UIStackViewDistributionEqualSpacing;
  self.stackView.alignment = UIStackViewAlignmentTrailing;
  self.stackView.spacing = 8;
  [self.stackView addArrangedSubview:self.subtotalLabel];
  [self.stackView addArrangedSubview:self.taxLabel];
  [self.stackView addArrangedSubview:self.totalLabel];

  self.stackView.translatesAutoresizingMaskIntoConstraints = false;

  [self.contentView addSubview:self.stackView];
}

- (void)setupConstraints {
  [[self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16] setActive:true];
  [[self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16] setActive:true];
  [[self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16] setActive:true];
  [[self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16] setActive:true];
}

@end
