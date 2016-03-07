//
//  HYExpenseListViewController.h
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYExpenseListViewController : UITableViewController
/**
 *  帐户ID  自增列	用户ID
 */
@property (assign, nonatomic) int ID;
/**
 *  CustomerName	string	客户名称
 */
//@property (copy, nonatomic) NSString *CustomerName;

- (void)refreshInformation;
@end
