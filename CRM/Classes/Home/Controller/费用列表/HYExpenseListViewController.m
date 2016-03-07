//
//  HYExpenseListViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYExpenseListViewController.h"
#import "HYExpenseListHeaderView.h"
#import "HYExpenseListTableViewCell.h"
#import "HYExpensedetailViewController.h"
#import "MJRefresh.h"
#import "HYExpenseModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "HYUserModel.h"
#import "HYHeader.h"
#import "HYExpenseEditViewController.h"
#import "HYExpenseCategoryModel.h"
#import "HYNavigationViewController.h"

@interface HYExpenseListViewController ()

@property (nonatomic, weak) HYExpenseListHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *expenseListArray;

@property (strong, nonatomic) NSMutableArray *expenseCategoryArray;

@end

@implementation HYExpenseListViewController

- (NSMutableArray *)expenseListArray
{
    if (!_expenseListArray) {
        _expenseListArray = [NSMutableArray array];
    }
    return _expenseListArray;
}

- (NSMutableArray *)expenseCategoryArray{
    if (!_expenseCategoryArray) {
        _expenseCategoryArray = [NSMutableArray array];
    }
    return _expenseCategoryArray;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"费用列表";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getExpenseCategory];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addReceipt)];
//    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addReceipt)];
    
    HYExpenseListHeaderView *headerView = [[HYExpenseListHeaderView alloc] init];
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
    self.headerView = headerView;
    self.tableView.tableHeaderView = self.headerView;
    
    //    刷新数据
    [self refreshInformation];
}

- (void)addReceipt
{
    
    HYExpensedetailViewController *expenseDetailVC = [[HYExpensedetailViewController alloc] init];
    
    expenseDetailVC.ID = self.ID;
    expenseDetailVC.expenseCategoryArray = self.expenseCategoryArray;
//    HYNavigationViewController *navVC = [[HYNavigationViewController alloc] initWithRootViewController:expenseDetailVC];
    [self.navigationController pushViewController:expenseDetailVC animated:YES];
//    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)refreshInformation
{
    //获取数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"PageSize"] = @(NSIntegerMax);
        params[@"FormID"] = @(self.ID);
        [mgr POST:[NSString stringWithFormat:@"%@GetAccompanyCostList",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

            if (self.expenseListArray.count > 0) {
                [self.expenseListArray removeAllObjects];
            }
            NSArray *results = responseObject[@"Results"];
            
            NSArray *arrT = [HYExpenseModel objectArrayWithKeyValuesArray:results];
            
            NSRange range = NSMakeRange(0, arrT.count);
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [self.expenseListArray insertObjects:arrT atIndexes:indexSet];
            
            [self.tableView reloadData];
            
            
            [self.tableView.mj_header endRefreshing];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.tableView.mj_header endRefreshing];
            
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    //上拉加载
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//        
//        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
//        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//        
//        [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
//        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
//        
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        
//        params[@"FormID"] = @(self.ID);
//        
//        [mgr POST:[NSString stringWithFormat:@"%@GetAccompanyCostList",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            
//            
//            NSArray *results = responseObject[@"results"];
//            
//            NSArray *arrT = [HYExpenseModel objectArrayWithKeyValuesArray:results];
//            
//            NSRange range = NSMakeRange(arrT.count - 1, arrT.count);
//            
//            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
//            
//            [self.expenseListArray insertObjects:arrT atIndexes:indexSet];
//            
//            [self.tableView reloadData];
//            
//            [self.tableView.mj_footer endRefreshing];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [self.tableView.mj_footer endRefreshing];
//            
//        }];
//    }];
//    [self.tableView.mj_footer beginRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.expenseListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HYExpenseListTableViewCell *cell = [HYExpenseListTableViewCell cellFromTableView:tableView];
    
    cell.expenseModel = self.expenseListArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYExpenseModel *Model = self.expenseListArray[indexPath.row];

    if (!Model.IsEdit) {
        [SVProgressHUD showInfoWithStatus:@"你不能修改他人的费用！"];
        return;
    }
    
    HYExpenseEditViewController *editVC = [[HYExpenseEditViewController alloc] init];
    editVC.expenseModel = self.expenseListArray[indexPath.row];
    editVC.expenseCategoryArray = self.expenseCategoryArray;
//    HYNavigationViewController *navVC = [[HYNavigationViewController alloc] initWithRootViewController:editVC];
    [self.navigationController pushViewController:editVC animated:YES];
//    [self presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - tableView的代理方法
/**
 *  如果实现了这个方法,就自动实现了滑动删除的功能
 *  点击了删除按钮就会调用
 *  提交了一个编辑操作就会调用(操作:删除\添加)
 *  @param editingStyle 编辑的行为
 *  @param indexPath    操作的行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYExpenseModel *Model = self.expenseListArray[indexPath.row];
    
    if (!Model.IsEdit) {
        [SVProgressHUD showInfoWithStatus:@"你不能删除他人的费用！"];
        return;
    }
//    if (editingStyle == UITableViewCellEditingStyleDelete) { // 提交的是删除操作
    editingStyle = UITableViewCellEditingStyleDelete;
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    HYExpenseModel *expenseModel = self.expenseListArray[indexPath.row];
//    NSLog(@"%d",expenseModel.CostID);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"CostID"] = @(expenseModel.CostID);
    
    [mgr POST:[NSString stringWithFormat:@"%@DeleteAccompanyCost",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 局部刷新某些行(使用前提:模型数据的行数不变)
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self refreshInformation];
        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"删除失败！"];
        
    }];

}

/**
 *  当tableView进入编辑状态的时候会调用,询问每一行进行怎样的操作(添加\删除)
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//获取费用类型
- (void)getExpenseCategory
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [mgr POST:[NSString stringWithFormat:@"%@GetAccompanyCostType",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSArray *results = responseObject[@"Results"];
        
        self.expenseCategoryArray = [HYExpenseCategoryModel objectArrayWithKeyValuesArray:results];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"获取费用类型失败！"];
    }];
    
}



@end
