//
//  TotalCell.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import "TotalCell.h"

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

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUIWithTotal:(NSString *)total subtotal:(NSString *)subtotal tax:(NSString *)tax {
  self.subtotalLabel = [[UILabel alloc] init];
  self.subtotalLabel.textColor = [UIColor blackColor];
  self.subtotalLabel.font = [UIFont systemFontOfSize:14];
  self.subtotalLabel.text = [NSString stringWithFormat:@"Subtotal: $%.2lf", [subtotal doubleValue]];
  [self.subtotalLabel sizeToFit];
  
  self.taxLabel = [[UILabel alloc] init];
  self.taxLabel.textColor = [UIColor blackColor];
  self.taxLabel.font = [UIFont systemFontOfSize:14];
  self.taxLabel.text = [NSString stringWithFormat:@"Tax: $%.2lf", [tax doubleValue]];
  [self.taxLabel sizeToFit];
  
  self.totalLabel = [[UILabel alloc] init];
  self.totalLabel.textColor = [UIColor blackColor];
  self.totalLabel.font = [UIFont boldSystemFontOfSize:16];
  self.totalLabel.text = [NSString stringWithFormat:@"Total: $%.2lf", [total doubleValue]];
  [self.totalLabel sizeToFit];
  
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
