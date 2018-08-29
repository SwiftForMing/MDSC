//
//  ReordListTableViewCell.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReordListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeStr;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelWidth;

@end
