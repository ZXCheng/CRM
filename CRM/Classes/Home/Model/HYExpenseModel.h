//
//  HYExpenseModel.h
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYExpenseModel : NSObject

/**
 *  CostID	int	费用ID  主键
 */
@property (assign, nonatomic) int CostID;
/**
 *  CostType	string	费用类型
 */
@property (copy, nonatomic) NSString *CostType;
/**
 *  Money	decimal	金额
 */
@property (assign, nonatomic) double Money;
/**
 *  ApplyTime	datetime	时间
 */
@property (assign, nonatomic) NSTimeInterval ApplyTime;
@property (copy, nonatomic) NSString *applyTimeStr;
/**
 *  CostGeneration	string	费用产生人
 */
@property (copy, nonatomic) NSString *CostGenerationName;
/**
 *  Memo	string	备注
 */
@property (copy, nonatomic) NSString *Memo;

/**
 *  IsEdit	int	是否可以修改
 */
@property (assign, nonatomic) int IsEdit;

@end
