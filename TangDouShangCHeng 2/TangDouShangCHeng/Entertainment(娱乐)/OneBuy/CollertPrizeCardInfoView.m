//
//  CollertPrizeCardInfoView.m
//  DuoBao
//
//  Created by clove on 11/8/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "CollertPrizeCardInfoView.h"
#import "JMWhenTapped.h"
#import <CoreText/CoreText.h>

@implementation CollertPrizeCardInfoView


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *textColor = [UIColor colorFromHexString:@"474747"];
    
    _cardNumberLabel.textColor = textColor;
    _cardPasswordLabel.textColor = textColor;
    
    _titleLabel.textColor = [UIColor colorFromHexString:@"a3a3a3"];
    
    UIImage *image = [UIImage imageNamed:@"right_arrow_blue_7_12"];
    [_instructionsButton sizeToFit];
    _instructionsButton.right = self.width;
    [_instructionsButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
    [_instructionsButton setImageEdgeInsets:UIEdgeInsetsMake(0, _instructionsButton.width - image.size.width, 0, 0)];
    [_instructionsButton setTitleColor:[UIColor defaultTintBlueColor] forState:UIControlStateNormal];
    
    _cardInfoView.backgroundColor = [UIColor colorWithWhite:0.9686 alpha:1.0];
    
    [_rechargeButton setTitle:@"充值到话费" forState:UIControlStateNormal];
    [_rechargeButton setTitleColor:textColor forState:UIControlStateNormal];
    _rechargeButton.layer.cornerRadius = _rechargeButton.height/2;
    _rechargeButton.layer.borderWidth = 1.0;
    _rechargeButton.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _rechargeButton.backgroundColor = [UIColor whiteColor];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"点击查看密码"];
    [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){0,[attString length]}];
    
    [_cardPasswordLabel whenTapped:^{
        
        if (attString.length > 0 && [_cardPasswordLabel.attributedText isEqualToAttributedString:attString]) {
            
            if (_passwordString == nil) {
                _passwordString = @"";
            }
            _cardPasswordLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:_passwordString];
        } else {
            _cardPasswordLabel.attributedText = attString;
        }
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
