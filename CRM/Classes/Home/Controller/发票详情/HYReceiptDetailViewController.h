//
//  HYReceiptDetailViewController.h
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYUploadReceiptModel;
@interface HYReceiptDetailViewController : UIViewController

@property (assign, nonatomic) int CostID;
@property (nonatomic, strong) HYUploadReceiptModel *uploadReceiptModel;

@end
