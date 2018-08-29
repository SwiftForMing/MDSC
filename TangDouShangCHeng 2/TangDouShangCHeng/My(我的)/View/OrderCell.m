//
//  OrderCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/19.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setOrderModel:(OrderModel *)orderModel{
    
    NSURL *imageUrl = [[NSURL alloc]initWithString:orderModel.good_header];
    [_goodImgView sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    _goodNameLabel.text = orderModel.good_name;
    
    _goodColorLabel.text = orderModel.remark;
    
    _goodPriceLable.text = [NSString stringWithFormat:@"¥%@",orderModel.good_price];
    _payPriceLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.pay_money];
    _payPriceLabel.textColor = [UIColor redColor];
    _payPriceLabel.font = [UIFont systemFontOfSize:18];
    _numLabel.text = [NSString stringWithFormat:@"x%@",orderModel.buy_num];
    
    if ([orderModel.coupons_price isEqualToString:@"0"]) {
    
        _useCouponLabel.hidden = YES;
    }else{
        _useCouponLabel.hidden = NO;
    }
    
    _statusLabel.text = orderModel.status;
    if ([orderModel.status isEqualToString:@"待发货"]) {
        _statusLabel.textColor = [UIColor greenColor];

    }else{
        _statusLabel.textColor = [UIColor blackColor];
    }
    

}

@end
