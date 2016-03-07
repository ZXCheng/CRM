//
//  HYAlertView.m
//  CRM
//
//  Created by 萌面人 on 15/11/12.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYAlertView.h"

@interface HYAlertView ()

- (IBAction)cancel;
- (IBAction)ensure:(UIButton *)sender;


@end

@implementation HYAlertView

- (instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HYAlertView" owner:nil options:nil] lastObject];
}

- (IBAction)cancel {
    
    self.hidden = YES;
}

- (IBAction)ensure:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(alertView:didSelectEnsureButton:andAlertViewTextFieldcontent:)]) {
        [self.delegate alertView:self didSelectEnsureButton:sender andAlertViewTextFieldcontent:self.textField.text];
    }
}


@end
