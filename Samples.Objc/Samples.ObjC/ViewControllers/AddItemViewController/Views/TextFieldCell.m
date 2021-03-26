//
//  TextFieldCell.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import "TextFieldCell.h"

@interface TextFieldCell ()
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextField *textField;
@end

@implementation TextFieldCell

- (instancetype)initWithTitle:(NSString *)title andPlaceholder:(NSString *)placeHolder andText:(NSString *)text andKeyboardType:(UIKeyboardType)type {
  self = [super init];
  self.selectionStyle = UITableViewCellAccessoryNone;
  [self setupUIWithTitle:title andPlaceholder:placeHolder andText:text andKeyboardType:type];
  [self setupConstraints];
  return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupUIWithTitle:(NSString *)title andPlaceholder:(NSString *)placeHolder andText:(NSString *)text andKeyboardType:(UIKeyboardType)type {
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.textColor = [UIColor blackColor];
  self.titleLabel.font = [UIFont systemFontOfSize:12];
  self.titleLabel.text = title;
  [self.titleLabel sizeToFit];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
  
  self.textField = [[UITextField alloc] init];
  self.textField.textColor = [UIColor blackColor];
  self.textField.font = [UIFont systemFontOfSize:16];
  self.textField.placeholder = placeHolder;
  self.textField.text = text;
  self.textField.keyboardType = type;
  self.textField.returnKeyType = UIReturnKeyDone;
  
  if (type != UIKeyboardTypeDefault) {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTyping)];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, barButtonItem, nil]];
    self.textField.inputAccessoryView = toolbar;
  }
  
  self.textField.translatesAutoresizingMaskIntoConstraints = false;
  self.textField.delegate = self;

  [self.contentView addSubview:self.titleLabel];
  [self.contentView addSubview:self.textField];
}

- (void)doneTyping {
  [self.textField resignFirstResponder];
}

- (void)setupConstraints {
  [[self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:16] setActive:true];
  [[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16] setActive:true];
  [[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.textField.topAnchor constant:-8] setActive:true];
  
  [[self.textField.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16] setActive:true];
  [[self.textField.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16] setActive:true];
  [[self.textField.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16] setActive:true];
}

// MARK: - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self.delegate cell:self textFieldDidEndEditing:self.textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.textField) {
    [textField resignFirstResponder];
    return false;
  }
  return true;
}
@end