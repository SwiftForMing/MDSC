//
//  HomeTopCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/5.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "HomeTopCell.h"

@implementation HomeTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _lqBtn.layer.masksToBounds = YES;
//    _lqBtn.layer.cornerRadius = 5;
    
    _getBtn.layer.masksToBounds = YES;
    _getBtn.layer.cornerRadius = 3;
    _goodImage.layer.masksToBounds = YES;
    _goodImage.layer.cornerRadius = 10;
//    _getBtn.layer.borderWidth = 1;
//    _getBtn.backgroundColor = [UIColor colorFromHexString:@"ff3c4c"];
    
//    if (ScreenWidth == 375) {
//      _headerWidth.constant = 100;
//        _headerHeight.constant = 100;
//    }
//    if (ScreenWidth < 375) {
//        _headerX.constant = 30;
//        _headerWidth.constant = 80;
//        _headerHeight.constant = 80;
//    }
}


-(void)setCouPonModel:(HomeGoodModel *)couPonModel{
    
    NSURL *url = [[NSURL alloc]initWithString:couPonModel.good_header];

    _getBtn.hidden = YES;
    [_goodImage sd_setImageWithURL:url placeholderImage:nil];
    _couponNameLabel.text = couPonModel.coupons_name;
    _goodNaLabel.text = couPonModel.good_name;

    NSString *price =  [NSString stringWithFormat:@"券后价￥%@ ",couPonModel.after_coupons_price];
    NSString *normalPrice =  [NSString stringWithFormat:@"￥%@",couPonModel.good_price];
    
    //label的富文本
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:normalPrice];
    [text1 addAttributes:@{
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick),
                           
                           NSForegroundColorAttributeName:
                               
                               [UIColor colorFromHexString:@"333333"],
                           
                           NSBaselineOffsetAttributeName:
                               
                               @(0),
                           
                           NSFontAttributeName: [UIFont systemFontOfSize:10]
                           
                           } range:[normalPrice rangeOfString:normalPrice]];
    NSMutableAttributedString *allPriceAstr = [[NSMutableAttributedString alloc]initWithString:price];
    [allPriceAstr addAttributes:@{
                                  NSFontAttributeName:[UIFont systemFontOfSize:10],
                                  NSForegroundColorAttributeName:[UIColor colorFromHexString: @"333333"]
                                  } range:[price rangeOfString:price]];
    [allPriceAstr appendAttributedString:text1];
    //    _priceLabel.attributedText = allPriceAstr;
    
    _goodPriceLabel.attributedText = allPriceAstr;

    _couponPrLabel.text = [NSString stringWithFormat:@"有效期：%@",couPonModel.valid_date];
    _couponPrLabel.font = [UIFont systemFontOfSize:10];
    _couponPrLabel.textColor = [UIColor colorFromHexString: @"333333"];
    _couPonModel = couPonModel;
    
}


-(void)setGoodModel:(HomeGoodModel *)goodModel{
    
    NSURL *url = [[NSURL alloc]initWithString:goodModel.good_header];
    
    [_goodImage sd_setImageWithURL:url placeholderImage:nil];
    _couponNameLabel.text = goodModel.coupons_name;
    _goodNaLabel.text = goodModel.good_name;

    NSString *price =  [NSString stringWithFormat:@"券后价￥%@ ",goodModel.after_coupons_price];
    NSString *normalPrice =  [NSString stringWithFormat:@"￥%@",goodModel.good_price];
    
    //label的富文本
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:normalPrice];
    [text1 addAttributes:@{
                         NSStrikethroughStyleAttributeName:@(NSUnderlineStyleThick),
                         
                         NSForegroundColorAttributeName:
                             [UIColor colorFromHexString:@"C7C7CD"],
                         
                         NSBaselineOffsetAttributeName:
                             
                             @(0),
                         
                         NSFontAttributeName: [UIFont systemFontOfSize:14]
                         
                         } range:[normalPrice rangeOfString:normalPrice]];
    NSMutableAttributedString *allPriceAstr = [[NSMutableAttributedString alloc]initWithString:price];
    [allPriceAstr addAttributes:@{
                                  NSFontAttributeName:[UIFont systemFontOfSize:14],
                                  NSForegroundColorAttributeName:
                                      [UIColor colorFromHexString:@"fd2b3c"]
                     } range:[price rangeOfString:price]];
    [allPriceAstr appendAttributedString:text1];
    
    _goodPriceLabel.attributedText = allPriceAstr;
    
//    NSString *couponPrice =  [NSString stringWithFormat:@"%@",goodModel.coupons_price];
    NSString *giveBean =  [NSString stringWithFormat:@"赠送%d小米", [goodModel.coupons_price intValue]*BeanExchangeRate];
    
    NSString *coupon = [NSString stringWithFormat:@"%@",giveBean];
    //label的富文本
    NSMutableAttributedString *couponABS = [[NSMutableAttributedString alloc] initWithString:coupon];
    
//    [couponABS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[coupon rangeOfString:couponPrice]];
//    [couponABS  addAttributes:@{
//                                NSForegroundColorAttributeName:
//                                    [UIColor redColor],
//                                NSFontAttributeName: [UIFont systemFontOfSize:10]
//
//                                } range:[coupon rangeOfString:@"￥"]];
    
    [couponABS  addAttributes:@{
                                NSForegroundColorAttributeName:
                                    [UIColor redColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:14]
                                
                                } range:[coupon rangeOfString:goodModel.coupons_price]];
    
    [couponABS  addAttributes:@{
                                NSForegroundColorAttributeName:
                                    [UIColor colorFromHexString:@"FD9538"],
                                NSFontAttributeName: [UIFont systemFontOfSize:14]
                                
                                } range:[coupon rangeOfString:giveBean]];
    
    _couponPrLabel.attributedText = couponABS;
    
    _goodModel = goodModel;
    
}


@end
