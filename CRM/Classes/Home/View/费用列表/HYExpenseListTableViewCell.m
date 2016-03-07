//
//  HYExpenseListTableViewCell.m
//  CRM
//
//  Created by 萌面人 on 15/11/9.
//  Copyright © 2015年 翰医. All rights reserved.
//

#import "HYExpenseListTableViewCell.h"
#import "HYExpenseModel.h"

@interface HYExpenseListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@end

@implementation HYExpenseListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    HYExpenseListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    
    if(cell==nil){
        cell=[[[NSBundle mainBundle] loadNibNamed:rid owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)setExpenseModel:(HYExpenseModel *)expenseModel
{
    _expenseModel = expenseModel;
    self.nameLabel.text = expenseModel.CostGenerationName;
    self.timeLabel.text = expenseModel.applyTimeStr;
    self.moneyCategoryLabel.text = [NSString stringWithFormat:@"%.2f",expenseModel.Money];
    self.moneyLabel.text = expenseModel.CostType;
    self.otherLabel.text = expenseModel.Memo;
    
    self.selectionStyle = expenseModel.IsEdit;
}

@end
