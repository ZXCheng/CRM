//
//  MultilineTextCell.m
//  自学RETableViewManager
//
//  Created by han on 15/8/12.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "MultilineTextCell.h"
static const CGFloat kHorizontalMargin = 10.0;
static const CGFloat kVerticalMargin = 10.0;

@interface MultilineTextCell ()

@property (strong, readwrite, nonatomic) UILabel *multilineLabel;

@end

@implementation MultilineTextCell

/**
 *  重写父类方法自定义cell的高度
 */
+ (CGFloat)heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    CGFloat horizontalMargion = kHorizontalMargin;
    if (item.section.style.contentViewMargin <= 0)
        horizontalMargion += 5.0;
    
    CGFloat width = CGRectGetWidth(tableViewManager.tableView.bounds) - 2.0 * horizontalMargion;
    
    return [item.title re_sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(width, INFINITY)].height + 2.0 * kVerticalMargin;
        
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    self.multilineLabel = [[UILabel alloc] init];
    self.multilineLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.multilineLabel.font = [UIFont systemFontOfSize:17];
    self.multilineLabel.numberOfLines = 0;
    self.multilineLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.multilineLabel];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text = @"";
    self.multilineLabel.text = self.item.title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat horizontalMargin = kHorizontalMargin;
    if (self.section.style.contentViewMargin <= 0)
        horizontalMargin += 5.0;
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), [MultilineTextCell heightWithItem:self.item tableViewManager:self.tableViewManager]);
    
    frame = CGRectInset(frame, horizontalMargin, kVerticalMargin);
    
    self.multilineLabel.frame = frame;
        
}

@end
