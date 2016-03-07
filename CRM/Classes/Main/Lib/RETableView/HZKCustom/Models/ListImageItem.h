//
//  ListImageItem.h
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "RETableViewItem.h"

@interface ListImageItem : RETableViewItem

@property (copy, readwrite, nonatomic) NSString *imageName;

+ (ListImageItem *)itemWithImageNamed:(NSString *)imageName;

@end
