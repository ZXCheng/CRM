//
//  HYExpenseEditViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/11.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYExpenseEditViewController.h"
#import "RETableViewManager.h"
#import "HYExpenseModel.h"
#import "UIView+MJExtension.h"
#import "HYHeader.h"
#import "AFNetworking.h"
#import "HYUserModel.h"
#import "HYExpenseCategoryModel.h"
#import "MJExtension.h"
#import "HYUploadReceiptViewController.h"
#import "HYAlertView.h"
#import "HYPickerView.h"
#import "HYExpenseListViewController.h"

#define HYPickerViewH 220
#define HYTextFieldWidth 200

@interface HYExpenseEditViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,HYPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewItem *selectItem;

@property (weak, nonatomic) HYAlertView *alertView;

@property (weak, nonatomic) UITextField *moneyTextField;
@property (weak, nonatomic) UITextField *memoTextField;
@property (weak, nonatomic) UITextField *categoryTextField;

@property (weak, nonatomic) HYPickerView *hypickerView;

@property (copy, nonatomic) NSString *CostTypeID;

@end

@implementation HYExpenseEditViewController

//判断费用本身CostTypeID
- (void)origainCostTypeID
{
    
    for (HYExpenseCategoryModel *categoryModel in self.expenseCategoryArray) {
        if ([categoryModel.Title isEqualToString:self.expenseModel.CostType]) {
            self.CostTypeID = categoryModel.ID;
        }
    }
}

- (void)back
{
    for (UIViewController *expenseListVC in self.navigationController.viewControllers) {
        if ([expenseListVC isKindOfClass:[HYExpenseListViewController class]]) {
            HYExpenseListViewController *expenseVC = (HYExpenseListViewController *)expenseListVC;
            [self.navigationController popToViewController:expenseListVC animated:YES];
            [expenseVC refreshInformation];
            [UIView animateWithDuration:0.8 animations:^{
                self.hypickerView.transform = CGAffineTransformIdentity;
            }];
            
        }
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [UIView animateWithDuration:0.8 animations:^{
//        self.hypickerView.transform = CGAffineTransformIdentity;
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改费用";
    
    self.categoryTextField.delegate = self;
//    self.memoTextField.delegate = self;
    
    UITapGestureRecognizer *tapCloudCare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyBoard)];
    tapCloudCare.numberOfTapsRequired= 1;
    tapCloudCare.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapCloudCare];
    
    
//    self.manager.tableView.backgroundColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    HYPickerView *hypickerView = [[HYPickerView alloc] init];

    hypickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, HYPickerViewH);
//    hypickerView.hidden = YES;
    hypickerView.pickerView.delegate = self;
    hypickerView.pickerView.dataSource = self;
    [self.navigationController.view addSubview:hypickerView];
    self.hypickerView = hypickerView;
    hypickerView.hydelegate = self;
    
    [self origainCostTypeID];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    UITableView *tab = [[UITableView alloc] init];
//    [self.view addSubview:tab];
//    tab.frame = self.view.frame;

    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
//    UIButton *button = [[UIButton alloc] init];
//    button.backgroundColor = [UIColor blueColor];
//    [button setTitle:@"保存" forState:UIControlStateNormal];
//    button.mj_size = CGSizeMake(50, 30);
//    [button addTarget:self action:@selector(saveExpense:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(saveExpense:)];
    
    //添加组
    RETableViewSection *section01 = [RETableViewSection section];
    
    [self.manager addSection:section01];
    
    //添加items
    RETableViewItem *item01 = [RETableViewItem itemWithTitle:@"填报人员" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    UITextField *costGenerationNameTextField = [[UITextField alloc] init];
    costGenerationNameTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    costGenerationNameTextField.textAlignment = NSTextAlignmentRight;
    costGenerationNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    costGenerationNameTextField.enabled = NO;
    item01.accessoryView = costGenerationNameTextField;
    
    item01.style = UITableViewCellStyleValue1;
    costGenerationNameTextField.text = self.expenseModel.CostGenerationName;
    
    RETableViewItem *item02 = [RETableViewItem itemWithTitle:@"填报日期" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    UITextField *applyTimeTextField = [[UITextField alloc] init];
    applyTimeTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    applyTimeTextField.textAlignment = NSTextAlignmentRight;
    applyTimeTextField.borderStyle = UITextBorderStyleRoundedRect;
    applyTimeTextField.enabled = NO;
    item02.accessoryView = applyTimeTextField;
    
    item02.style = UITableViewCellStyleValue1;
    applyTimeTextField.text = self.expenseModel.applyTimeStr;
   
    
    RETableViewItem *item03 = [RETableViewItem itemWithTitle:@"费用类型" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        [UIView animateWithDuration:0.8 animations:^{
//            [self.view endEditing:YES];
            CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0, -HYPickerViewH);
            self.hypickerView.transform = translateForm;
        }];
        
    }];
    UITextField *categoryTextField = [[UITextField alloc] init];
    categoryTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    categoryTextField.textAlignment = NSTextAlignmentRight;
    categoryTextField.borderStyle = UITextBorderStyleRoundedRect;
    categoryTextField.enabled = NO;
    item03.accessoryView = categoryTextField;
    self.categoryTextField = categoryTextField;
    
    item03.style = UITableViewCellStyleValue1;
    categoryTextField.text= self.expenseModel.CostType;
    
    
    RETableViewItem *item04 = [RETableViewItem itemWithTitle:@"申报金额" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
  
    }];
    UITextField *meonyTextField = [[UITextField alloc] init];
    meonyTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    meonyTextField.textAlignment = NSTextAlignmentRight;
    meonyTextField.borderStyle = UITextBorderStyleRoundedRect;
    meonyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    item04.accessoryView = meonyTextField;
    self.moneyTextField = meonyTextField;
    item04.style = UITableViewCellStyleValue1;
    meonyTextField.text = [NSString stringWithFormat:@"%.2f",self.expenseModel.Money];
    
    RETableViewItem *item05 = [RETableViewItem itemWithTitle:@"备注" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    UITextField *memoTextField = [[UITextField alloc] init];
    memoTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    memoTextField.textAlignment = NSTextAlignmentRight;
    memoTextField.borderStyle = UITextBorderStyleRoundedRect;
    item05.accessoryView = memoTextField;
    self.memoTextField = memoTextField;
    item05.style = UITableViewCellStyleValue1;
    memoTextField.text = self.expenseModel.Memo;
    
    RETableViewItem *item06 = [RETableViewItem itemWithTitle:@"发票" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        HYUploadReceiptViewController *uploadreceiptVC = [[HYUploadReceiptViewController alloc] init];
        uploadreceiptVC.CostID = self.expenseModel.CostID;
        [self.navigationController pushViewController:uploadreceiptVC animated:YES];
        self.hypickerView.transform = CGAffineTransformIdentity;
        
    }];
    item06.style = UITableViewCellStyleValue1;
    //    item01.detailLabelText = [User sharedUser].Name;
    
    
    [section01 addItemsFromArray:@[item01, item02, item03, item04, item05, item06]];
}

//保存
- (void)saveExpense:(UIButton *)button
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.8 animations:^{
        self.hypickerView.transform = CGAffineTransformIdentity;
    }];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"CostID"] = @(self.expenseModel.CostID);
    params[@"CostTypeID"] = self.CostTypeID;
    params[@"Money"] = @([self.moneyTextField.text floatValue]);
    params[@"Memo"] = self.memoTextField.text;
//    NSLog(@"%@",self.CostTypeID);
    
    [mgr POST:[NSString stringWithFormat:@"%@UpdateAccompanyCost",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject[@"Message"]);
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"修改失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"修改失败！"];
    }];
    
}

- (void)pickerView:(HYPickerView *)pickerView didSelectWanchengButton:(UIButton *)button
{
    [UIView animateWithDuration:0.8 animations:^{
        self.hypickerView.transform = CGAffineTransformIdentity;
    }];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.expenseCategoryArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HYExpenseCategoryModel *expenseModel = self.expenseCategoryArray[row];
    return expenseModel.Title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    HYExpenseCategoryModel *expenseModel = self.expenseCategoryArray[row];
    self.categoryTextField.text = expenseModel.Title;
    self.CostTypeID = expenseModel.ID;
}


- (void)exitKeyBoard
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.8 animations:^{
        self.hypickerView.transform = CGAffineTransformIdentity;
    }];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.8 animations:^{
        self.hypickerView.transform = CGAffineTransformIdentity;
    }];
}

@end
