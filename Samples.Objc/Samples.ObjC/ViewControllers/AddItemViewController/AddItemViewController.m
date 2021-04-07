//
//  AddItemViewController.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import "AddItemViewController.h"
#import "TextFieldCell.h"
#import "QuantityView.h"

@interface AddItemViewController ()
@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *itemPrice;
@property (nonatomic) NSString *itemTax;
@property (nonatomic) NSString *itemQuantity;
@property (nonatomic) NSString *titleText;
@property (nonatomic) NSString *buttonTitle;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) QuantityView *quantityView;
@property (nonatomic) UIButton *saveButton;
@property (nonatomic) NSLayoutConstraint *containerViewBottom;
@property (nonatomic) NSLayoutConstraint *saveButtonBottom;
@end

@implementation AddItemViewController

- (instancetype)init {
  self = [super init];
  self.itemName = @"";
  self.itemPrice = @"";
  self.itemTax = @"";
  self.itemQuantity = @"1";
  self.titleText = @"Add to cart";
  self.buttonTitle = @"Add";
  return self;
}

- (instancetype)initWithItem:(PPCPurchaseUnitItem *)item {
  self = [super init];
  self.itemName = item.name;
  self.itemPrice = item.unitAmount.value;
  self.itemTax = item.tax.value;
  self.itemQuantity = item.quantity;
  self.titleText = @"Edit item";
  self.buttonTitle = @"Save";
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupUI];
  [self setupTableView];
  [self setupConstraints];
  [self registerListeners];
}

- (void)registerListeners {
  [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  self.containerViewBottom.constant = 0;
  self.saveButtonBottom.constant = -16;
  [UIView animateWithDuration:0.2 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
  if (notification.userInfo[UIKeyboardFrameEndUserInfoKey]) {
    self.containerViewBottom.constant = -[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.saveButtonBottom.constant = -16 - [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [UIView animateWithDuration:0.2 animations:^{
      [self.view layoutIfNeeded];
    }];
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  CAShapeLayer * maskLayer = [CAShapeLayer layer];
  maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: self.containerView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){16, 16}].CGPath;
  self.containerView.layer.mask = maskLayer;
}

- (void)setupTableView {
  [self.tableView registerClass:[TextFieldCell class] forCellReuseIdentifier:@"TextFieldCell"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

- (void)setButtonEnabled {
  if ([self.itemName isEqualToString:@""] || [self.itemPrice isEqualToString:@""] || [self.itemTax isEqualToString:@""]) {
    [self.saveButton setUserInteractionEnabled:false];
    self.saveButton.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.5];
  } else {
    [self.saveButton setUserInteractionEnabled:true];
    self.saveButton.backgroundColor = [UIColor systemBlueColor];
  }
}

- (void)didTapSave {
  PPCPurchaseUnitItem *item = [[PPCPurchaseUnitItem alloc] initWithName:self.itemName
                                                             unitAmount:[[PPCUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd value:self.itemPrice]
                                                               quantity:[NSString stringWithFormat: @"%ld", (long)self.quantityView.quantity]
                                                                    tax:[[PPCPurchaseUnitTax alloc] initWithCurrencyCode:PPCCurrencyCodeUsd value:self.itemTax]
                                                        itemDescription:nil
                                                                    sku:nil
                                                               category:PPCPurchaseUnitCategoryPhysicalGoods];
  [self.delegate didTapSaveWithItem:item at:self.index];
  [self dismissViewControllerAnimated:true completion:^{}];
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor clearColor];
  
  self.containerView = [[UIView alloc] init];
  self.containerView.backgroundColor = [UIColor whiteColor];
  self.containerView.translatesAutoresizingMaskIntoConstraints = false;
  
  self.titleLabel = [[UILabel alloc] init];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
  self.titleLabel.text = self.titleText;
  [self.titleLabel sizeToFit];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
  
  self.tableView = [[UITableView alloc] init];
  self.tableView.alwaysBounceVertical = false;
  self.tableView.translatesAutoresizingMaskIntoConstraints = false;
  
  self.quantityView = [[QuantityView alloc] initWithQuantity:[self.itemQuantity integerValue]];
  self.quantityView.translatesAutoresizingMaskIntoConstraints = false;
  
  self.saveButton = [[UIButton alloc] init];
  self.saveButton.layer.cornerRadius = 8;
  self.saveButton.backgroundColor = [UIColor systemBlueColor];
  self.saveButton.tintColor = [UIColor whiteColor];
  [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
  [self.saveButton setTitle:self.buttonTitle forState:UIControlStateNormal];
  [self.saveButton addTarget:self action:@selector(didTapSave) forControlEvents:UIControlEventTouchUpInside];
  self.saveButton.translatesAutoresizingMaskIntoConstraints = false;
  
  [self.view addSubview:self.containerView];
  [self.containerView addSubview:self.titleLabel];
  [self.containerView addSubview:self.tableView];
  [self.containerView addSubview:self.quantityView];
  [self.view addSubview: self.saveButton];
  
  [self setButtonEnabled];
}

- (void)setupConstraints {
  self.containerViewBottom = [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
  [self.containerViewBottom setActive:true];
  [[self.containerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor] setActive:true];
  [[self.containerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor] setActive:true];
  [[self.containerView.heightAnchor constraintEqualToConstant:360] setActive:true];
  
  [[self.titleLabel.centerXAnchor constraintEqualToAnchor:self.containerView.centerXAnchor] setActive:true];
  [[self.titleLabel.topAnchor constraintEqualToAnchor:self.containerView.topAnchor constant:16] setActive:true];
  [[self.titleLabel.bottomAnchor constraintEqualToAnchor:self.tableView.topAnchor constant:-16] setActive:true];
  
  [[self.tableView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor] setActive:true];
  [[self.tableView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor] setActive:true];
  [[self.tableView.bottomAnchor constraintEqualToAnchor:self.quantityView.topAnchor constant:-16] setActive:true];
  
  [[self.quantityView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:16] setActive:true];
  [[self.quantityView.heightAnchor constraintEqualToConstant:40] setActive:true];
  [[self.quantityView.widthAnchor constraintEqualToConstant:120] setActive:true];
  [[self.quantityView.trailingAnchor constraintEqualToAnchor:self.saveButton.leadingAnchor constant:-16] setActive:true];
  [[self.quantityView.centerYAnchor constraintEqualToAnchor:self.saveButton.centerYAnchor] setActive:true];
  
  self.saveButtonBottom = [self.saveButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16];
  [[self.saveButton.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-16] setActive:true];
  [self.saveButtonBottom setActive:true];
  [[self.saveButton.heightAnchor constraintEqualToConstant:40] setActive:true];
}

// MARK: - UITableViewDelegate and UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  switch (indexPath.row) {
    case 0:
    {
      TextFieldCell *cell = [[TextFieldCell alloc] initWithTitle:@"Item name" andPlaceholder:@"Enter item name" andText:self.itemName andKeyboardType:UIKeyboardTypeDefault];
      cell.delegate = self;
      return cell;
    }
    case 1:
    {
      TextFieldCell *cell = [[TextFieldCell alloc] initWithTitle:@"Price" andPlaceholder:@"Enter price" andText:self.itemPrice andKeyboardType:UIKeyboardTypeDecimalPad];
      cell.delegate = self;
      return cell;
    }
    case 2:
    {
      TextFieldCell *cell = [[TextFieldCell alloc] initWithTitle:@"Tax" andPlaceholder:@"Enter tax" andText:self.itemTax andKeyboardType:UIKeyboardTypeDecimalPad];
      cell.delegate = self;
      return cell;
    }
    default:
    {
      UITableViewCell *cell = [[UITableViewCell alloc] init];
      return cell;
    }
  }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 3;
}

// MARK: - TextFieldCellDelegate
- (void)cell:(UITableViewCell *)cell textDidChange:(NSString *)text {
  NSInteger row = [self.tableView indexPathForCell:cell].row;
  switch (row) {
    case 0:
      self.itemName = text;
      break;
    case 1:
      self.itemPrice = text;
      break;
    case 2:
      self.itemTax = text;
      break;
    default:
      break;
  }
  
  [self setButtonEnabled];
}

@end
