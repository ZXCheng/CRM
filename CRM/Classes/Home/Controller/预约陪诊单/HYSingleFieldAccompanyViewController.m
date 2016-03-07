//
//  HYSingleFieldAccompanyViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYSingleFieldAccompanyViewController.h"
#import "RETableViewManager.h"
#import "HYExpenseListViewController.h"
#import "HYFiledAccompanyModel.h"
#import "AFNetworking.h"
#import "HYHeader.h"
#import "HYUserModel.h"
#import <CoreLocation/CoreLocation.h>
#import "HYFieldAccompanyViewController.h"


@interface HYSingleFieldAccompanyViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewItem *itemScore;

@property (weak, nonatomic) UIButton *lineButton;
@property (weak, nonatomic) UIButton *takeButton;
@property (weak, nonatomic) UIButton *giveButton;

@property (nonatomic, strong) CLLocationManager *locManager;
//@property (nonatomic, strong) CLLocation *curLocation;

@property (nonatomic, strong) NSMutableArray *locationArray;

@end

@implementation HYSingleFieldAccompanyViewController

- (void)back
{
//    HYFieldAccompanyViewController *fieldAccompanyVC = [[HYFieldAccompanyViewController alloc] init];
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToViewController:fieldAccompanyVC animated:YES];
    
    for (UIViewController *fieldAccompanyVC in self.navigationController.viewControllers) {
        if ([fieldAccompanyVC isKindOfClass:[HYFieldAccompanyViewController class]]) {
            HYFieldAccompanyViewController *fieldVC = (HYFieldAccompanyViewController *)fieldAccompanyVC;
            [self.navigationController popToViewController:fieldAccompanyVC animated:YES];
            [fieldVC refreshInformationHeader];
            
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"预约陪诊单";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self locationCurrentPlace];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
    //添加组
    RETableViewSection *section01 = [RETableViewSection section];
    [self.manager addSection:section01];
    
    //添加items
    RETableViewItem *item01 = [RETableViewItem itemWithTitle:@"订单编号" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item01.selectionStyle = UITableViewCellSelectionStyleNone;
    item01.style = UITableViewCellStyleValue1;
    item01.detailLabelText = self.filedAccompanyModel.OrderID;
    
    RETableViewItem *item02 = [RETableViewItem itemWithTitle:@"客户姓名" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item02.selectionStyle = UITableViewCellSelectionStyleNone;
    item02.style = UITableViewCellStyleValue1;
    item02.detailLabelText = self.filedAccompanyModel.CustomerName;
    
    RETableViewItem *item03 = [RETableViewItem itemWithTitle:@"客户手机" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item03.selectionStyle = UITableViewCellSelectionStyleNone;
    item03.style = UITableViewCellStyleValue1;
    item03.detailLabelText = self.filedAccompanyModel.Tel;
    
    RETableViewItem *item04 = [RETableViewItem itemWithTitle:@"预约时间" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item04.selectionStyle = UITableViewCellSelectionStyleNone;
    item04.style = UITableViewCellStyleValue1;
    item04.detailLabelText = self.filedAccompanyModel.appointmentDateStr;
    
    RETableViewItem *item05 = [RETableViewItem itemWithTitle:@"医院" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item05.selectionStyle = UITableViewCellSelectionStyleNone;
    item05.style = UITableViewCellStyleValue1;
    item05.detailLabelText = self.filedAccompanyModel.Hospital;
    
    RETableViewItem *item06 = [RETableViewItem itemWithTitle:@"科室" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item06.selectionStyle = UITableViewCellSelectionStyleNone;
    item06.style = UITableViewCellStyleValue1;
    item06.detailLabelText = self.filedAccompanyModel.Department;
    
    RETableViewItem *item07 = [RETableViewItem itemWithTitle:@"医生" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item07.selectionStyle = UITableViewCellSelectionStyleNone;
    item07.style = UITableViewCellStyleValue1;
    item07.detailLabelText = self.filedAccompanyModel.Doctor;
    
    RETableViewItem *item08 = [RETableViewItem itemWithTitle:@"排队" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        
    }];
    item08.selectionStyle = UITableViewCellSelectionStyleNone;
    item08.style = UITableViewCellStyleValue1;
    
    UIButton *lineButton = [[UIButton alloc] init];
    lineButton.layer.cornerRadius = 6;
    lineButton.clipsToBounds = YES;
    [lineButton setTitle:@"签到" forState:UIControlStateNormal];
    [lineButton setTitle:@"已签" forState:UIControlStateSelected];
    lineButton.frame = CGRectMake(0, 0, 60, 30);
    //若排队时间不为空,则禁止排队签到
    if (self.filedAccompanyModel.queuingTimeStr.length > 0) {
        lineButton.selected = YES;
//        lineButton.enabled = NO;
        lineButton.userInteractionEnabled = NO;
        lineButton.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        lineButton.selected = NO;
//        lineButton.enabled = YES;
        lineButton.userInteractionEnabled = YES;
        lineButton.backgroundColor = [UIColor blueColor];
    }

    [lineButton addTarget:self action:@selector(clickLineButton:) forControlEvents:UIControlEventTouchUpInside];
    item08.accessoryView = lineButton;
    self.lineButton = lineButton;
    
    RETableViewItem *item09 = [RETableViewItem itemWithTitle:@"取药" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item09.selectionStyle = UITableViewCellSelectionStyleNone;
    item09.style = UITableViewCellStyleValue1;
    UIButton *takeButton = [[UIButton alloc] init];
    takeButton.layer.cornerRadius = 6;
    takeButton.clipsToBounds = YES;
    [takeButton setTitle:@"签到" forState:UIControlStateNormal];
    [takeButton setTitle:@"已签" forState:UIControlStateSelected];
    takeButton.frame = CGRectMake(0, 0, 60, 30);
    //若取药时间不为空,则禁止取药签到
    if ((self.filedAccompanyModel.takeMedicineTimeStr.length > 0) && (self.filedAccompanyModel.queuingTimeStr.length > 0)) {
        takeButton.selected = YES;
        takeButton.userInteractionEnabled = NO;
        takeButton.backgroundColor = [UIColor lightGrayColor];
    }
    else if ((self.filedAccompanyModel.takeMedicineTimeStr.length <= 0) && (self.filedAccompanyModel.queuingTimeStr.length > 0))
    {
        takeButton.selected = NO;
        takeButton.userInteractionEnabled = YES;
        takeButton.backgroundColor = [UIColor blueColor];
    }
    else if ((self.filedAccompanyModel.takeMedicineTimeStr.length <= 0) && (self.filedAccompanyModel.queuingTimeStr.length <= 0))
    {
        takeButton.selected = NO;
        takeButton.userInteractionEnabled = NO;
        takeButton.backgroundColor = [UIColor lightGrayColor];
    }

    [takeButton addTarget:self action:@selector(clickTakeButton:) forControlEvents:UIControlEventTouchUpInside];
    item09.accessoryView = takeButton;
    self.takeButton = takeButton;
    
    RETableViewItem *item10 = [RETableViewItem itemWithTitle:@"送客" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item10.selectionStyle = UITableViewCellSelectionStyleNone;
    item10.style = UITableViewCellStyleValue1;
    UIButton *giveButton = [[UIButton alloc] init];
    giveButton.layer.cornerRadius = 6;
    giveButton.clipsToBounds = YES;
    [giveButton setTitle:@"签到" forState:UIControlStateNormal];
    [giveButton setTitle:@"已签" forState:UIControlStateSelected];
    giveButton.frame = CGRectMake(0, 0, 60, 30);
    //若送客时间不为空,则禁止送客签到
    if ((self.filedAccompanyModel.songKeTimeStr.length > 0) && (self.filedAccompanyModel.takeMedicineTimeStr.length > 0) && (self.filedAccompanyModel.queuingTimeStr.length > 0)) {
        giveButton.selected = YES;
        giveButton.userInteractionEnabled = NO;
        giveButton.backgroundColor = [UIColor lightGrayColor];
    }
    else if ((self.filedAccompanyModel.songKeTimeStr.length <= 0) && (self.filedAccompanyModel.takeMedicineTimeStr.length <= 0) && (self.filedAccompanyModel.queuingTimeStr.length <= 0))
    {
        giveButton.selected = NO;
        giveButton.userInteractionEnabled = NO;
        giveButton.backgroundColor = [UIColor lightGrayColor];
    }
    else if ((self.filedAccompanyModel.songKeTimeStr.length <= 0) && (self.filedAccompanyModel.takeMedicineTimeStr.length > 0) && (self.filedAccompanyModel.queuingTimeStr.length > 0))
    {
        giveButton.selected = NO;
        giveButton.userInteractionEnabled = YES;
        giveButton.backgroundColor = [UIColor blueColor];
    }
    else if ((self.filedAccompanyModel.songKeTimeStr.length <= 0) && (self.filedAccompanyModel.takeMedicineTimeStr.length <= 0) && (self.filedAccompanyModel.queuingTimeStr.length > 0))
    {
        giveButton.selected = NO;
        giveButton.userInteractionEnabled = NO;
        giveButton.backgroundColor = [UIColor lightGrayColor];
    }


    [giveButton addTarget:self action:@selector(clickGiveButton:) forControlEvents:UIControlEventTouchUpInside];
    item10.accessoryView = giveButton;
    self.giveButton = giveButton;
    
    RETableViewItem *item11 = [RETableViewItem itemWithTitle:@"费用项目" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        HYExpenseListViewController *expenseListVC = [[HYExpenseListViewController alloc] init];
        expenseListVC.ID = self.filedAccompanyModel.ID;
        
        [self.navigationController pushViewController:expenseListVC animated:YES];
        
    }];
    item11.style = UITableViewCellStyleValue1;
    
    [section01 addItemsFromArray:@[item01, item02, item03, item04, item05, item06, item07, item08, item09, item10, item11]];

}

- (void)clickLineButton:(UIButton *)button
{
    CLLocation *curLocation = [self.locationArray lastObject];
    if (curLocation == nil) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，稍后签到"];
        return;
    }
   
    
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ID"] = @(self.filedAccompanyModel.ID);
    params[@"IsQueuing"] = @(1);
    
    params[@"QueuingPlace"] = [NSString stringWithFormat:@"%f,%f",curLocation.coordinate.longitude, curLocation.coordinate.latitude];
    
//    NSLog(@"%f,%f",curLocation.coordinate.longitude, curLocation.coordinate.latitude);
    [mgr POST:[NSString stringWithFormat:@"%@AccompanyPersonSignIn",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"签到成功！"];
            button.selected = YES;
            button.userInteractionEnabled = NO;
            
            self.takeButton.selected = NO;
            self.takeButton.userInteractionEnabled = YES;
            
            self.giveButton.selected = NO;
            self.giveButton.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor lightGrayColor];
            self.takeButton.backgroundColor = [UIColor blueColor];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"签到失败！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"签到失败！"];
    }];

}

- (void)clickTakeButton:(UIButton *)button
{
    CLLocation *curLocation = [self.locationArray lastObject];
    if (curLocation == nil) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，稍后签到"];
        return;
    }
    

    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ID"] = @(self.filedAccompanyModel.ID);
    params[@"IsTakeMedicine"] = @(1);
    params[@"TakeMedicinePlace"] = [NSString stringWithFormat:@"%f,%f",curLocation.coordinate.longitude, curLocation.coordinate.latitude];
//    NSLog(@"%f,%f",curLocation.coordinate.longitude, curLocation.coordinate.latitude);
    [mgr POST:[NSString stringWithFormat:@"%@AccompanyPersonSignIn",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"签到成功！"];
            self.lineButton.selected = YES;
            self.lineButton.userInteractionEnabled = NO;
            button.selected = YES;
            button.userInteractionEnabled = NO;
            self.giveButton.selected = NO;
            self.giveButton.userInteractionEnabled = YES;
            button.backgroundColor = [UIColor lightGrayColor];
            self.giveButton.backgroundColor = [UIColor blueColor];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"签到失败！"];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"签到失败！"];
    }];
}

- (void)clickGiveButton:(UIButton *)button
{
    CLLocation *curLocation = [self.locationArray lastObject];
    if (curLocation == nil) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，稍后签到"];
        return;
    }

    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"ID"] = @(self.filedAccompanyModel.ID);
    params[@"IsSongKe"] = @(1);
    params[@"SongKePlace"] = [NSString stringWithFormat:@"%f,%f",curLocation.coordinate.longitude, curLocation.coordinate.latitude];
//    NSLog(@"%f,%f",curLocation.coordinate.longitude, curLocation.coordinate.latitude);
    [mgr POST:[NSString stringWithFormat:@"%@AccompanyPersonSignIn",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"签到成功！"];
            self.lineButton.selected = YES;
            self.lineButton.userInteractionEnabled = NO;
            self.takeButton.selected = YES;
            self.takeButton.userInteractionEnabled = NO;
            button.selected = YES;
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor lightGrayColor];
            [self.tableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"签到失败！"];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"签到失败！"];
    }];
}

//定位当前位置
- (void)locationCurrentPlace
{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locManager requestWhenInUseAuthorization];
        [self.locManager startUpdatingLocation];

    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"当前网络状况较差，定位可能不准确！"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.locationArray = [NSMutableArray arrayWithArray:locations];
//    NSLog(@"%@",self.locationArray);
    
    [self.locManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locManager stopUpdatingLocation];
}


@end
