//
//  HYExpensedetailViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYExpensedetailViewController.h"
#import "RETableViewManager.h"
#import "HYExpenseModel.h"
#import "UIView+MJExtension.h"
#import "HYHeader.h"
#import "AFNetworking.h"
#import "HYUserModel.h"
#import "HYExpenseCategoryModel.h"
#import "MJExtension.h"
#import "HYUploadReceiptViewController.h"
#import "HYPickerView.h"
#import "HYExpenseListViewController.h"

#define HYPickerViewH 220
#define HYTextFieldWidth 200

@interface HYExpensedetailViewController ()<UIPickerViewDataSource,UIPickerViewDelegate, HYPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) RETableViewManager *manager;
@property (strong, nonatomic) RETableViewItem *itemScore;

@property (weak, nonatomic) UITextField *moneyTextField;
@property (weak, nonatomic) UITextField *memoTextField;
@property (weak, nonatomic) UITextField *categoryTextField;

@property (strong, nonatomic) HYPickerView *hypickerView;

@property (copy, nonatomic) NSString *CostTypeID;

@end

@implementation HYExpensedetailViewController

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
    
    self.navigationItem.title = @"添加费用";
    
    self.categoryTextField.delegate = self;
//    self.memoTextField.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    HYPickerView *hypickerView = [[HYPickerView alloc] init];
    
    hypickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, HYPickerViewH);
//    hypickerView.hidden = YES;
    
    hypickerView.pickerView.delegate = self;
    hypickerView.pickerView.dataSource = self;
    [self.navigationController.view addSubview:hypickerView];
    self.hypickerView = hypickerView;
    hypickerView.hydelegate = self;
    
    UITapGestureRecognizer *tapCloudCare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyBoard)];
    tapCloudCare.numberOfTapsRequired= 1;
    tapCloudCare.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapCloudCare];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.manager = [[RETableViewManager alloc] initWithTableView:self.tableView];
    
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
    costGenerationNameTextField.text = [HYUserModel sharedHYUserModel].Name;
    
//    REDateTimeItem *item02 = [REDateTimeItem itemWithTitle:@"填写日期" value:nil placeholder:nil format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
//    item02.maximumDate = [NSDate date];
    
    //添加items
    RETableViewItem *item03 = [RETableViewItem itemWithTitle:@"费用类型" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
        
        [UIView animateWithDuration:0.8 animations:^{
            CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0, -HYPickerViewH);
            self.hypickerView.transform = translateForm;
        }];
        
        
    }];
    item03.style = UITableViewCellStyleValue1;
    UITextField *categoryTextField = [[UITextField alloc] init];
    categoryTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    categoryTextField.textAlignment = NSTextAlignmentRight;
    categoryTextField.borderStyle = UITextBorderStyleRoundedRect;
    categoryTextField.placeholder = @"选择费用类型";
    categoryTextField.enabled = NO;
    item03.accessoryView = categoryTextField;
    self.categoryTextField = categoryTextField;
    
    RETableViewItem *item04 = [RETableViewItem itemWithTitle:@"申报金额" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    
    item04.style = UITableViewCellStyleValue1;
    UITextField *meonyTextField = [[UITextField alloc] init];
    meonyTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    meonyTextField.textAlignment = NSTextAlignmentRight;
    meonyTextField.borderStyle = UITextBorderStyleRoundedRect;
    meonyTextField.placeholder = @"输入申报金额";
    meonyTextField.keyboardType = UIKeyboardTypeDecimalPad;
    item04.accessoryView = meonyTextField;
    self.moneyTextField = meonyTextField;
    
    RETableViewItem *item05 = [RETableViewItem itemWithTitle:@"备注" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        [item deselectRowAnimated:YES];
        
    }];
    item05.style = UITableViewCellStyleValue1;
    UITextField *memoTextField = [[UITextField alloc] init];
    memoTextField.mj_size = CGSizeMake(HYTextFieldWidth, 30);
    memoTextField.textAlignment = NSTextAlignmentRight;
    memoTextField.borderStyle = UITextBorderStyleRoundedRect;
    memoTextField.placeholder = @"输入备注，可无";
    item05.accessoryView = memoTextField;
    self.memoTextField = memoTextField;
    
//    RETableViewItem *item06 = [RETableViewItem itemWithTitle:@"发票" accessoryType:UITableViewCellAccessoryDisclosureIndicator selectionHandler:^(RETableViewItem *item) {
//        [item deselectRowAnimated:YES];
//        
//        HYUploadReceiptViewController *uploadreceiptVC = [[HYUploadReceiptViewController alloc] init];
//        [self.navigationController pushViewController:uploadreceiptVC animated:YES];
//        
//    }];
//    item06.style = UITableViewCellStyleValue1;
    //    item01.detailLabelText = [User sharedUser].Name;
    
    
    [section01 addItemsFromArray:@[item01, item03, item04, item05]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Save"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(saveExpense:)];
    
}

//保存
- (void)saveExpense:(UIButton *)button
{
    
    if (self.categoryTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"费用类型未选择！"];
        return;
    }
    else if (self.moneyTextField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"申报金额未填写！"];
        return;
    }
    
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
    
    params[@"FormID"] = @(self.ID);
    params[@"CostTypeID"] = self.CostTypeID;
    params[@"Money"] = @([self.moneyTextField.text doubleValue]);
    params[@"Memo"] = self.memoTextField.text;
    
    [mgr POST:[NSString stringWithFormat:@"%@AddAccompanyCost",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
            self.categoryTextField.text = nil;
            self.memoTextField.text = nil;
            self.moneyTextField.text = nil;
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"保存失败！"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
