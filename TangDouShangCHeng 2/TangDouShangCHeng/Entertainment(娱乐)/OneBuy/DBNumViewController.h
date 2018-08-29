//
//  DBNumViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@class SelfDuoBaoRecordInfo;

@interface DBNumViewController : UIViewController

@property (nonatomic, strong) SelfDuoBaoRecordInfo *data;
@property (strong, nonatomic) NSString *goodId;
//@property (strong, nonatomic) NSString *good_fight_id;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *goodName;

@property (weak, nonatomic) IBOutlet UIView *lotteryContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lotteryContainerViewConstraint;
@property (weak, nonatomic) IBOutlet UILabel *tiltleLabel;              // 商品明晨
@property (weak, nonatomic) IBOutlet UILabel *lotteryNumberLabel;       // 期号
@property (weak, nonatomic) IBOutlet UILabel *runLotteryTimeLabel;      // 揭晓时间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *runLotteryTimeLabelConstraints;
@property (weak, nonatomic) IBOutlet UILabel *runLotteryNumberLabel;    // 中奖幸运号码
@property (weak, nonatomic) IBOutlet UIImageView *separationLine;
@property (weak, nonatomic) IBOutlet UIImageView *luckyImageView;

@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UIImageView *separationLine1;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectView;

- (void)reloadWithData:(SelfDuoBaoRecordInfo *)data;


@end

@interface DuoBaoNumInfo : NSObject

@property (nonatomic, strong) NSString *fight_num;


@end
