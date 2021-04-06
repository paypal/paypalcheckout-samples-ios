//
//  ItemCell.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *taxLabel;

@end

@implementation ItemCell

- (instancetype)initWithItem:(PPCPurchaseUnitItem *)item andQuantity:(NSString *)quantity {
  self = [super init];
  self.selectionStyle = UITableViewCellAccessoryNone;
  [self setupUIWithItem:item andQuantity:quantity];
  [self setupConstraints];
  return self;
}

- (void)setupUIWithItem:(PPCPurchaseUnitItem *)item andQuantity:(NSString *)quantity {
  self.nameLabel = [self createLabelWithText:[NSString stringWithFormat:@"%@ x %@", quantity, item.name]
                                    fontSize:16];

  self.priceLabel = [self createLabelWithText:[NSString stringWithFormat:@"Price: $%.2lf", [item.quantity doubleValue] * [item.unitAmount.value doubleValue]]
                                     fontSize:12];

  self.taxLabel = [self createLabelWithText:[NSString stringWithFormat:@"Tax: $%.2lf", [item.quantity doubleValue] * [item.tax.value doubleValue]]
                                   fontSize:12];
  
  self.stackView = [[UIStackView alloc] init];
  self.stackView.axis = UILayoutConstraintAxisVertical;
  self.stackView.distribution = UIStackViewDistributionEqualSpacing;
  self.stackView.alignment = UIStackViewAlignmentLeading;
  self.stackView.spacing = 8;
  [self.stackView addArrangedSubview:self.nameLabel];
  [self.stackView addArrangedSubview:self.priceLabel];
  [self.stackView addArrangedSubview:self.taxLabel];

  self.stackView.translatesAutoresizingMaskIntoConstraints = false;

  [self.contentView addSubview:self.stackView];
}

- (void)setupConstraints {
  [[self.stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16] setActive:true];
  [[self.stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16] setActive:true];
  [[self.stackView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16] setActive:true];
  [[self.stackView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16] setActive:true];
}

- (NSString *)getTotalPriceOfItem:(PPCPurchaseUnitItem *)item {
  NSNumber *total = [NSNumber numberWithDouble:[item.quantity doubleValue] * [item.unitAmount.value doubleValue]];
  return [total stringValue];
}

- (UILabel *)createLabelWithText:(NSString *)text fontSize:(NSInteger)fontSize {
  UILabel *label = [[UILabel alloc] init];
  label.textColor = [UIColor blackColor];
  label.font = [UIFont systemFontOfSize:fontSize];
  label.text = text;
  [label sizeToFit];
  return label;
}

@end
