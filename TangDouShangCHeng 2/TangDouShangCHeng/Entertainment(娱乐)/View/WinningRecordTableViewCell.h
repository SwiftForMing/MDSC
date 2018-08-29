//
//  WiningRecordTableViewCell.h
//  DuoBao
//
//  Created by clove on 4/17/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThriceResultView.h"

@class ZJRecordListInfo;

@interface WinningRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UILabel *bettingTimesLabel;
@property (weak, nonatomic) IBOutlet UIButton *winningButton;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptPrizeStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *bettingButton;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *bottomSeparationLine;
@property (nonatomic, strong) ThriceResultView *thriceResultView;


- (void)reloadWithData:(ZJRecordListInfo *)data ofUser:(NSString *)userID;

@end
