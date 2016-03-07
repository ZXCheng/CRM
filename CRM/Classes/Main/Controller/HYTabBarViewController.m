//
//  HYTabBarViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/6.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYTabBarViewController.h"
#import "HYHomeViewController.h"
#import "HYAboutViewController.h"
#import "HYProfileViewController.h"
#import "HYNavigationViewController.h"


@interface HYTabBarViewController ()

@property (weak, nonatomic) HYHomeViewController *homeVC;
@property (weak, nonatomic) HYProfileViewController *profileVC;
@property (weak, nonatomic) HYAboutViewController *aboutVC;

@end

@implementation HYTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //添加所有的自控制器
    [self addAllChildVcs];
    
}


#pragma mark- 添加所有的自控制器
- (void)addAllChildVcs
{
    HYHomeViewController *home = [[HYHomeViewController alloc] init];
    [self addOneChildVc:home title:@"首页" imageName:@"home_nor" selectedImageName:@"home_sel"];
    self.homeVC = home;
    
    HYAboutViewController *about = [[HYAboutViewController alloc] init];
    [self addOneChildVc:about title:@"资讯" imageName:@"about_nor" selectedImageName:@"about_sel"];
    self.aboutVC = about;
    
    HYProfileViewController *profile = [[HYProfileViewController alloc] init];
    [self addOneChildVc:profile title:@"我的" imageName:@"pro_nor" selectedImageName:@"pro_sel"];
    self.profileVC = profile;
    
}
/**
 *  添加一个子控制器
 *
 *  @param childVC           子控制对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    childVc.title = title;
    
    //设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    
    //设置选中时的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    
    //设置tabBarItem普通状态下文字的颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置tabBarItem选中状态下文字的颜色
    NSMutableDictionary *selectedtextAttrs = [NSMutableDictionary dictionary];
    selectedtextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    selectedtextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    [childVc.tabBarItem setTitleTextAttributes:selectedtextAttrs forState:UIControlStateSelected];
    
    
    if (([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0))
    {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    childVc.tabBarItem.selectedImage = selectedImage;
    
    //添加为tabbar控制器的子控制器
    HYNavigationViewController *navc = [[HYNavigationViewController alloc] initWithRootViewController:childVc];
    
    /**
     *  如果导航栏上没有添加图片，则：
     //当导航栏的translucent属性设置为YES,则在当前视图控制器的坐标原点为屏幕左上角
     //当导航栏的translucent属性设置为NO,则在当前视图控制器的坐标原点在屏幕左上角（往Y轴方向距离导航栏的高度（44））
     如果导航栏上有添加图片，则以下属性可以不设
     */
    navc.navigationBar.translucent = NO;
    [self addChildViewController:navc];
    
}


#pragma mark- 调整tabbar
- (void)addCustomTabBar
{
    //TabBar *customTabBar = [[TabBar alloc] init];
    // 更换系统自带的tabbar
    //[self setValue:customTabBar forKey:@"tabBar"];
}
//设置状态栏风格
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
