//
//  AddItemViewController.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//  Copyright © 2020 PayPal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldCell.h"
@import PayPalCheckout;

NS_ASSUME_NONNULL_BEGIN

@protocol AddItemViewControllerDelegate <NSObject>
- (void)didTapSaveWithItem:(PPCPurchaseUnitItem *)item at:(NSInteger)index;
@end

@interface AddItemViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, TextFieldCellDelegate>
@property (nonatomic, weak) id<AddItemViewControllerDelegate> delegate;
@property (nonatomic) NSInteger index;
-(instancetype)initWithItem:(PPCPurchaseUnitItem *)item;
@end

NS_ASSUME_NONNULL_END
