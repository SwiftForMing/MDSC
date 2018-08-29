//
//  GetCouponOneCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "GetCouponOneCell.h"

@implementation GetCouponOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _getCouponBtn.layer.masksToBounds = YES;
    _getCouponBtn.layer.cornerRadius = 15;
    _getCouponBtn.layer.borderWidth = 1;
    _getCouponBtn.layer.borderColor = [UIColor colorFromHexString:@"5AD485"].CGColor;
}

-(void)setGoodModel:(HomeGoodModel *)goodModel{
    
    _couponNameLabel.text = goodModel.coupons_name;
    _couponGoodNameLabel.textColor = [UIColor colorFromHexString:@"7F7F7F"];
//    _couponGoodNameLabel.text  = goodModel.good_name;
    NSString *couponPrice =  [NSString stringWithFormat:@"售价￥%@",goodModel.coupons_price];
    
    NSString *giveBean =  [NSString stringWithFormat:@"  赠%d小米",[goodModel.coupons_price intValue]*BeanExchangeRate];
    NSString *coupon = [NSString stringWithFormat:@"%@%@",couponPrice,giveBean];
    //label的富文本
    NSMutableAttributedString *couponABS = [[NSMutableAttributedString alloc] initWithString:coupon];
    [couponABS addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"FD3D38"] range:[coupon rangeOfString:couponPrice]];
    [couponABS addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"FD9538"] range:[coupon rangeOfString:giveBean]];
    _couponPriceLabel.attributedText = couponABS;
//    _timeLabel.text = [NSString stringWithFormat:@"有效期：%@",goodModel.valid_date];
    _timeLabel.text = [NSString stringWithFormat:@"有效期：%@",[Tool getCurrentTime]];
    _timeLabel.textColor = [UIColor colorFromHexString:@"7F7F7F"];
    _goodModel = goodModel;
    
}

@end
