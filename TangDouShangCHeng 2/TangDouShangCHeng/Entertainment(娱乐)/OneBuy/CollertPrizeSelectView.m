//
//  CollertPrizeSelectView.m
//  DuoBao
//
//  Created by clove on 11/9/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "CollertPrizeSelectView.h"
#import "JMWhenTapped.h"
#import "UIImage+Color.h"

@implementation CollertPrizeSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _legalAgreementYesNo = YES;
    _selectCollectPrizeMode = CollectPrizeModeMoney;
    //2018 511 隐藏兑豆
//    _selectCollectPrizeMode = CollectPrizeModeCard;
    
    [_firstRowView whenTapped:^{
        _selectCollectPrizeMode = CollectPrizeModeMoney;
        
        [self updateInterface];
    }];
    
    
    [_secondRowView whenTapped:^{
        _selectCollectPrizeMode = CollectPrizeModeCard;
        
        [self updateInterface];
    }];
//     [self updateInterface];
    [_checboxForLegalAgreem addTarget:self action:@selector(legalAgreementCheckboxAction) forControlEvents:UIControlEventTouchUpInside];
    [_legalAgreementButton addTarget:self action:@selector(legalAgreementAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_legalAgreementLabel sizeToFit];
    
    UIButton *button = _confirmButton;
    button.layer.cornerRadius = button.height/2;
    button.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageFromContextWithColor:[UIColor defaultRedColor] size:button.size];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    _separationLine.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
    _selectContainerView.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
    _firstRowLabel.textColor = [UIColor colorFromHexString:@"474747"];
    _secondRowLabel.textColor = [UIColor colorFromHexString:@"474747"];
}

- (void)legalAgreementCheckboxAction
{
    _legalAgreementYesNo = !_legalAgreementYesNo;
    
    [self updateInterface];
}

- (void)legalAgreementAction
{
    _legalAgreementYesNo = YES;
    
    [self updateInterface];
}

- (void)updateInterface
{
    UIImage *normalImage = [UIImage imageNamed:@"checkbox_circle_red_normal_18_18"];
    UIImage *selectedImage = [UIImage imageNamed:@"checkbox_circle_red_selected_18_18"];
    
    if (_selectCollectPrizeMode == CollectPrizeModeMoney) {
        [_firstRowButton setImage:selectedImage forState:UIControlStateNormal];
        [_secondRowButton setImage:normalImage forState:UIControlStateNormal];
    } else {
        [_firstRowButton setImage:normalImage forState:UIControlStateNormal];
        [_secondRowButton setImage:selectedImage forState:UIControlStateNormal];
    }
    
    
    normalImage = [UIImage imageNamed:@"checkbox_square_blue_normal_12_12"];
    selectedImage = [UIImage imageNamed:@"checkbox_square_blue_selected_12_12"];

    if (_legalAgreementYesNo) {
        [_checboxForLegalAgreem setImage:selectedImage forState:UIControlStateNormal];
    } else {
        [_checboxForLegalAgreem setImage:normalImage forState:UIControlStateNormal];
    }
    
    _confirmButton.enabled = _legalAgreementYesNo;
}

- (NSString *)collectPrizeModeStringValue
{
    NSString *str = @"dbb";
    
    if (_selectCollectPrizeMode == CollectPrizeModeCard) {
        str = @"czk";
    }
    
    return str;
}



@end
