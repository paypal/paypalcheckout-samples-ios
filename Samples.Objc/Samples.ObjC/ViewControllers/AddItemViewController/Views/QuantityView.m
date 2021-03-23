//
//  QuantityView.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/14/21.
//

#import "QuantityView.h"

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
  self.minusButton = [[UIButton alloc] init];
  self.minusButton.backgroundColor = [UIColor systemGray3Color];
  self.minusButton.tintColor = [UIColor whiteColor];
  [self.minusButton setTitle:@"-" forState:UIControlStateNormal];
  [self.minusButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
  [self.minusButton addTarget:self action:@selector(tapMinus) forControlEvents:UIControlEventTouchUpInside];
  self.minusButton.translatesAutoresizingMaskIntoConstraints = false;
  self.minusButton.layer.cornerRadius = 8;
  
  self.plusButton = [[UIButton alloc] init];
  self.plusButton.backgroundColor = [UIColor systemGray3Color];
  self.plusButton.tintColor = [UIColor whiteColor];
  [self.plusButton setTitle:@"+" forState:UIControlStateNormal];
  [self.plusButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
  [self.plusButton addTarget:self action:@selector(tapPlus) forControlEvents:UIControlEventTouchUpInside];
  self.plusButton.translatesAutoresizingMaskIntoConstraints = false;
  self.plusButton.layer.cornerRadius = 8;
  
  self.quantityLabel = [[UILabel alloc] init];
  self.quantityLabel.font = [UIFont systemFontOfSize:16];
  self.quantityLabel.textAlignment = NSTextAlignmentCenter;
  [self.quantityLabel sizeToFit];
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

- (void)tapMinus {
  if (self.quantity > 1) {
    self.quantity -= 1;
    [self setQuantityText];
  }
}

- (void)tapPlus {
  self.quantity += 1;
  [self setQuantityText];
}

- (void)setQuantityText {
  NSString *quantityText = [NSString stringWithFormat: @"%ld", (long)self.quantity];
  self.quantityLabel.text = quantityText;
}

@end
