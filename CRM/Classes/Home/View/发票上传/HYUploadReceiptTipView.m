//
//  HYUploadReceiptTipView.m
//  CRM
//
//  Created by 翰医 on 15/11/17.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYUploadReceiptTipView.h"

@interface HYUploadReceiptTipView ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *ensureButton;


- (IBAction)selectCancelButton:(UIButton *)sender;
- (IBAction)selectEnsureButton:(UIButton *)sender;

@end

@implementation HYUploadReceiptTipView

- (instancetype)init
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HYUploadReceiptTipView" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib
{
    self.middleView.layer.cornerRadius = 8;
    self.middleView.clipsToBounds = YES;
    
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
}

- (IBAction)selectCancelButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(uploadReceiptTipView:tapCancelButton:)]) {
        [self.delegate uploadReceiptTipView:self tapCancelButton:sender];
    }
}

- (IBAction)selectEnsureButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(uploadReceiptTipView:tapEnsureButton:)]) {
        [self.delegate uploadReceiptTipView:self tapEnsureButton:sender];
    }
}
@end
