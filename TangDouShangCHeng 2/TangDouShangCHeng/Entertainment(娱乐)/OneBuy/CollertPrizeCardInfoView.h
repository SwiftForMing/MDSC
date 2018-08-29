//
//  CollertPrizeCardInfoView.h
//  DuoBao
//
//  Created by clove on 11/8/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollertPrizeCardInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *instructionsButton;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeButton;
@property (weak, nonatomic) IBOutlet UIButton *numberCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordCopyButton;
@property (weak, nonatomic) IBOutlet UIView *cardInfoView;

@property (nonatomic) NSString *passwordString;


@end
