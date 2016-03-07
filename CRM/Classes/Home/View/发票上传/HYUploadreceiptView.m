//
//  HYUploadreceiptView.m
//  CRM
//
//  Created by 萌面人 on 15/11/12.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYUploadreceiptView.h"

@implementation HYUploadreceiptView

- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    NSInteger colPerRow = 2;
    CGFloat margin = 10;
    CGFloat imageViewW = ([UIScreen mainScreen].bounds.size.width - (colPerRow + 1) * margin) / colPerRow;
    CGFloat imageViewH = imageViewW;
    for (int index = 0; index < count; index++) {
        UIImageView *imageView = self.subviews[index];
        NSInteger row = index / colPerRow;
        NSInteger col = index % colPerRow;
        CGFloat imageViewX = margin + col * (imageViewW + margin);
        CGFloat imageViewY = margin + row * (imageViewH + margin);
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
}

- (NSArray *)images
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIImageView *imageView in self.subviews)
    {
        [array addObject:imageView.image];
    }
    return array;
}


@end
