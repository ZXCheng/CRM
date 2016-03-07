//
//  HYFieldAccompanyViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/6.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYFieldAccompanyViewController.h"
#import "HYSingleFieldAccompanyViewController.h"
#import "MJRefresh.h"
#import "HYFiledAccompanyModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "HYUserModel.h"
#import "HYHeader.h"
#import "HYFieldAccompanyViewCell.h"

//static NSInteger pageIndex = 1;

@interface HYFieldAccompanyViewController ()

@property (strong, nonatomic) NSMutableArray *fieldAccompanyListArray;

@property (assign, nonatomic) NSInteger pageIndex;

@property (assign, nonatomic) NSInteger total;

@end

@implementation HYFieldAccompanyViewController

- (NSMutableArray *)fieldAccompanyListArray
{
    if (!_fieldAccompanyListArray) {
        _fieldAccompanyListArray = [NSMutableArray array];
    }
    return _fieldAccompanyListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.pageIndex = 1;
    
    self.navigationItem.title = @"预约陪诊列表";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
//    刷新数据
    [self refreshInformationHeader];
    [self refreshInformationFooter];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshInformationHeader
{
//    pageIndex = 1;
    //获取数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
        self.pageIndex = 1;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"PageIndex"] = @(self.pageIndex);
//        NSLog(@"下拉%ld",(long)self.pageIndex);
        params[@"PageSize"] = @(15);
        [mgr POST:[NSString stringWithFormat:@"%@GetAppointmentDiagnosisList",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

            NSArray *results = responseObject[@"Results"];
            
            NSArray *arrT = [HYFiledAccompanyModel objectArrayWithKeyValuesArray:results];
            
            if (self.fieldAccompanyListArray.count > 0)
            {
                [self.fieldAccompanyListArray removeAllObjects];
                
//                HYFiledAccompanyModel *fieldAccompanyModel = [self.fieldAccompanyListArray firstObject];
//
//                NSMutableArray *tempArray = [NSMutableArray array];
//                
//                for (HYFiledAccompanyModel *model in arrT) {
//                    if (model.AppointmentDate > fieldAccompanyModel.AppointmentDate) {
//                        [tempArray addObject:model];
//                    }
//                }
//                NSRange range = NSMakeRange(0, tempArray.count);
//                
//                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//        
//                [self.fieldAccompanyListArray insertObjects:tempArray atIndexes:indexSet];
//                
//                [self.tableView reloadData];
//                
//                
//                [self.tableView.mj_header endRefreshing];
            }

            NSRange range = NSMakeRange(0, arrT.count);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [self.fieldAccompanyListArray insertObjects:arrT atIndexes:indexSet];
            
            [self.tableView reloadData];
            
            
            [self.tableView.mj_header endRefreshing];
            
            self.tableView.mj_footer.hidden = NO;

            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            
        }];
    }];

    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshInformationFooter
{
    //上拉加载
    
//    pageIndex++;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
        self.pageIndex++;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"PageIndex"] = @(self.pageIndex);
//        NSLog(@"上拉%ld",(long)self.pageIndex);
        params[@"PageSize"] = @(15);
        [mgr POST:[NSString stringWithFormat:@"%@GetAppointmentDiagnosisList",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.total = [responseObject[@"Total"] integerValue];
            
            NSArray *results = responseObject[@"Results"];
            
            NSArray *arrT = [HYFiledAccompanyModel objectArrayWithKeyValuesArray:results];

            [self.fieldAccompanyListArray addObjectsFromArray:arrT];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
            if (self.fieldAccompanyListArray.count >= self.total) {
                self.tableView.mj_footer.hidden = YES;
                
            }
            else{
                self.tableView.mj_footer.hidden = NO;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.mj_footer endRefreshing];
            
        }];
    }];
    [self.tableView.mj_footer beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.fieldAccompanyListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYFieldAccompanyViewCell *cell = [HYFieldAccompanyViewCell cellFromTableView:tableView];
    
    cell.fieldAccompanyModel = self.fieldAccompanyListArray[indexPath.row];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYSingleFieldAccompanyViewController *singleVC = [[HYSingleFieldAccompanyViewController alloc] init];
    singleVC.filedAccompanyModel = self.fieldAccompanyListArray[indexPath.row];
    [self.navigationController pushViewController:singleVC animated:YES];
}
@end
