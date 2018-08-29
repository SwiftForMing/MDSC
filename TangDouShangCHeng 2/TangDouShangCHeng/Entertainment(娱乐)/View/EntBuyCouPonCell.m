//
//  EntBuyCouPonCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "EntBuyCouPonCell.h"

@implementation EntBuyCouPonCell{
    
    int num;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (ScreenWidth == 375) {
        _headerWidth.constant = 100;
        _headerHeight.constant = 100;
    }
    if (ScreenWidth < 375) {
        _headerWidth.constant = 80;
        _headerHeight.constant = 80;
    }
    [_leftBtn setImage:[UIImage imageNamed:@"decrease_selected"] forState:UIControlStateSelected];
     [_rightBtn setImage:[UIImage imageNamed:@"increase_selected"] forState:UIControlStateSelected];
}

-(void)setCouponModel:(CouponModel *)couponModel{
    
    NSURL *url = [[NSURL alloc]initWithString:couponModel.good_header];
    [_goodHeader sd_setImageWithURL:url placeholderImage:nil];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",couponModel.coupons_name];
    
    _goodNameLabel.text = [NSString stringWithFormat:@"赠送%ld小米",[couponModel.coupons_price integerValue]*BeanExchangeRate];
    _RMBLabel.text = [NSString stringWithFormat:@"¥%ld",(long)[couponModel.coupons_price integerValue]];

    _timeLabel.text = [Tool getCurrentTime];

    _timeLabel.textColor = [UIColor whiteColor];
    
    _numLabel.text = @"0";
    num = 0;
    [_leftBtn addTarget:self action:@selector(subNum) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    _couponModel = couponModel;
}

-(void)subNum{
    int value;
    if (num<=0) {
        num = 0;
        value = 0;
    }else{
        num -= 1;
        value = [_couponModel.coupons_price intValue]*(-1);
    }
    _numLabel.text = [NSString stringWithFormat:@"%d",num];
    [self.delegate sendValue:value Model:_couponModel];
}

-(void)addNum{
    int value;
    value = [_couponModel.coupons_price intValue];
    num ++;
    _numLabel.text = [NSString stringWithFormat:@"%d",num];

    [self.delegate sendValue:[_couponModel.coupons_price intValue] Model:_couponModel];
}
@end
