//
//  HYExpenseEditViewController.h
//  CRM
//
//  Created by 翰医 on 15/11/11.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYExpenseModel;

@interface HYExpenseEditViewController : UITableViewController

@property (strong, nonatomic) HYExpenseModel *expenseModel;

@property (strong, nonatomic) NSMutableArray *expenseCategoryArray;

@end
