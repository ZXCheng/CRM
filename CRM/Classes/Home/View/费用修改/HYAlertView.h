//
//  HYAlertView.h
//  CRM
//
//  Created by 萌面人 on 15/11/12.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYAlertView;

@protocol HYAlertViewDelegate <NSObject>

@optional

- (void)alertView:(HYAlertView *)alertView didSelectEnsureButton:(UIButton *)button andAlertViewTextFieldcontent:(NSString *)string;

@end

@interface HYAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) id<HYAlertViewDelegate> delegate;

@end
