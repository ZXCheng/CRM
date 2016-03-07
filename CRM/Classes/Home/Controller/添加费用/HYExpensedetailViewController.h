//
//  HYExpensedetailViewController.h
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYExpenseModel;

@interface HYExpensedetailViewController : UITableViewController

@property (strong, nonatomic) HYExpenseModel *expenseModel;

/**
 *  帐户ID  自增列	用户ID
 */
@property (assign, nonatomic) int ID;

@property (copy, nonatomic) NSString *CustomerName;

@property (strong, nonatomic) NSMutableArray *expenseCategoryArray;

@end
