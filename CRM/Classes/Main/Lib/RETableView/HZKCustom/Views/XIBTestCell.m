//
//  XIBTestCell.m
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "XIBTestCell.h"

@implementation XIBTestCell

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.textLabel.text = @"";
    self.testLabel.text = self.item.title;
}
@end
