//
//  HYUploadReceiptViewCell.h
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYUploadReceiptModel, HYUploadReceiptViewCell;

@protocol HYUploadReceiptViewCellDelegate <NSObject>

@optional

- (void)uploadReceiptViewCell:(HYUploadReceiptViewCell *)uploadReceiptViewCell didSelectDeleteReceipt:(UIButton *)button;

@end


@interface HYUploadReceiptViewCell : UICollectionViewCell

@property (strong, nonatomic) HYUploadReceiptModel *uploadReceiptModel;

@property (weak, nonatomic)id<HYUploadReceiptViewCellDelegate> delegate;

@end
