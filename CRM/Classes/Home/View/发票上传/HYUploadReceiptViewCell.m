//
//  HYUploadReceiptViewCell.m
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYUploadReceiptViewCell.h"
#import "HYUploadReceiptModel.h"
#import "UIImageView+WebCache.h"

@interface HYUploadReceiptViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *receiptView;
@property (weak, nonatomic) IBOutlet UILabel *uploadDateView;
@property (weak, nonatomic) IBOutlet UILabel *memoview;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *coverView;
- (IBAction)deleteReceipt:(UIButton *)sender;

@end

@implementation HYUploadReceiptViewCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    self.receiptView.layer.cornerRadius = 6;
    self.receiptView.clipsToBounds = YES;
}

- (void)setUploadReceiptModel:(HYUploadReceiptModel *)uploadReceiptModel
{
    _uploadReceiptModel = uploadReceiptModel;
    [self.receiptView sd_setImageWithURL:[NSURL URLWithString:uploadReceiptModel.ThumImageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    self.uploadDateView.text = [NSString stringWithFormat:@"上传日期：%@",uploadReceiptModel.uploadDateStr];
    
    if (uploadReceiptModel.Memo == nil)
    {
        self.memoview.text = @"备注：无";
    }
    else
    {
        self.memoview.text = [NSString stringWithFormat:@"备注：%@",uploadReceiptModel.Memo];
    }
        
    self.coverView.hidden = !uploadReceiptModel.isCover;
    self.deleteButton.hidden = !uploadReceiptModel.isCover;
}


- (IBAction)deleteReceipt:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(uploadReceiptViewCell:didSelectDeleteReceipt:)]) {
        [self.delegate uploadReceiptViewCell:self didSelectDeleteReceipt:sender];
    }

}

@end
