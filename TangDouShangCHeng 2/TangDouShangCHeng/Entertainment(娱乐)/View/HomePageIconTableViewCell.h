//
//  HomePageIconTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@interface HomePageIconTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *flImageView;
@property (weak, nonatomic) IBOutlet UILabel *flLabel;
@property (weak, nonatomic) IBOutlet UILabel *liftValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *liftLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet UIControl *zpControl;
@property (weak, nonatomic) IBOutlet UIControl *wcControl;

@property (weak, nonatomic) IBOutlet UIControl *flControl;
@property (weak, nonatomic) IBOutlet UIControl *syControl;
@property (weak, nonatomic) IBOutlet UIControl *sdControl;
@property (weak, nonatomic) IBOutlet UIControl *cjwtControl;
@property (weak, nonatomic) IBOutlet CycleScrollView *bannerView;


@property (weak, nonatomic) IBOutlet UIImageView *typeIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeName;

@property (weak, nonatomic) IBOutlet UIImageView *forthImageView;
@property (weak, nonatomic) IBOutlet UILabel *forthTitleLabel;

@end
