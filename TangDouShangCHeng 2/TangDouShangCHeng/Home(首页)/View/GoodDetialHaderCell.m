//
//  GoodDetialHaderCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "GoodDetialHaderCell.h"

@implementation GoodDetialHaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _baoyouLabel.layer.masksToBounds = YES;
//    _baoyouLabel.layer.cornerRadius = 10;
    // Initialization code
}

-(void)setGoodModel:(HomeGoodModel *)goodModel{
    
//    NSArray *arr = [goodModel.good_imgs componentsSeparatedByString:@","];
//    NSString *urlStr = [arr objectAtIndex:0];
    NSURL *url = [[NSURL alloc]initWithString:goodModel.good_header];
    [_headerImageView sd_setImageWithURL:url placeholderImage:nil];
    
    _goonNameLabel.text = goodModel.good_name;
    NSString *price = [NSString stringWithFormat:@"原价¥%@ ",goodModel.good_price];
    NSString *after = goodModel.after_coupons_price;
    if (after == nil) {
        after = [NSString stringWithFormat:@"%ld",[goodModel.good_price integerValue]-[goodModel.coupons_value integerValue]];
    }
    NSString *afterPrice = [NSString stringWithFormat:@"券后价¥%@",after];
    
     NSMutableAttributedString *allPriceAstr = [[NSMutableAttributedString alloc]initWithString:price];

     [allPriceAstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:[price rangeOfString:price]];

    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:afterPrice attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    [allPriceAstr appendAttributedString:attr];
    
    _priceAllLabel.attributedText = allPriceAstr;
   
}

@end
