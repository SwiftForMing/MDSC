//
//  CollertPrizeSelectView.h
//  DuoBao
//
//  Created by clove on 11/9/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CollectPrizeModeMoney,
    CollectPrizeModeCard
} CollectPrizeMode;


@interface CollertPrizeSelectView : UIView
@property (weak, nonatomic) IBOutlet UIView *selectContainerView;
@property (weak, nonatomic) IBOutlet UIView *firstRowView;
@property (weak, nonatomic) IBOutlet UIView *secondRowView;
@property (weak, nonatomic) IBOutlet UIButton *firstRowButton;
@property (weak, nonatomic) IBOutlet UILabel *firstRowLabel;
@property (weak, nonatomic) IBOutlet UIButton *secondRowButton;
@property (weak, nonatomic) IBOutlet UILabel *secondRowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *separationLine;
@property (weak, nonatomic) IBOutlet UIButton *checboxForLegalAgreem;
@property (weak, nonatomic) IBOutlet UIButton *legalAgreementButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *legalAgreementLabel;

@property (nonatomic) CollectPrizeMode selectCollectPrizeMode;  // 选择兑奖方式

@property (nonatomic) BOOL legalAgreementYesNo;

- (NSString *)collectPrizeModeStringValue;

@end
