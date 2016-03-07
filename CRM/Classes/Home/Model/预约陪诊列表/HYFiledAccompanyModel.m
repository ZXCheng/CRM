//
//  HYFiledAccompanyModel.m
//  CRM
//
//  Created by 翰医 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYFiledAccompanyModel.h"

@implementation HYFiledAccompanyModel

- (void)setAppointmentDate:(NSTimeInterval)AppointmentDate
{
    _AppointmentDate = AppointmentDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.appointmentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:AppointmentDate]];
}

- (void)setConfirmDate:(NSTimeInterval)ConfirmDate
{
    _ConfirmDate = ConfirmDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.confirmDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ConfirmDate]];
}

- (void)setChargeFinishDate:(NSTimeInterval)ChargeFinishDate
{
    _ChargeFinishDate = ChargeFinishDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.chargeFinishDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:ChargeFinishDate]];

}

- (void)setQueuingTime:(NSTimeInterval)QueuingTime
{
    _QueuingTime = QueuingTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.queuingTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:QueuingTime]];
}

- (void)setTakeMedicineTime:(NSTimeInterval)TakeMedicineTime
{
    _TakeMedicineTime = TakeMedicineTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.takeMedicineTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:TakeMedicineTime]];
}

- (void)setSongKeTime:(NSTimeInterval)SongKeTime
{
    _SongKeTime = SongKeTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.songKeTimeStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:SongKeTime]];
}

@end
