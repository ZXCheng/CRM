//
//  ListHeaderView.m
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "ListHeaderView.h"

@interface ListHeaderView ()

@property (strong, readwrite, nonatomic) UIImageView *userpicImageView;
@property (strong, readwrite, nonatomic) UILabel *usernameLabel;

@end

@implementation ListHeaderView

+ (ListHeaderView *)headerViewWithImageNamed:(NSString *)imageName username:(NSString *)username
{
    ListHeaderView *view = [[ListHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [view.userpicImageView setImage:[UIImage imageNamed:imageName]];
    [view.usernameLabel setText:username];
    
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.alpha = 0.9;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView];
        
        self.userpicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
        [self addSubview:self.userpicImageView];
        
        
        self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 3, 276, 35)];
        self.usernameLabel.font = [UIFont boldSystemFontOfSize:14];
        self.usernameLabel.textColor = [UIColor blackColor];
        self.usernameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.usernameLabel];
    }
    return self;
}
@end
