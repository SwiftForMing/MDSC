//
//  HaveCouponCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "HaveCouponCell.h"

@implementation HaveCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBuyCouponModel:(BuyCouponModel *)buyCouponModel{
    
    _couponNameLabel.text = buyCouponModel.coupons_name;

}


-(void)setGoodModel:(HomeGoodModel *)goodModel{
    
    _leftLabel.text = @"请选择付款方式";
    _leftLabel.font = [UIFont systemFontOfSize:14];
    _arrowImageView.hidden = YES;
    NSString * price = [NSString stringWithFormat:@"共计 %@元",goodModel.good_price];
    NSMutableAttributedString *aPrice = [[NSMutableAttributedString alloc]initWithString:price];
    [aPrice addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[price rangeOfString:[NSString stringWithFormat:@" %@元",goodModel.good_price]]];
    _couponNameLabel.attributedText = aPrice;
    
}

@end
