//
//  MultilineTextCell.h
//  自学RETableViewManager
//
//  Created by han on 15/8/12.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "RETableViewCell.h"
#import "MultilineTextItem.h"
#import "RETableViewManager.h"
//一个UILabel多行展示
@interface MultilineTextCell : RETableViewCell
/**
 *  属性名字只能叫item
 */
@property (strong, readwrite, nonatomic) MultilineTextItem *item;
@property (strong, readonly, nonatomic) UILabel *multilineLabel;
@end
