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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUIWithItem:(PPCPurchaseUnitItem *)item andQuantity:(NSString *)quantity {
  self.nameLabel = [[UILabel alloc] init];
  self.nameLabel.textColor = [UIColor blackColor];
  self.nameLabel.font = [UIFont systemFontOfSize:16];
  self.nameLabel.text = [NSString stringWithFormat:@"%@ x %@", quantity, item.name];
  [self.nameLabel sizeToFit];
  
  self.priceLabel = [[UILabel alloc] init];
  self.priceLabel.textColor = [UIColor blackColor];
  self.priceLabel.font = [UIFont systemFontOfSize:12];
  self.priceLabel.text = [NSString stringWithFormat:@"Price: $%.2lf", [item.quantity doubleValue] * [item.unitAmount.value doubleValue]];
  [self.priceLabel sizeToFit];
  
  self.taxLabel = [[UILabel alloc] init];
  self.taxLabel.textColor = [UIColor blackColor];
  self.taxLabel.font = [UIFont systemFontOfSize:12];
  self.taxLabel.text = [NSString stringWithFormat:@"Tax: $%.2lf", [item.quantity doubleValue] * [item.tax.value doubleValue]];
  
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

@end
