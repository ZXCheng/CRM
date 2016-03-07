//
//  HYHomeViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/6.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYHomeViewController.h"
#import "HYFieldAccompanyViewController.h"
#import "HYLoginViewController.h"

@interface HYHomeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *accompanyView;


@end

@implementation HYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitNav)];
    
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.height);
    self.scrollView.alwaysBounceVertical = YES;
    
    UITapGestureRecognizer *tapCloudCare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAccompany)];
    tapCloudCare.numberOfTapsRequired= 1;
    [self.accompanyView addGestureRecognizer:tapCloudCare];
}

- (void)exitNav
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:@(NO) forKey:@"txtUserAutoKey"];
    [defaults setObject:@(NO) forKey:@"txtUserRememberKey"];
    [defaults setObject:@"" forKey:@"txtUserPasswordKey"];
    
    HYLoginViewController *loginVC = [[HYLoginViewController alloc] init];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
}

- (void)TapAccompany
{
    HYFieldAccompanyViewController *fieldAccompanyVC = [[HYFieldAccompanyViewController alloc] init];
    [self.navigationController pushViewController:fieldAccompanyVC animated:YES];
}

@end
