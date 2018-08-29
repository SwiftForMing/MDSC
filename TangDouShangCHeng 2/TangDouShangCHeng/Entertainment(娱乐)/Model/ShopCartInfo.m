//
//  ShopCartInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ShopCartInfo.h"

@implementation ShopCartInfo

- (int)amountBuy
{
    int number = [_goods_buy_num intValue];
    int amount = number * _good_single_price;
    
    return amount;
}

- (NSArray *)recommendedPurchaseOptions    // 推荐购买选项
{
    NSArray *array = @[@"5", @"10", @"15", @"20"];
    
    int amountCount = (int)_need_people;
    
    if (amountCount > 100) {
        array = @[@"5", @"10", @"20", @"50"];
    }
    if (amountCount > 1000) {
        array = @[@"50", @"100", @"200", @"300"];
    }
    
    if (amountCount > 10000) {
        array = @[@"50", @"100", @"200", @"500"];
    }
    
    if (amountCount <= 20) {
        array = @[@"3", @"4", @"5", @"8"];
    }
    
    return array;
}
@end
