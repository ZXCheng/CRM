//
//  HYFiledAccompanyModel.h
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYFiledAccompanyModel : NSObject

/**
 *  帐户ID  自增列	用户ID
 */
@property (assign, nonatomic) int ID;
/**
 *  订单编号
 */
@property (copy, nonatomic) NSString *OrderID;
/**
 *  Applicant	string	发起人
 */
@property (copy, nonatomic) NSString *Applicant;
/**
 *  ApplicantDept	string	发起人部门
 */
@property (copy, nonatomic) NSString *ApplicantDept;
/**
 *  Title	string	标题
 */
@property (copy, nonatomic) NSString *Title;
/**
 *  CustomerName	string	客户名称
 */
@property (copy, nonatomic) NSString *CustomerName;
/**
 *  Tel	string	手机号
 */
@property (copy, nonatomic) NSString *Tel;
/**
 *  Source	string	来源
 */
@property (copy, nonatomic) NSString *Source;
/**
 *  Grade	string	等级
 */
@property (copy, nonatomic) NSString *Grade;
/**
 *  AppointmentDate	datetime	预约时间
 */
@property (assign, nonatomic) NSTimeInterval AppointmentDate;
@property (copy, nonatomic) NSString *appointmentDateStr;
/**
 *  Hospital	string	医院
 */
@property (copy, nonatomic) NSString *Hospital;
/**
 *  Disease	string	病情
 */
@property (copy, nonatomic) NSString *Disease;
/**
 *  Department	string	科室
 */
@property (copy, nonatomic) NSString *Department;
/**
 *  Doctor	string	医生
 */
@property (copy, nonatomic) NSString *Doctor;
/**
 *  ConfirmDate	datetime	确认时间
 */
@property (assign, nonatomic) NSTimeInterval ConfirmDate;
@property (copy, nonatomic) NSString *confirmDateStr;
/**
 *  Status	int	流程状态
 */
@property (assign, nonatomic) int Status;
/**
 *  LineManager	string	线下经理
 */
@property (copy, nonatomic) NSString *LineManager;
/**
 *  AccompanyPerson	string	陪诊人员
 */
@property (copy, nonatomic) NSString *AccompanyPerson;
/**
 *  VisitPerson	string	回访人员
 */
@property (copy, nonatomic) NSString *VisitPerson;
/**
 *  Satisfaction	string	满意度
 */
@property (copy, nonatomic) NSString *Satisfaction;
/**
 *  VisitRecord	string	回访记录
 */
@property (copy, nonatomic) NSString *VisitRecord;
/**
 *  FlowCompleted	int	完成标识
 */
@property (assign, nonatomic) int FlowCompleted;
/**
 *  Memo	string	备注
 */
@property (copy, nonatomic) NSString *Memo;
/**
 *  ServiceTypeID	string	服务类型
 */
@property (copy, nonatomic) NSString *ServiceTypeID;
/**
 *  Cost	decimal	费用
 */
@property (assign, nonatomic) double Cost;
/**
 *  LateChargeDate	string	最晚收费日期
 */
@property (assign, nonatomic) NSTimeInterval LateChargeDate;
@property (copy, nonatomic) NSString *lateChargeDateStr;
/**
 *  ChargeFinishDate	datetime	收入完成日期
 */
@property (assign, nonatomic) NSTimeInterval ChargeFinishDate;
@property (copy, nonatomic) NSString *chargeFinishDateStr;
/**
 *  WhetherOpenInvoice	int	是否开发票
 */
@property (assign, nonatomic) int WhetherOpenInvoice;
/**
 *  InvoiceTitle	string	发票抬头
 */
@property (copy, nonatomic) NSString *InvoiceTitle;
/**
 *  CashCharges	decimal	现金收费
 */
@property (assign, nonatomic) double CashCharges;
/**
 *  PaymentAmount	decimal	代收代付金额
 */
@property (assign, nonatomic) double PaymentAmount;
/**
 *  Discount	decimal	折扣
 */
@property (assign, nonatomic) double Discount;
/**
 *  QueuingTime	datetime	排队时间	若排队时间不为空
 则禁止排队签到
 */
@property (assign, nonatomic) NSTimeInterval QueuingTime;
@property (copy, nonatomic) NSString *queuingTimeStr;
/**
 *  QueuingPlace	string	排队地点
 */
@property (copy, nonatomic) NSString *QueuingPlace;
/**
 *  TakeMedicineTime	datetime	取药时间	若取药时间不为空
 则禁止取药签到
 */
@property (assign, nonatomic) NSTimeInterval TakeMedicineTime;
@property (copy, nonatomic) NSString *takeMedicineTimeStr;
/**
 *  TakeMedicinePlace	string	取药地点
 */
@property (copy, nonatomic) NSString *TakeMedicinePlace;
/**
 *  SongKeTime	datetime	送客时间	若送客时间不为空
 则禁止送客签到
 */
@property (assign, nonatomic) NSTimeInterval SongKeTime;
@property (copy, nonatomic) NSString *songKeTimeStr;
/**
 *  SongKePlace	string	送客地点
 */
@property (copy, nonatomic) NSString *SongKePlace;

@end
