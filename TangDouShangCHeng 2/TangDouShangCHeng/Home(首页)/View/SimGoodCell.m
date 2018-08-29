//
//  SimGoodCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "SimGoodCell.h"

@implementation SimGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setGoodModel:(HomeGoodModel *)goodModel{
    
    NSURL *url = [[NSURL alloc]initWithString:goodModel.good_header];
    [_goodImageView sd_setImageWithURL:url placeholderImage:nil];
    _goodNameLabel.text = goodModel.good_name;
//    _goodColorLabel.text = goodModel.
    _goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",goodModel.good_price];

}

-(void)setBuyModel:(BuyGoodModel *)buyModel{
    
    NSURL *url = [[NSURL alloc]initWithString:buyModel.good_header];
    [_goodImageView sd_setImageWithURL:url placeholderImage:nil];
    _goodNameLabel.text = buyModel.good_name;
    //    _goodColorLabel.text = goodModel.
    _goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",buyModel.good_price];
    _goodNumLabel.text = [NSString stringWithFormat:@"x%@",buyModel.buy_num];
}

-(void)setOrderModel:(OrderModel *)orderModel{

    NSURL *url = [[NSURL alloc]initWithString:orderModel.good_header];
    [_goodImageView sd_setImageWithURL:url placeholderImage:nil];
    _goodNameLabel.text = orderModel.good_name;
    //    _goodColorLabel.text = goodModel.
    _goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.pay_money];

}
@end
