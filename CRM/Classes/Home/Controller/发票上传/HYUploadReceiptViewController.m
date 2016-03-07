//
//  HYUploadReceiptViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYUploadReceiptViewController.h"
#import "HYUploadReceiptViewCell.h"
#import "AFNetworking.h"
#import "HYUserModel.h"
#import "HYHeader.h"
#import "HYUploadReceiptModel.h"
#import "MJExtension.h"
#import "UIView+MJExtension.h"
#import "NSData+Base64.h"
#import "HYReceiptDetailViewController.h"
#import "MJRefresh.h"
#import "HYUploadReceiptTipView.h"

#define HYAddButtonH 40
#define HYMargin 20
#define HYCollectionCellWidth (([UIScreen mainScreen].bounds.size.width - HYMargin * 3) * 0.5)
#define HYCollectionCellHeight (HYCollectionCellWidth + 30)

@interface HYUploadReceiptViewController ()<HYUploadReceiptViewCellDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, HYUploadReceiptTipViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *receiptArray;

@property (nonatomic, weak) UIButton *addButton;

@property (nonatomic, weak) UIButton *editButton;

@property (nonatomic, weak) HYUploadReceiptTipView *tipView;

@end

@implementation HYUploadReceiptViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)receiptArray
{
    if (!_receiptArray) {
        _receiptArray = [NSMutableArray array];
    }
    return _receiptArray;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // cell的大小
    layout.itemSize = CGSizeMake(HYCollectionCellWidth, HYCollectionCellHeight);
    
    layout.sectionInset = UIEdgeInsetsMake(HYMargin, HYMargin, HYMargin, HYMargin);
    
    // 设置每一行之间的间距
    layout.minimumLineSpacing = HYMargin;
    
    return [self initWithCollectionViewLayout:layout];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
//    [UIView animateWithDuration:0.8 animations:^{
        self.addButton.transform = CGAffineTransformIdentity;
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.navigationItem.title = @"上传发票";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
    button.mj_size = CGSizeMake(32, 32);
    [button addTarget:self action:@selector(editReceipt:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.editButton = button;
    
    //添加图片按钮
    [self setupAddreceiptButton];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    // Register cell classes
//    [self.collectionView registerClass:[HYUploadReceiptViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HYUploadReceiptViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self loadReceipt];
    
    HYUploadReceiptTipView *tipView = [[HYUploadReceiptTipView alloc] init];
    tipView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    tipView.hidden = YES;
    tipView.delegate = self;
    tipView.memoTextField.delegate = self;
    [self.navigationController.view addSubview:tipView];
    self.tipView = tipView;
    
    UITapGestureRecognizer *tapCloudCare = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitKeyboard)];
    tapCloudCare.numberOfTapsRequired= 1;
    [self.tipView addGestureRecognizer:tapCloudCare];
    
}

//添加图片按钮
- (void)setupAddreceiptButton
{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor colorWithRed:82/255.0 green:239/255.0 blue:231/255.0 alpha:1.0];
    [button setTitle:@"添加发票" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, HYAddButtonH);
    [button addTarget:self action:@selector(addReceipt:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:button];
    self.addButton = button;
}

- (void)addReceipt:(UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
    
    [actionSheet showInView:self.view];
}

- (void)editReceipt:(UIButton *)button
{
    if ([button.imageView.image isEqual:[UIImage imageNamed:@"Edit"]]) {
        [button setImage:[UIImage imageNamed:@"Accept"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.8 animations:^{
            CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0, -HYAddButtonH);
            self.addButton.transform = translateForm;
        }];
        //改变cell的编辑状态
        for (HYUploadReceiptModel *uploadReceiptModel in self.receiptArray)
        {
            uploadReceiptModel.cover = YES;
        }
    }
    else if ([button.imageView.image isEqual:[UIImage imageNamed:@"Accept"]])
    {
        [button setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.8 animations:^{
            self.addButton.transform = CGAffineTransformIdentity;
        }];
        //改变cell的编辑状态
        for (HYUploadReceiptModel *uploadReceiptModel in self.receiptArray)
        {
            uploadReceiptModel.cover = NO;
        }
    }
    [self.collectionView reloadData];
}

- (void)loadReceipt
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"CostID"] = @(self.CostID);
        
        [mgr POST:[NSString stringWithFormat:@"%@GetAccompanyCostDetailList",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //                NSLog(@"%@",responseObject[@"Message"]);
            
            int code = [responseObject[@"Code"] intValue];
            
            if (code == 0)
            {
                [self.receiptArray removeAllObjects];
                NSArray *results = responseObject[@"Results"];
                
                NSArray *arrT = [HYUploadReceiptModel objectArrayWithKeyValuesArray:results];
                
                NSRange range = NSMakeRange(0, arrT.count);
                
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                
                [self.receiptArray insertObjects:arrT atIndexes:indexSet];
                
                
                if ([self.editButton.imageView.image isEqual:[UIImage imageNamed:@"Accept"]]) {
                    //改变cell的编辑状态
                    for (HYUploadReceiptModel *uploadReceiptModel in self.receiptArray)
                    {
                        uploadReceiptModel.cover = YES;
                    }

                }
                
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"加载失败！"];
                [self.collectionView.mj_header endRefreshing];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:@"加载失败！"];
            [self.collectionView.mj_header endRefreshing];
        }];

    }];
    [self.collectionView.mj_header beginRefreshing];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.receiptArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HYUploadReceiptViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.uploadReceiptModel = self.receiptArray[indexPath.item];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.editButton.imageView.image isEqual:[UIImage imageNamed:@"Accept"]]) {
        return;
    }
    
    HYReceiptDetailViewController *receiptDetailVC = [[HYReceiptDetailViewController alloc] init];
    receiptDetailVC.uploadReceiptModel = self.receiptArray[indexPath.item];
    receiptDetailVC.CostID = self.CostID;
    [self.navigationController pushViewController:receiptDetailVC animated:YES];
    self.addButton.transform = CGAffineTransformIdentity;
}

//删除发票
- (void)uploadReceiptViewCell:(HYUploadReceiptViewCell *)uploadReceiptViewCell didSelectDeleteReceipt:(UIButton *)button
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"EnclosureID"] = @(uploadReceiptViewCell.uploadReceiptModel.EnclosureID);
    
    [mgr POST:[NSString stringWithFormat:@"%@DeleteAccompanyCostDetail",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"%@",responseObject[@"Message"]);
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"删除成功！"];
            
            [self.receiptArray removeObject:uploadReceiptViewCell.uploadReceiptModel];
            
            [self.collectionView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"删除失败！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"删除失败！"];
    }];

}

/**
 *  打开相机
 */
- (void)OpenCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
/**
 *  打开相册
 */
- (void)OpenAlbum
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    else if(buttonIndex == 1) {
        [self OpenCamera];
    }
    else
        [self OpenAlbum];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.tipView.imageView.image = image;
    self.tipView.hidden = NO;
    
    
//    [self addReceiptPostImageWithBase64:image];
}

- (void)uploadReceiptTipView:(HYUploadReceiptTipView *)uploadReceiptTipView tapCancelButton:(UIButton *)button
{
    [UIView animateWithDuration:0.6 animations:^{
        [self.tipView endEditing:YES];
        self.tipView.transform = CGAffineTransformIdentity;
    }];
    self.tipView.hidden = YES;
}

- (void)uploadReceiptTipView:(HYUploadReceiptTipView *)uploadReceiptTipView tapEnsureButton:(UIButton *)button
{
    [UIView animateWithDuration:0.6 animations:^{
        [self.tipView endEditing:YES];
        self.tipView.transform = CGAffineTransformIdentity;
    }];
    self.tipView.hidden = YES;
    [self addReceiptPostImageWithBase64:uploadReceiptTipView.imageView.image andMemo:uploadReceiptTipView.memoTextField.text];
}

//添加发票请求
- (void)addReceiptPostImageWithBase64:(UIImage *)image andMemo:(NSString *)memoStr
{
    
    //图片上传
    //图片转data
    
    [SVProgressHUD showWithStatus:@"正在上传"];
    NSData *originData = UIImageJPEGRepresentation(image, 0.05);
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"CostID"] = @(self.CostID);
//    params[@"UploadDate"] = @(uploadReceiptViewCell.uploadReceiptModel.EnclosureID);
    params[@"Memo"] = memoStr;
    params[@"FileStream"] = [originData base64EncodedString];
    
    [mgr POST:[NSString stringWithFormat:@"%@AddOrUpdateAccompanyCostDetail",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//                NSLog(@"%@",responseObject[@"Message"]);
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
            
            [self loadReceipt];
            
            //改变cell的编辑状态
//            for (HYUploadReceiptModel *uploadReceiptModel in self.receiptArray)
//            {
//                uploadReceiptModel.cover = YES;
//            }
//            
//            [self.collectionView reloadData];
            
        }
        else
        {
//            NSLog(@"%@",responseObject[@"Message"]);
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"添加失败！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"添加失败！"];
    }];

}

//修改发票请求
- (void)replaceReceiptPostImageWithBase64:(UIImage *)image
{
    //图片上传
    //图片转data
    NSData *originData = UIImageJPEGRepresentation(image, 0.05);
    
    //    [UploadFileModel sharedUploadFileModel].FileStream = [originData base64EncodedString];
    //    [UploadFileModel sharedUploadFileModel].Type = _type;
    //    UploadFileModel *uploadModel = [UploadFileModel sharedUploadFileModel];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [mgr.requestSerializer setValue:@"iPhone-0.0.1" forHTTPHeaderField:@"HY-TPA-Client"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mgr.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mgr.requestSerializer setValue:[HYUserModel sharedHYUserModel].Token forHTTPHeaderField:@"HY-TPA-Token"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"CostID"] = @(self.CostID);
//    params[@"EnclosureID"] = @(self.CostID);
    //    params[@"UploadDate"] = @(uploadReceiptViewCell.uploadReceiptModel.EnclosureID);
    //    params[@"Memo"] = @(uploadReceiptViewCell.uploadReceiptModel.EnclosureID);
    params[@"FileStream"] = [originData base64EncodedString];
    
    [mgr POST:[NSString stringWithFormat:@"%@AddOrUpdateAccompanyCostDetail",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"%@",responseObject[@"Message"]);
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
            
//            [self.receiptArray removeObject:uploadReceiptViewCell.uploadReceiptModel];
            
            [self.collectionView reloadData];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"修改失败！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"修改失败！"];
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat height = -262 + ([UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.tipView.middleView.frame));
    [UIView animateWithDuration:0.6 animations:^{
        //            [self.view endEditing:YES];
        CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0, height);
        self.tipView.transform = translateForm;
    }];
}

- (void)exitKeyboard
{
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.tipView endEditing:YES];
        self.tipView.transform = CGAffineTransformIdentity;
    }];
}


@end
