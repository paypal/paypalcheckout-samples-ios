//
//  CheckoutViewController.m
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import <Foundation/Foundation.h>
#import "CheckoutViewController.h"
#import "AddItemViewController.h"
#import "AddItemCell.h"
#import "ItemCell.h"
#import "TotalCell.h"
#import "FetchAccessTokenEndpoint.h"
#import "CreateOrderEndpoint.h"
#import "AccessTokenResponse.h"
#import "CreateOrderResponse.h"
#import "PayPalAPI.h"
@import PayPalCheckout;

@interface CheckoutViewController ()
@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIButton *checkoutButton;
@property (nonatomic) NSMutableArray<PPCPurchaseUnitItem *> *items;
@end

@implementation CheckoutViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupSampleItem];
  [self setupUI];
  [self setupTableView];
  [self setupConstraints];
  [self setupPayPalCheckoutCallbacks];
}

- (void)setupPayPalCheckoutCallbacks {
  [PPCheckout setOnApproveCallback:^(PPCApproval *approval) {
    if ([approval.data.intent isEqualToString:@"AUTHORIZE"]) {
      [approval.actions authorizeOnComplete:^(PPCAuthorizeActionSuccess *success, NSError *error) {
        if (error) {
          NSLog(@"Fail to authorize order with error %@", error.localizedDescription);
        } else if (success) {
          NSLog(@"Authorize order successfully");
        } else {
          NSLog(@"Authorize order: No error and no success response");
        }
      }];
    } else if ([approval.data.intent isEqualToString:@"CAPTURE"] || [approval.data.intent isEqualToString:@"SALE"]) {
      [approval.actions captureOnComplete:^(PPCCaptureActionSuccess *success, NSError *error) {
        if (error) {
          NSLog(@"Fail to capture order with error %@", error.localizedDescription);
        } else if (success) {
          NSLog(@"Capture order successfully");
        } else {
          NSLog(@"Capture order: No error and no success response");
        }
      }];
    }
  }];
  
  [PPCheckout setOnCancelCallback:^{
    NSLog(@"Checkout cancelled");
  }];
  
  [PPCheckout setOnErrorCallback:^(PPCErrorInfo *errorInfo) {
    NSLog(@"Checkout failed with error: %@", errorInfo.error.localizedDescription);
  }];
}

- (void)tapCheckout {
  if (self.items.count == 0) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Can't checkout"
                                                                   message:@"Please add at least 1 item"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *_){}];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:^{}];
    return;
  }

  [self startCheckout];
}

- (void)startCheckout {
  PPCOrderRequest *order = [self getOrder];
  
  switch (self.segmentedControl.selectedSegmentIndex) {
    case 0: {
      // Checkout with order
      [PPCheckout startWithExperience:PPCExperienceNative
             presentingViewController:self
                          createOrder:^(PPCCreateOrderAction *action) {
        [action createWithOrder:order completion:^(NSString *orderId) {
          NSLog(@"Order created with orderId: %@", orderId);
        }];
      }
                            onApprove:nil onCancel:nil onError:nil];
      break;
    }
    case 1: {
      // Request an ECToken/orderID/payToken with PayPal Orders API, then checkout with ECToken/orderID/payToken
      [PPCheckout startWithExperience:PPCExperienceNative
             presentingViewController:self
                          createOrder:^(PPCCreateOrderAction *action) {
        NSString *clientId = [PayPalAPI.shared clientId];
        FetchAccessTokenRequest *tokenRequest = [[FetchAccessTokenRequest alloc] initWith:clientId];
        [PayPalAPI.shared fetchAccessToken:tokenRequest completion:^(NSData *data, NSError *error) {
          if (data == nil) {
            NSLog(@"Fetch access token failed with no data.");
            return;
          }
          
          AccessTokenResponse *tokenResponse = [[AccessTokenResponse alloc] initWithData:data];
          CreateOrderRequest *createOrderRequest = [[CreateOrderRequest alloc] initWithOrder:order andAccessToken:tokenResponse.accessToken];
          
          [PayPalAPI.shared createOrder:createOrderRequest completion:^(NSData *data, NSError *error) {
            if (data == nil) {
              NSLog(@"Create order failed with no data.");
              return;
            }
            
            CreateOrderResponse *orderResponse = [[CreateOrderResponse alloc] initWithData:data];
            [action setWithOrderId:orderResponse.orderId];
          }];
        }];
      }
                            onApprove:nil onCancel:nil onError:nil];
      break;
    }
    default:
      break;
  }
}

- (PPCOrderRequest*)getOrder {
  NSString *total = [self getTotal];
  NSString *itemTotal = [self getItemTotal];
  NSString *taxTotal = [self getTaxTotal];
  PPCPurchaseUnit *purchaseUnit = [[PPCPurchaseUnit alloc] initWithAmount:[[PPCPurchaseUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd
                                                                                                                        value:total
                                                                                                                    breakdown:[[PPCPurchaseUnitBreakdown alloc] initWithItemTotal:[[PPCUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd
                                                                                                                                                                                                                        value:itemTotal]
                                                                                                                                                                         shipping:nil
                                                                                                                                                                         handling:nil
                                                                                                                                                                         taxTotal:[[PPCUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd
                                                                                                                                                                                                                        value:taxTotal]
                                                                                                                                                                        insurance:nil
                                                                                                                                                                 shippingDiscount:nil
                                                                                                                                                                         discount:nil]]
                                                              referenceId:nil
                                                                    payee:nil
                                                       paymentInstruction:nil
                                                  purchaseUnitDescription:nil
                                                                 customId:nil
                                                                invoiceId:nil
                                                           softDescriptor:nil
                                                                    items:self.items
                                                                 shipping:nil];
  NSArray<PPCPurchaseUnit *> *purchaseUnits = @[purchaseUnit];
  PPCOrderRequest *order = [[PPCOrderRequest alloc] initWithIntent:PPCOrderIntentAuthorize
                                                     purchaseUnits:purchaseUnits
                                                             payer:nil
                                                applicationContext:nil];
  return order;
}

- (void)setupTableView {
  [self.tableView registerClass:[AddItemCell class] forCellReuseIdentifier:@"AddItemCell"];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

- (void)setupSampleItem {
  PPCPurchaseUnitItem *item = [[PPCPurchaseUnitItem alloc] initWithName:@"Sample item"
                                                             unitAmount:[[PPCUnitAmount alloc] initWithCurrencyCode:PPCCurrencyCodeUsd value:@"5.99"]
                                                               quantity:@"1"
                                                                    tax:[[PPCPurchaseUnitTax alloc] initWithCurrencyCode:PPCCurrencyCodeUsd value:@"0.59"]
                                                        itemDescription:nil
                                                                    sku:nil
                                                               category:PPCPurchaseUnitCategoryPhysicalGoods];
  self.items = [[NSMutableArray alloc] init];
  [self.items addObject:item];
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor whiteColor];
  
  NSArray *options = @[@"Order", @"ECToken"];
  self.segmentedControl = [[UISegmentedControl alloc] initWithItems:options];
  [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
  self.segmentedControl.selectedSegmentIndex = 0;
  self.segmentedControl.translatesAutoresizingMaskIntoConstraints = false;
  
  self.tableView = [[UITableView alloc] init];
  self.tableView.translatesAutoresizingMaskIntoConstraints = false;
  
  self.checkoutButton = [[UIButton alloc] init];
  self.checkoutButton.layer.cornerRadius = 8;
  self.checkoutButton.backgroundColor = [UIColor systemBlueColor];
  self.checkoutButton.tintColor = [UIColor whiteColor];
  [self.checkoutButton setTitle:@"Checkout with order" forState:UIControlStateNormal];
  [self.checkoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
  [self.checkoutButton addTarget:self action:@selector(tapCheckout) forControlEvents:UIControlEventTouchUpInside];
  self.checkoutButton.translatesAutoresizingMaskIntoConstraints = false;
    
  [self.view addSubview:self.segmentedControl];
  [self.view addSubview:self.tableView];
  [self.view addSubview: self.checkoutButton];
  
}

- (void)setupConstraints {
  [[self.segmentedControl.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:16] setActive:true];
  [[self.segmentedControl.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16] setActive:true];
  [[self.segmentedControl.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16] setActive:true];
  [[self.segmentedControl.heightAnchor constraintEqualToConstant:32] setActive:true];
  [[self.segmentedControl.bottomAnchor constraintEqualToAnchor:self.tableView.topAnchor constant:-24] setActive:true];
  
  [[self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:true];
  [[self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:true];
  [[self.tableView.bottomAnchor constraintEqualToAnchor:self.checkoutButton.topAnchor constant:16] setActive:true];
  
  [[self.checkoutButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16] setActive:true];
  [[self.checkoutButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16] setActive:true];
  [[self.checkoutButton.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-16] setActive:true];
  [[self.checkoutButton.heightAnchor constraintEqualToConstant:40] setActive:true];
}

- (void)segmentChanged:(UISegmentedControl *)segment {
  switch (segment.selectedSegmentIndex) {
    case 0:
      self.checkoutButton.hidden = false;
      [self.checkoutButton setTitle:@"Checkout with order" forState:UIControlStateNormal];
      break;
    case 1:
      self.checkoutButton.hidden = false;
      [self.checkoutButton setTitle:@"Checkout with ECToken" forState:UIControlStateNormal];
      break;
    case 2:
      self.checkoutButton.hidden = true;
      break;
    default:
      break;
  }
}

- (NSString *)getTotal {
  double total = 0;
  for (PPCPurchaseUnitItem* item in self.items) {
    double price = [item.unitAmount.value doubleValue];
    double tax = [item.tax.value doubleValue];
    double quantity = [item.quantity doubleValue];
    total += (price + tax) * quantity;
  }
  return [[NSNumber numberWithDouble:total] stringValue];
}

- (NSString *)getItemTotal {
  double total = 0;
  for (PPCPurchaseUnitItem* item in self.items) {
    double price = [item.unitAmount.value doubleValue];
    double quantity = [item.quantity doubleValue];
    total += price * quantity;
  }
  return [[NSNumber numberWithDouble:total] stringValue];
}

- (NSString *)getTaxTotal {
  double total = 0;
  for (PPCPurchaseUnitItem* item in self.items) {
    double tax = [item.tax.value doubleValue];
    double quantity = [item.quantity doubleValue];
    total += tax * quantity;
  }
  return [[NSNumber numberWithDouble:total] stringValue];
}

// MARK: - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return @"Items";
    case 1:
      return @"Cart total";
    default:
      return @"";
  }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row >= self.items.count) {
      AddItemCell *cell = [[AddItemCell alloc] init];
      return cell;
    } else {
      ItemCell *cell = [[ItemCell alloc] initWithItem:self.items[indexPath.row] andQuantity:self.items[indexPath.row].quantity];
      return cell;
    }
  } else {
    TotalCell *cell = [[TotalCell alloc] initWithTotal:[self getTotal] subtotal:[self getItemTotal] tax:[self getTaxTotal]];
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row >= self.items.count) {
      return 48;
    }
    return UITableViewAutomaticDimension;
  } else {
    return UITableViewAutomaticDimension;
  }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.items.count + 1;
  } else {
    return 1;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row >= self.items.count) {
      AddItemViewController *vc = [[AddItemViewController alloc] init];
      vc.delegate = self;
      vc.index = indexPath.row;
      [self presentViewController:vc animated:true completion:^{}];
    } else {
      AddItemViewController *vc = [[AddItemViewController alloc] initWithItem:self.items[indexPath.row]];
      vc.delegate = self;
      vc.index = indexPath.row;
      [self presentViewController:vc animated:true completion:^{}];
    }
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && indexPath.row < self.items.count) {
    return true;
  }
  return false;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.items removeObjectAtIndex:indexPath.row];
    [tableView performBatchUpdates:^{
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } completion:^(BOOL _) {
      [tableView reloadData];
    }];
  }
}

// MARK: - AddItemViewControllerDelegate
- (void)didTapSaveWithItem:(PPCPurchaseUnitItem *)item at:(NSInteger)index {
  if (index < self.items.count) {
    self.items[index] = item;
  } else {
    [self.items addObject:item];
  }
  [self.tableView reloadData];
}

@end
