//
//  TotalCell.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import "TotalCell.h"

@interface TotalCell ()

@property (nonatomic) UILabel *totalLabel;

@end

@implementation TotalCell

- (instancetype)initWithTotal:(NSString *)total {
  self = [super init];
  self.selectionStyle = UITableViewCellAccessoryNone;
  [self setupUIWithTotal:total];
  [self setupConstraints];
  return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUIWithTotal:(NSString *)total {
  self.totalLabel = [[UILabel alloc] init];
  self.totalLabel.textColor = [UIColor blackColor];
  self.totalLabel.font = [UIFont boldSystemFontOfSize:16];
  self.totalLabel.text = [NSString stringWithFormat:@"Price: $%.2lf", [total doubleValue]];
  [self.totalLabel sizeToFit];
  self.totalLabel.translatesAutoresizingMaskIntoConstraints = false;
  
  [self.contentView addSubview:self.totalLabel];
}

- (void)setupConstraints {
  [[self.totalLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16] setActive:true];
  [[self.totalLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16] setActive:true];
  [[self.totalLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16] setActive:true];
}

@end
