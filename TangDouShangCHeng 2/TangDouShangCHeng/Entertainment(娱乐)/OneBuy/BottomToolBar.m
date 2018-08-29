//
//  BottomToolBar.m
//  DuoBao
//
//  Created by clove on 11/9/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "BottomToolBar.h"

@implementation BottomToolBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _titleLabel.textColor = [UIColor colorFromHexString:@"474747"];
    
//    _rightButton.layer.borderWidth = 1.0f;
//    _rightButton.layer.borderColor = [UIColor defaultRedColor].CGColor;
//    _rightButton.layer.masksToBounds = YES;
//    _rightButton.layer.cornerRadius = _rightButton.height/2;
    UIImage *image = [UIImage imageNamed:@"collect_prize_continue_button.png"];
    [_rightButton setImage:image forState:UIControlStateNormal];
    
    self.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
    _separationLine.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
    
    [self addSingleBorder:UIViewBorderDirectTop color:[UIColor defaultTableViewSeparationColor] width:1.0f];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 去晒单button
- (void)configureReviewButton
{
    UIButton *button = _rightButton;
    
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor defaultRedColor].CGColor;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height * 0.1f;
    [button setImage:nil forState:UIControlStateNormal];
    [button setTitle:@"去晒单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor defaultRedColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    _buttonWidthConstraint.constant = button.height * 1.68 * 2;
    
    _titleLabel.font = [UIFont systemFontOfSize:13];
}

@end
