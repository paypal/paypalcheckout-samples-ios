//
//  QuantityView.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "QuantityView.h"
#import "UIViewController+Extension.h"

@interface QuantityView ()
@property (nonatomic) UIStackView *stackView;
@property (nonatomic) UIButton *minusButton;
@property (nonatomic) UIButton *plusButton;
@property (nonatomic) UILabel *quantityLabel;
@end

@implementation QuantityView

- (instancetype)initWithQuantity:(NSInteger)quantity {
  self = [super init];
  self.quantity = quantity;
  [self setupUI];
  [self setupConstraints];
  return self;
}

- (void)setupUI {
  self.minusButton = [UIViewController buttonWithColor:[UIColor systemBlueColor] textColor:[UIColor whiteColor] title:@"-" font:[UIFont boldSystemFontOfSize:16]];
  [self.minusButton addTarget:self action:@selector(didTapMinus) forControlEvents:UIControlEventTouchUpInside];
  self.minusButton.translatesAutoresizingMaskIntoConstraints = false;
  [self setupMinusButtonColor];

  self.plusButton = [UIViewController buttonWithColor:[UIColor systemBlueColor] textColor:[UIColor whiteColor] title:@"+" font:[UIFont boldSystemFontOfSize:16]];
  [self.plusButton addTarget:self action:@selector(didTapPlus) forControlEvents:UIControlEventTouchUpInside];
  self.plusButton.translatesAutoresizingMaskIntoConstraints = false;

  self.quantityLabel = [UIViewController labelWithText:@"" font:[UIFont systemFontOfSize:16] color:[UIColor blackColor]];
  self.quantityLabel.textAlignment = NSTextAlignmentCenter;
  [self setQuantityText];
  self.quantityLabel.translatesAutoresizingMaskIntoConstraints = false;
  
  self.stackView = [[UIStackView alloc] init];
  self.stackView.axis = UILayoutConstraintAxisHorizontal;
  self.stackView.distribution = UIStackViewDistributionEqualSpacing;
  self.stackView.alignment = UIStackViewAlignmentFill;
  self.stackView.spacing = 0;
  [self.stackView addArrangedSubview:self.minusButton];
  [self.stackView addArrangedSubview:self.quantityLabel];
  [self.stackView addArrangedSubview:self.plusButton];

  self.stackView.translatesAutoresizingMaskIntoConstraints = false;

  [self addSubview:self.stackView];
}

- (void)setupConstraints {
  [[self.minusButton.heightAnchor constraintEqualToAnchor:self.minusButton.widthAnchor] setActive:true];
  
  [[self.plusButton.heightAnchor constraintEqualToAnchor:self.plusButton.widthAnchor] setActive:true];
  
  [[self.stackView.topAnchor constraintEqualToAnchor:self.topAnchor] setActive:true];
  [[self.stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor] setActive:true];
  [[self.stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:true];
  [[self.stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:true];
}

- (void)setupMinusButtonColor {
  if (self.quantity > 1) {
    self.minusButton.backgroundColor = [UIColor systemBlueColor];
  } else {
    self.minusButton.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.5];
  }
}

- (void)didTapMinus {
  if (self.quantity > 1) {
    self.quantity -= 1;
    [self setQuantityText];
    [self setupMinusButtonColor];
  }
}

- (void)didTapPlus {
  self.quantity += 1;
  [self setQuantityText];
  [self setupMinusButtonColor];
}

- (void)setQuantityText {
  NSString *quantityText = [NSString stringWithFormat: @"%ld", (long)self.quantity];
  self.quantityLabel.text = quantityText;
}

@end
