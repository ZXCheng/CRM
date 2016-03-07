//
//  XIBTestCell.h
//  自学RETableViewManager
//
//  Created by han on 15/8/13.
//  Copyright (c) 2015年 韩赵凯. All rights reserved.
//

#import "RETableViewCell.h"
#import "XIBTestItem.h"

@interface XIBTestCell : RETableViewCell

@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@property (strong, readwrite, nonatomic) XIBTestItem *item;

@end
