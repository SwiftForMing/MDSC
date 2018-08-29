//
//  ShaiDanDetailViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShaiDanDetailViewController : UIViewController

@property (strong, nonatomic) NSString *zoneId;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodNameLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *luckNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiexiaoTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgWidth;


@end
