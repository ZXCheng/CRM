//
//  HYExpenseCategoryModel.h
//  CRM
//
//  Created by 翰医 on 15/11/11.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYExpenseCategoryModel : NSObject

/**
 * ID	string	费用类型ID 主键
 */

@property (copy, nonatomic) NSString *ID;

/**
 * Title	string	费用类型标题
 */
@property (strong, nonatomic) NSString *Title;


@end
