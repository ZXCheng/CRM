//
//  HYExpenseListTableViewCell.h
//  CRM
//
//  Created by 萌面人 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYExpenseModel;

@interface HYExpenseListTableViewCell : UITableViewCell

@property (strong, nonatomic) HYExpenseModel *expenseModel;

/** cell实例：必须从xib创建 */
+(instancetype)cellFromTableView:(UITableView *)tableView;

@end
