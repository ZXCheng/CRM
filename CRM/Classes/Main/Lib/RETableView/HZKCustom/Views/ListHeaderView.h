//
//  ListHeaderView.h
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListHeaderView : UIView

@property (strong, readonly, nonatomic) UIImageView *userpicImageView;
@property (strong, readonly, nonatomic) UILabel *usernameLabel;

+ (ListHeaderView *)headerViewWithImageNamed:(NSString *)imageName username:(NSString *)username;


@end
