//
//  JieXiaoListCollectionViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/13.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@class GoodsDetailInfo;

@interface JieXiaoListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *jiexiaoImage;

@property (weak, nonatomic) IBOutlet UIView *warnView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UIView *djsView;
@property (weak, nonatomic) IBOutlet MZTimerLabel *countdownLabel;

@property (weak, nonatomic) IBOutlet UIView *runLotteryContainer;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *lotteryNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *runLotteryTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsTypeImageView;

- (void)reloadWithData:(GoodsDetailInfo *)data;

@end
