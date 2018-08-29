//
//  GoodsInfoTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface GoodsInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statueImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processLabel;
@property (weak, nonatomic) IBOutlet UILabel *allNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *needNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@property (weak, nonatomic) IBOutlet UILabel *noJionLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfJoinNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfJoinWidth;
@property (weak, nonatomic) IBOutlet UIButton *lookNumButton;
@property (weak, nonatomic) IBOutlet UIControl *JoinNumMoreView;

@property (weak, nonatomic) IBOutlet UIView *joinNumLessView;
@property (weak, nonatomic) IBOutlet UILabel *duobaoNumLabel;



@property (weak, nonatomic) IBOutlet UIView *daojishiViw;
@property (weak, nonatomic) IBOutlet UILabel *daojieshiWarnLabel;
@property (weak, nonatomic) IBOutlet MZTimerLabel *timerLabel;

@property (weak, nonatomic) IBOutlet UIButton *jsxqButton;

@end
