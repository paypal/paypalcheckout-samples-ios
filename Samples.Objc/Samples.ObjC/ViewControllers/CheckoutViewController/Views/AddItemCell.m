//
//  AddItemCell.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import "AddItemCell.h"

@interface AddItemCell ()

@property (nonatomic) UILabel *addItemLabel;

@end

@implementation AddItemCell

- (instancetype)init {
  self = [super init];
  self.selectionStyle = UITableViewCellAccessoryNone;
  [self setupUI];
  [self setupConstraints];
  return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUI {
  self.addItemLabel = [[UILabel alloc] init];
  self.addItemLabel.textColor = [UIColor systemBlueColor];
  self.addItemLabel.font = [UIFont systemFontOfSize:16];
  self.addItemLabel.text = @"Add item";
  [self.addItemLabel sizeToFit];
  self.addItemLabel.translatesAutoresizingMaskIntoConstraints = false;
  
  [self.contentView addSubview:self.addItemLabel];
}

- (void)setupConstraints {
  [[self.addItemLabel.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor] setActive:true];
  [[self.addItemLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor] setActive:true];
}

@end
