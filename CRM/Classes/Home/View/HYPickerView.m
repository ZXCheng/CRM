//
//  HYPickerView.m
//  CRM
//
//  Created by 翰医 on 15/11/12.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYPickerView.h"

@interface HYPickerView ()
- (IBAction)success:(UIButton *)sender;

@end

@implementation HYPickerView

- (instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HYPickerView" owner:nil options:nil] lastObject];
}


- (IBAction)success:(UIButton *)sender {
    
    if ([self.hydelegate respondsToSelector:@selector(pickerView:didSelectWanchengButton:)]) {
        [self.hydelegate pickerView:self didSelectWanchengButton:sender];
    }
}
@end
