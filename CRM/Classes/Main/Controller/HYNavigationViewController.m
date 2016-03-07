//
//  HYNavigationViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/6.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYNavigationViewController.h"

@interface HYNavigationViewController ()

@end

@implementation HYNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
}


@end
