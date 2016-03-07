//
//  HYUploadReceiptViewController.h
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYUploadReceiptViewController : UICollectionViewController

@property (assign, nonatomic) int CostID;

- (void)loadReceipt;

@end
