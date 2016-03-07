//
//  HYUserModel.h
//  CRM
//
//  Created by 翰医 on 15/11/10.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface HYUserModel : NSObject

/**
 *  ID	Int	主键	用户ID
 */
@property (assign, nonatomic) int ID;

/**
 *  Account	Int	用户名
 */
@property (assign, nonatomic) int Account;

/**
 *  Token	String	令牌
 */
@property (copy, nonatomic) NSString *Token;

/**
 *  Name	String	姓名
 */
@property (copy, nonatomic) NSString *Name;

/**
 *  Secret	String	秘钥
 */
@property (copy, nonatomic) NSString *Secret;


singleton_h(HYUserModel)
@end
