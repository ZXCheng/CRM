//
//  HYUploadReceiptModel.h
//  CRM
//
//  Created by 翰医 on 15/11/13.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYUploadReceiptModel : NSObject

/**
 * EnclosureID	int	附件ID  主键
 */
@property (assign, nonatomic) int EnclosureID;
/**
 * UploadDate	datetime	上传日期
 */
@property (assign, nonatomic) NSTimeInterval UploadDate;
@property (copy, nonatomic) NSString *uploadDateStr;
@property (copy, nonatomic) NSString *uploadDateLongStr;
/**
 * ImageUrl	String	图片URL
 */
@property (copy, nonatomic) NSString *ImageUrl;
@property (copy, nonatomic) NSString *ThumImageUrl;
/**
 * Memo	String	备注
 */
@property (copy, nonatomic) NSString *Memo;

/**
 * cover	bool	是否覆盖
 */
@property (assign, nonatomic, getter = isCover) BOOL cover;

@end
