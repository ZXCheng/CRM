//
//  HYPickerView.h
//  CRM
//
//  Created by 翰医 on 15/11/12.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYPickerView;

@protocol HYPickerViewDelegate <NSObject>

@required

- (void)pickerView:(HYPickerView *)pickerView didSelectWanchengButton:(UIButton *)button;

@end

@interface HYPickerView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) id<HYPickerViewDelegate> hydelegate;

@end
