//
//  NSString+HZKExtend.m
//  NewBasicFrameWork
//
//  Created by han on 15/9/5.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "NSString+HZKExtend.h"




@implementation NSString (HZKExtend)
/**
 *  将自己翻转输出
 *
 *  @return 翻转后的String
 */
- (NSString *)overturnString
{
    NSMutableString *muStr = [NSMutableString string];
    
    for (int i = 0; i < self.length; i++)
    {
        NSString *a = [NSString stringWithFormat:@"%c",[self characterAtIndex:self.length - i - 1]];
        [muStr appendString:a];
    }
    return muStr;
}

- (NSString *)decodeString
{
    NSMutableString *muStr = [NSMutableString string];
    NSArray *alphabetArr = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J"];
    
    for (int i = 0; i < self.length; i++)
    {
        NSString *a = [NSString stringWithFormat:@"%c",[self characterAtIndex:self.length - i - 1]];
        for (int j = 0; j < alphabetArr.count; j++)
        {
            if ([a isEqualToString:alphabetArr[j]])
            {
                [muStr appendString:[NSString stringWithFormat:@"%d", j]];
                break;
            }
        }
    }
    return muStr;

}


@end
