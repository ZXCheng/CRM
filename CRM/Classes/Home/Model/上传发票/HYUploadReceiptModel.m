//
//  HYUploadReceiptModel.m
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYUploadReceiptModel.h"

@implementation HYUploadReceiptModel

- (void)setUploadDate:(NSTimeInterval)UploadDate
{
    _UploadDate = UploadDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.uploadDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:UploadDate]];
    
    NSDateFormatter *longdateFormatter = [[NSDateFormatter alloc] init];
    longdateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.uploadDateLongStr = [longdateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:UploadDate]];
}

@end
