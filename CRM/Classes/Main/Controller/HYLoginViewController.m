//
//  HYLoginViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/6.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYLoginViewController.h"
#import "HYTabBarViewController.h"
#import "SVProgressHUD.h"
#import "NSString+Password.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"
#import "CoreSVP.h"
#import "AFNetworking.h"
#import "HYHeader.h"
#import "NSString+HZKExtend.h"
#import "HYUserModel.h"

#define FAILURE [CoreSVP showSVPWithType:CoreSVPTypeError Msg:@"网络连接异常，请稍后再试" duration:2.0 allowEdit:YES beginBlock:nil completeBlock:nil];

#define SHOW [SVProgressHUD showWithStatus:@"加载中，请稍后"];
#define HIDEN [SVProgressHUD dismiss];

//代码块self的弱应用
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;
#define DURATION 1.0f

@interface HYLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *rememberButton;
@property (weak, nonatomic) IBOutlet UIButton *ensureButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *antuButton;

//@property (strong, nonatomic) NSString *secret;

- (IBAction)selectEnsureButton;
- (IBAction)selectForgetButton;
- (IBAction)selectRememberButton:(UIButton *)sender;
- (IBAction)selectAutoButton:(UIButton *)sender;

@end

@implementation HYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.passwordText.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    self.ensureButton.layer.cornerRadius = 8;
    self.ensureButton.clipsToBounds = YES;
    
    // 读取用户账号和密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nameText.text = [defaults objectForKey:@"txtUserNameKey"];
    self.rememberButton.selected = [[defaults objectForKey:@"txtUserRememberKey"] boolValue];
    self.antuButton.selected = [[defaults objectForKey:@"txtUserAutoKey"] boolValue];
    
    if (self.rememberButton.selected) {
        self.passwordText.text = [defaults objectForKey:@"txtUserPasswordKey"];
        
        if (self.antuButton.selected) {
            [self selectEnsureButton];
        }
    }
}

#pragma mark- 申请秘钥
- (void)getSecret
{
    
    if (self.nameText.text == nil || self.nameText.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"用户名不能为空！"];
        return;
    }
    else if (self.passwordText.text == nil || self.passwordText.text.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"登录密码不能为空！"];
        return;
    }
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [mgr POST:[NSString stringWithFormat:@"%@GetSecret",HYURL_prefix] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        [HYUserModel sharedHYUserModel].Secret = [responseObject[@"Secret"] decodeString];
        
        [self login];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showInfoWithStatus:error];
        
    }];
}

- (void)login
{
    [SVProgressHUD showWithStatus:@"正在登录"];
    
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Account"] = self.nameText.text;
    params[@"Password"] = self.passwordText.text;
    params[@"Fingerprint"] = [NSString stringWithFormat:@"%@%@%@", [HYUserModel sharedHYUserModel].Secret, self.nameText.text, self.passwordText.text].md5;
    
    [mgr POST:[NSString stringWithFormat:@"%@LoginOA",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            
            [HYUserModel sharedHYUserModel].Token = responseObject[@"Token"];
            [HYUserModel sharedHYUserModel].Name = responseObject[@"Name"];
            
            HYTabBarViewController *tabBarVC = [[HYTabBarViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
            
            // 存储用户账号和密码 以及按钮状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.nameText.text forKey:@"txtUserNameKey"];
            [defaults setObject:self.passwordText.text forKey:@"txtUserPasswordKey"];
            
//            if (self.antuButton.selected == YES) {
//                [defaults setObject:@"YES" forKey:@"txtUserAutoKey"];
//            } else {
//                [defaults setObject:@"NO" forKey:@"txtUserAutoKey"];
//            }
//            if (self.antuButton.selected == YES) {
//                [defaults setObject:@"YES" forKey:@"txtUserRememberKey"];
//            } else {
//                [defaults setObject:@"NO" forKey:@"txtUserRememberKey"];
//            }
            [defaults setObject:@(self.rememberButton.selected) forKey:@"txtUserRememberKey"];
            [defaults setObject:@(self.antuButton.selected) forKey:@"txtUserAutoKey"];
            [SVProgressHUD dismiss];
        }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:responseObject[@"Message"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showInfoWithStatus:@"用户名或者密码错误！"];
        
    }];

}


- (IBAction)selectEnsureButton {
    
//    self.nameText.text = @"liwei";
//    self.passwordText.text = @"hy123";
    
    [self getSecret];
    
    
}


- (IBAction)selectForgetButton {
}

- (IBAction)selectRememberButton:(UIButton *)sender {
    
    if (self.passwordText.text == nil || self.passwordText.text.length == 0) {
        return;
    }
    
    sender.selected = !sender.isSelected;
    
    if (sender.selected == NO) {
        self.antuButton.selected = NO;
//        self.antuButton.userInteractionEnabled = NO;
    }
    else
    {
//        self.antuButton.userInteractionEnabled = YES;
    }
}

- (IBAction)selectAutoButton:(UIButton *)sender {
    
    if (self.passwordText.text == nil || self.passwordText.text.length == 0) {
        return;
    }
    
    sender.selected = !sender.isSelected;
    
    if (sender.selected == YES) {
        self.rememberButton.selected = YES;
//        self.rememberButton.userInteractionEnabled = NO;
    }
    else
    {
//        self.rememberButton.userInteractionEnabled = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.passwordText.text == nil || self.passwordText.text.length == 0) {
        self.antuButton.selected = NO;
        self.rememberButton.selected = NO;
    }
}




@end
