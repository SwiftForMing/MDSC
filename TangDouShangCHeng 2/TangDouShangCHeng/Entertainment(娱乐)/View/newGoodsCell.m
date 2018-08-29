//
//  newGoodsCell.m
//  DuoBao
//
//  Created by 黎应明 on 2017/6/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "newGoodsCell.h"
//#import "LDP"

@implementation newGoodsCell


- (void)awakeFromNib {
    [super awakeFromNib];
    UIButton *button = _leftAddButton;
    [button setBorder:[UIColor defaultRedButtonColor] width:0.5];
    button.layer.masksToBounds = YES;
    UIColor *color = [UIColor defaultRedButtonColor];
    
    button.layer.cornerRadius = button.height * 0.1;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:color forState:UIControlStateNormal];
    
    UIButton *button1 = _rightAddButton;
    [button1 setBorder:[UIColor defaultRedButtonColor] width:0.5];
    button1.layer.masksToBounds = YES;
    UIColor *color1 = [UIColor defaultRedButtonColor];
    
    button1.layer.cornerRadius = button1.height * 0.1;
    button1.backgroundColor = [UIColor whiteColor];
    [button1 setTitleColor:color1 forState:UIControlStateNormal];
    
    _lefeNewProcess.background = [UIColor colorFromHexString:@"CCCCCC"];
    _lefeNewProcess.color = [UIColor colorFromHexString:@"e6322c"];
    _rightNewProcess.background = [UIColor colorFromHexString:@"CCCCCC"];
    _rightNewProcess.color = [UIColor colorFromHexString:@"e6322c"];
    
    [LDProgressView appearance].showBackgroundInnerShadow = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].showStroke = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].flat = @NO;
    [LDProgressView appearance].showText = @NO;
    _lefeNewProcess.type = LDProgressSolid;
    _lefeNewProcess.animate = @NO;
    
    _rightNewProcess.type = LDProgressSolid;
    _rightNewProcess.animate = @NO;
    
    }



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
