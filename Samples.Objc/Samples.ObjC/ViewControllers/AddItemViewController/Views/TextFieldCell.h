//
//  TextFieldCell.h
//  PayPalNativeCheckoutObjC
//
//  Created by Nguyen, The Nhat Minh on 3/9/21.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol TextFieldCellDelegate <NSObject>
- (void)cell:(UITableViewCell *)cell textFieldDidEndEditing:(NSString *)text;
@end

@interface TextFieldCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, weak) id<TextFieldCellDelegate> delegate;
- (instancetype)initWithTitle:(NSString *)title andPlaceholder:(NSString *)placeHolder andText:(NSString *)text andKeyboardType:(UIKeyboardType)type;
@end

NS_ASSUME_NONNULL_END
