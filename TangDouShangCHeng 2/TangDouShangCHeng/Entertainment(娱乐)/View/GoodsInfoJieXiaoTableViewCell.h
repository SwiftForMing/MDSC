//
//  GoodsInfoJieXiaoTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsInfoJieXiaoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *statueImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *namelabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *xyhmLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIControl *rewardControl;

@property (weak, nonatomic) IBOutlet UILabel *noJionLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfJoinNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selfJoinWidth;
@property (weak, nonatomic) IBOutlet UIButton *seeButton;
@property (weak, nonatomic) IBOutlet UIControl *JoinNumMoreView;

@property (weak, nonatomic) IBOutlet UIView *joinNumLessView;
@property (weak, nonatomic) IBOutlet UILabel *duobaoNumLabel;


@end
