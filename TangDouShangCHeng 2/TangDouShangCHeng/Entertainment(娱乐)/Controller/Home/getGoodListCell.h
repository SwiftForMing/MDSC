//
//  getGoodListCell.h
//  DuoBao
//
//  Created by 黎应明 on 2017/7/26.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface getGoodListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;

@property (weak, nonatomic) IBOutlet UILabel *needNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *dianjiBtn;
@property (weak, nonatomic) IBOutlet UILabel *userLabelBtn;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
