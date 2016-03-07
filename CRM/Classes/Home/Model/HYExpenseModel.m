//
//  HYExpenseModel.m
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYExpenseModel.h"

@implementation HYExpenseModel

- (void)setApplyTime:(NSTimeInterval)ApplyTime
{
    _ApplyTime = ApplyTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    self.applyTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ApplyTime]];
}

@end

