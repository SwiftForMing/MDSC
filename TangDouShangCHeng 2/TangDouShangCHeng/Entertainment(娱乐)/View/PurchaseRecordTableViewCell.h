//
//  PurchaseRecordTableViewCell.h
//  DuoBao
//
//  Created by clove on 12/5/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThriceResultView.h"

@class LDProgressView, SelfDuoBaoRecordInfo;

@interface PurchaseRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderSerialize;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *lotteryNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreRecordButton;

@property (weak, nonatomic) IBOutlet UIImageView *separationLine;

@property (weak, nonatomic) IBOutlet UIView *progressContainerView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainderLabel;
@property (weak, nonatomic) IBOutlet LDProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *purchaseMoreButton;

@property (weak, nonatomic) IBOutlet UIView *winnerContainerView;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *winnerPurchaseLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseNextButton;

@property (weak, nonatomic) IBOutlet UIView *runLotteryContainerView;
@property (weak, nonatomic) IBOutlet UILabel *runLotteryLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchaseNextButtonInRunLottery;

@property (weak, nonatomic) IBOutlet UIImageView *luckyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomSeparationLine;

@property (nonatomic, strong) ThriceResultView *thriceResultView;

- (void)reloadWithData:(SelfDuoBaoRecordInfo *)data ofUser:(NSString *)userID;

@end
