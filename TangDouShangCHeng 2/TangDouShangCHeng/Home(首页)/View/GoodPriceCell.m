//
//  GoodPriceCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "GoodPriceCell.h"

@implementation GoodPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodModel:(HomeGoodModel *)goodModel{

    _goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",goodModel.good_price];
//     _transPriceLabel.text = [NSString stringWithFormat:@"¥%@",goodModel.after_coupons_price];

}
@end
