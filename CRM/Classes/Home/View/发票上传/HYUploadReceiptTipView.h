//
//  HYUploadReceiptTipView.h
//  CRM
//
//  Created by 翰医 on 15/11/17.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYUploadReceiptTipView;

@protocol HYUploadReceiptTipViewDelegate <NSObject>

@optional

- (void)uploadReceiptTipView:(HYUploadReceiptTipView *)uploadReceiptTipView tapCancelButton:(UIButton *)button;
- (void)uploadReceiptTipView:(HYUploadReceiptTipView *)uploadReceiptTipView tapEnsureButton:(UIButton *)button;

@end

@interface HYUploadReceiptTipView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *memoTextField;
@property (weak, nonatomic) IBOutlet UIView *middleView;

@property (weak, nonatomic) id <HYUploadReceiptTipViewDelegate> delegate;

@end
