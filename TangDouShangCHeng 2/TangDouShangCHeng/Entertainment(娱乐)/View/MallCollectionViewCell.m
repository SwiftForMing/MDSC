//
//  MallCollectionViewCell.m
//  DuoBao
//
//  Created by clove on 5/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "MallCollectionViewCell.h"
#import "GoodsFightModel.h"
#import "GoodsModel.h"
#import "LDProgressView.h"
#import "SelectGoodsNumViewController.h"


@implementation MallCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.width *= UIAdapteRate;
    self.contentView.height *= UIAdapteRate;
    self.width *= UIAdapteRate;
    self.height *= UIAdapteRate;
    
    
    [Tool UIAdapte:self.contentView deepth:1];
    
    
    _progressView.background = [UIColor colorFromHexString:@"ebebeb"];
    _progressView.color = [UIColor defaultRedButtonColor];
    [LDProgressView appearance].showBackgroundInnerShadow = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].showStroke = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].flat = @NO;
    [LDProgressView appearance].showText = @NO;
    _progressView.type = LDProgressSolid;
    
    UIColor *redColor = [UIColor whiteColor];
    
    UIButton *button = _joinButton;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = button.height*0.1;
//    button.layer.borderWidth = 0.5;
//    button.layer.borderColor = redColor.CGColor;
    [button setTitle:@"兑换" forState:UIControlStateNormal];
    [button setTitleColor:redColor forState:UIControlStateNormal];
    button.right = self.width- 11*UIAdapteRate;
    
    UILabel *label = _rightNumberLabel;
    label.textColor = redColor;
    
    label = _nameLabel;
    label.font = [UIFont systemFontOfSize:14 * UIAdapteRate];
    label.top = _imageView.bottom + 11;
    label.width = self.width - 2*label.left;
    
//    _imageView.height *= UIAdapteRate;
    
    
}

- (void)reloadWithObject:(GoodsFightModel *)model
{
    GoodsModel *goodsModel = model.goodsModel;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.good_header] placeholderImage:PublicImage(@"defaultImage")];
    _nameLabel.text = goodsModel.good_name;
    _leftNumberLabel.text = [NSString stringWithFormat:@"%ld小米",[model.good_single_price integerValue]];
    _rightNumberLabel.text = [NSString stringWithFormat:@"%d", [model remainderCount]];
    _progressView.progress = [model.progress intValue] / 100.0f;
}

@end
