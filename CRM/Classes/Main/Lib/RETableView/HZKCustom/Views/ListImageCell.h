//
//  ListImageCell.h
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "RETableViewCell.h"
#import "ListImageItem.h"

@interface ListImageCell : RETableViewCell

@property (strong, readonly, nonatomic) UIImageView *pictureView;

/**
 *  属性名字只能叫item
 */
@property (strong, readwrite, nonatomic) ListImageItem *item;

@end
