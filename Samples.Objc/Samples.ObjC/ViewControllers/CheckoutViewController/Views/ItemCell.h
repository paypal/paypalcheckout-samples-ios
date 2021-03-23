//
//  ItemCell.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import <UIKit/UIKit.h>
@import PayPalCheckout;

NS_ASSUME_NONNULL_BEGIN

@interface ItemCell : UITableViewCell

- (instancetype)initWithItem:(PPCPurchaseUnitItem *)item andQuantity:(NSString *)quantity;

@end

NS_ASSUME_NONNULL_END
