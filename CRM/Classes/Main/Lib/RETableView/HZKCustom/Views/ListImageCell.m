//
//  ListImageCell.m
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "ListImageCell.h"

@interface ListImageCell ()

@property (strong, readwrite, nonatomic) UIImageView *pictureView;

@end

@implementation ListImageCell

/**
 *  重写父类方法自定义cell的高度
 */
+ (CGFloat) heightWithItem:(RETableViewItem *)item tableViewManager:(RETableViewManager *)tableViewManager
{
    return 306;
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0, 306, 306)];
    self.pictureView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:self.pictureView];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    [self.pictureView setImage:[UIImage imageNamed:self.item.imageName]];
}

- (void)cellDidDisappear
{
    [super cellDidDisappear];
}
@end
