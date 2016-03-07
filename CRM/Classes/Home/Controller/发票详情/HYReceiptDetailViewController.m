//
//  HYReceiptDetailViewController.m
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYReceiptDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HYUploadReceiptModel.h"
#import "UIView+MJExtension.h"
#import "AFNetworking.h"
#import "NSData+Base64.h"
#import "HYUserModel.h"
#import "HYHeader.h"
#import "HYUploadReceiptViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"


@interface HYReceiptDetailViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *uploadDate;
@property (weak, nonatomic) IBOutlet UITextView *memoText;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *memoView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;


@property (weak, nonatomic) UIPinchGestureRecognizer *pinch;
@property (weak, nonatomic) UIRotationGestureRecognizer *rotation;
@property (weak, nonatomic) UIPanGestureRecognizer *pan;
@property (weak, nonatomic) UITapGestureRecognizer *tapBig;

@end

@implementation HYReceiptDetailViewController

- (void)back
{

    for (UIViewController *uploadReceiptVC in self.navigationController.viewControllers) {
        if ([uploadReceiptVC isKindOfClass:[HYUploadReceiptViewController class]]) {
            HYUploadReceiptViewController *receiptVC = (HYUploadReceiptViewController *)uploadReceiptVC;
            [self.navigationController popToViewController:uploadReceiptVC animated:YES];
            [receiptVC loadReceipt];
            
        }
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发票详情";
    
    self.memoText.delegate = self;
    self.memoText.userInteractionEnabled = NO;
    
    self.memoView.layer.cornerRadius = 6;
    self.memoView.clipsToBounds = YES;

    self.memoText.layer.cornerRadius = 6;
    self.memoText.clipsToBounds = YES;
    
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
    
    self.backGroundView.layer.cornerRadius = 8;
    self.backGroundView.clipsToBounds = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *button = [[UIButton alloc] init];
//    button.backgroundColor = [UIColor blueColor];
    [button setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];
    button.mj_size = CGSizeMake(32, 32);
    [button addTarget:self action:@selector(editReceipt:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.uploadReceiptModel.ImageUrl] placeholderImage:[UIImage imageNamed:@"Placeholder_big"]];
    self.uploadDate.text = [NSString stringWithFormat:@"上传日期：%@",self.uploadReceiptModel.uploadDateLongStr];
    
    if (self.uploadReceiptModel.Memo == nil)
    {
        self.memoText.text = @"无";
    }
    else
    {
        self.memoText.text = self.uploadReceiptModel.Memo;
    }
    
    [SVProgressHUD dismiss];
    
    
    [self tapGestureRecognizer];
    
//    [self pinchGestureRecognizer];
//    
//    [self rotationGestureRecognizer];
//    
//    [self panGestureRecognizer];

}

/**
 监听图片点击
 */
- (void)tapPicture:(UITapGestureRecognizer *)tap
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 2.设置图片浏览器显示的所有图片
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:self.uploadReceiptModel.ImageUrl];
    photo.srcImageView = self.imageView;
//    photo.image = self.imageView.image;

    browser.photos = [NSMutableArray arrayWithObject:photo];
      // 3.显示浏览器
    [browser show];
}


//是否允许多个手势识别器同时有效

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//敲击
- (void)tapGestureRecognizer
{
    UITapGestureRecognizer *tapBig = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
    tapBig.numberOfTapsRequired= 1;
    [self.imageView addGestureRecognizer:tapBig];
    self.tapBig = tapBig;
}


//缩放
- (void)pinchGestureRecognizer
{
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    pinch.delegate = self;
    [self.imageView addGestureRecognizer:pinch];
    self.pinch = pinch;
}

//旋转
- (void)rotationGestureRecognizer
{
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    
    rotation.delegate = self;
    
    [self.imageView addGestureRecognizer:rotation];
    self.rotation = rotation;
}

//拖拽
- (void)panGestureRecognizer
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [pan setMinimumNumberOfTouches:1];
    [pan setMaximumNumberOfTouches:1];
    [self.imageView addGestureRecognizer:pan];
    self.pan = pan;
}

float _lastTransX = 0.0, _lastTransY = 0.0;
- (void)moveImage:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:self.view];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(self.imageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    self.imageView.transform = newTransform;
}

float _lastScale = 1.0;
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        
        _lastScale = 1.0;
        return;
    }
    
    CGFloat scale = [sender scale]/_lastScale;
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self.imageView setTransform:newTransform];
    
    _lastScale = [sender scale];
}

float _lastRotation = 0.0;
- (void)rotateImage:(UIRotationGestureRecognizer *)sender
{
    if([sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = -_lastRotation + [sender rotation];
    
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [self.imageView setTransform:newTransform];
    
    _lastRotation = [sender rotation];
    
}


- (void)editReceipt:(UIButton *)button
{
    UITapGestureRecognizer *tapEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replaceReceipt)];
    tapEdit.numberOfTapsRequired= 1;

    if ([button.imageView.image isEqual:[UIImage imageNamed:@"Edit"]]) {
        [button setImage:[UIImage imageNamed:@"Accept"] forState:UIControlStateNormal];
        
        self.memoText.userInteractionEnabled = YES;
        self.tipView.hidden = NO;
        self.imageView.transform = CGAffineTransformIdentity;
        [self.imageView addGestureRecognizer:tapEdit];
        [self.imageView removeGestureRecognizer:self.tapBig];
        
//        [self.imageView removeGestureRecognizer:self.pinch];
//        [self.imageView removeGestureRecognizer:self.rotation];
//        [self.imageView removeGestureRecognizer:self.pan];
        
    }
    else if ([button.imageView.image isEqual:[UIImage imageNamed:@"Accept"]])
    {
        [self.imageView removeGestureRecognizer:tapEdit];
        [self tapGestureRecognizer];
//        [self pinchGestureRecognizer];
//        [self rotationGestureRecognizer];
//        [self panGestureRecognizer];
        
        [UIView animateWithDuration:0.6 animations:^{
            [self.view endEditing:YES];
            self.view.transform = CGAffineTransformIdentity;
        }];
        
        [self replaceReceiptPostImageWithBase64:self.imageView.image];
        
        [button setImage:[UIImage imageNamed:@"Edit"] forState:UIControlStateNormal];

        self.memoText.userInteractionEnabled = NO;
        self.tipView.hidden = YES;
        
    }
    
}


- (void)replaceReceipt
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
    
    [actionSheet showInView:self.view];
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
    self.imageView.image = image;
//    [self replaceReceiptPostImageWithBase64:image];
}

//修改发票请求
- (void)replaceReceiptPostImageWithBase64:(UIImage *)image
{
    //图片上传
    //图片转data
    [SVProgressHUD showWithStatus:@"正在修改"];
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
    params[@"EnclosureID"] = @(self.uploadReceiptModel.EnclosureID);
//    params[@"UploadDate"] = @(uploadReceiptViewCell.uploadReceiptModel.EnclosureID);
    params[@"Memo"] = self.memoText.text;
    params[@"FileStream"] = [originData base64EncodedString];
    
    [mgr POST:[NSString stringWithFormat:@"%@AddOrUpdateAccompanyCostDetail",HYURL_prefix] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //        NSLog(@"%@",responseObject[@"Message"]);
        
        int code = [responseObject[@"Code"] intValue];
        
        if (code == 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"修改成功！"];
            [SVProgressHUD dismiss];
            
            
             }
        else
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"修改失败！"];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"修改失败！"];
    }];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGFloat height = -252;
    [UIView animateWithDuration:0.6 animations:^{
        //            [self.view endEditing:YES];
        CGAffineTransform translateForm = CGAffineTransformMakeTranslation(0, height);
        self.view.transform = translateForm;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.view endEditing:YES];
        self.view.transform = CGAffineTransformIdentity;
    }];
}


@end
