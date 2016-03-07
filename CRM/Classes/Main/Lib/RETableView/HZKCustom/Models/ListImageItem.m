//
//  ListImageItem.m
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "ListImageItem.h"

@implementation ListImageItem

+ (ListImageItem *)itemWithImageNamed:(NSString *)imageName
{
    ListImageItem *item = [[ListImageItem alloc] init];
    item.imageName = imageName;
    return item;
}

@end
