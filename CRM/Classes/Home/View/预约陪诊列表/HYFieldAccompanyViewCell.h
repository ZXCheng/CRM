//
//  HYFieldAccompanyViewCell.h
//  CRM
//
//  Created by 萌面人 on 15/11/14.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYFiledAccompanyModel;
@interface HYFieldAccompanyViewCell : UITableViewCell

@property (strong, nonatomic) HYFiledAccompanyModel *fieldAccompanyModel;

/** cell实例：必须从xib创建 */
+(instancetype)cellFromTableView:(UITableView *)tableView;


@end
