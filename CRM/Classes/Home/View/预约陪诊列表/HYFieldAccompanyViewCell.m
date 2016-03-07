//
//  HYFieldAccompanyViewCell.m
//  CRM
//
//  Created by 萌面人 on 15/11/14.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYFieldAccompanyViewCell.h"
#import "HYFiledAccompanyModel.h"

@interface HYFieldAccompanyViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *CustomerNameView;
@property (weak, nonatomic) IBOutlet UILabel *TelView;
@property (weak, nonatomic) IBOutlet UILabel *OrderIDView;
@property (weak, nonatomic) IBOutlet UILabel *HospitalView;
@property (weak, nonatomic) IBOutlet UILabel *DepartmentView;
@property (weak, nonatomic) IBOutlet UILabel *DoctorView;


@end

@implementation HYFieldAccompanyViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.size.height-=10;
    //    frame.size.width-=10;
    //    frame.origin.x +=5;
    [super setFrame:frame];
    
}

/**
 *  cell实例
 *
 *  @param tableView tableView
 *
 *  @return 实例
 */
+(instancetype)cellFromTableView:(UITableView *)tableView{
    
    NSString *rid=NSStringFromClass(self);
    
    HYFieldAccompanyViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:rid owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)setFieldAccompanyModel:(HYFiledAccompanyModel *)fieldAccompanyModel
{
    _fieldAccompanyModel = fieldAccompanyModel;
    
    self.CustomerNameView.text = fieldAccompanyModel.CustomerName;
    self.TelView.text = fieldAccompanyModel.Tel;
    self.OrderIDView.text = fieldAccompanyModel.OrderID;
    self.HospitalView.text = fieldAccompanyModel.Hospital;
    self.DepartmentView.text = fieldAccompanyModel.Department;
    self.DoctorView.text = fieldAccompanyModel.Doctor;
}

@end
