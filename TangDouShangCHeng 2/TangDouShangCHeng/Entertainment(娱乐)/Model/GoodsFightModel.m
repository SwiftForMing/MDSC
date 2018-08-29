//
//  GoodsFightModel.m
//  DuoBao
//
//  Created by clove on 5/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "GoodsFightModel.h"

@implementation GoodsFightModel

+ (GoodsFightModel *)createWithDictionary:(NSDictionary *)dictionary
{
    GoodsFightModel *model = [dictionary objectByClass:[GoodsFightModel class]];
    GoodsModel *goodsModel = [dictionary objectByClass:[GoodsModel class]];
    goodsModel.good_id = model.id;
    model.goodsModel = goodsModel;
    
    return model;
}

- (int)cardinalNumber
{
    int value = [_good_single_price intValue];
    
    GoodsType goodsType = [self goodsType];
    if (goodsType == GoodsTypeThrice) {
        value *= BeanExchangeRate;
    }

    return value;
}

- (int)remainderCount
{
    int remainderCount =  [_need_people intValue]-[_now_people intValue];
    return remainderCount;
}

- (int)remainderCoin
{
//    int remainderCount = [self remainderCount];
//    int cardinalNumber = [self cardinalNumber];
    int value = (int)[_good_single_price integerValue];
    
    return value;
}

- (int)minCount
{
    //    int count = [_good_single_price intValue];
    return 1;
}

- (int)maxCount
{
    return [self remainderCount];
}

// 推荐购买选项
- (NSArray *)recommendedPurchaseOptions
{
    NSArray *array = @[@"1", @"1", @"1", @"1"];
    
    int amountCount = [_need_people intValue];
    
    if (amountCount > 100) {
        array = @[@"5", @"10", @"20", @"50"];
    }
    
    if (amountCount <= 20 && amountCount >= 8) {
        array = @[@"3", @"4", @"5", @"8"];
    }
    
    if (amountCount == 1) {
        array = @[@"1", @"1", @"1", @"1"];
    }
    
    return array;
}

// 货币单位  元／小米
- (NSString *)unitCurrency
{
    NSString *str = @"小米";
    
    GoodsType goodsType = [_is_happybean_goods intValue];
    
    if (goodsType == GoodsTypeThrice) {
        str = @"小米";
    }
    
    return str;
}

- (GoodsType)goodsType
{
    GoodsType goodsType = [_is_happybean_goods intValue];
    return goodsType;
}



@end
