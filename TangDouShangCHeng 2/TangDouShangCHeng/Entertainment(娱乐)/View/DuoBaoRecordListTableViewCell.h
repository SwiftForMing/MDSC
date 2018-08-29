//
//  DuoBaoRecordListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuoBaoRecordListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *ZJButton;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *allNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *needNumTitle;
@property (weak, nonatomic) IBOutlet UILabel *needNum;
@property (weak, nonatomic) IBOutlet UILabel *joinNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *joinNumTop;

@property (weak, nonatomic) IBOutlet UIButton *seeButton;

@property (weak, nonatomic) IBOutlet UILabel *WarnLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnLabelHeight;

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@end
