//
//  GoodsDetailInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsDetailInfo.h"
#import "NSDate+YYAdd.h"

@implementation WinUserInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

@end

@implementation GoodsDetailInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

- (int)remainderCount
{
    int remainderCount =  [_need_people intValue]-[_now_people intValue];
    return remainderCount;
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

- (int)defaultPurchaseCount    // 默认购买次数
{
    int defaultPurchaseCount = 1;
    
    int amountCount = [_need_people intValue];
    
            if (amountCount < 100) {
                if (amountCount < 5) {
                    defaultPurchaseCount = 1;
                }else{
                  defaultPurchaseCount = 5;
                }
            }
            if (amountCount > 100) {
                defaultPurchaseCount = 10;
                
            }
            if (amountCount>300) {
                defaultPurchaseCount = 30;
                
            }
    
            if (amountCount > 500) {
                defaultPurchaseCount = 50;
                
            }
    
            if (amountCount > 1000) {
                defaultPurchaseCount = 100;
                
            }
            if (amountCount > 3000) {
                defaultPurchaseCount = 300;
                
            }
    
            if (amountCount > 10000) {
                defaultPurchaseCount = 500;
                
            }
            if (amountCount > 20000) {
            defaultPurchaseCount = 1000;
        
            }
    
    defaultPurchaseCount = defaultPurchaseCount < [self minCount] ? [self minCount] : defaultPurchaseCount;
    
    return defaultPurchaseCount;
}

- (NSArray *)recommendedPurchaseOptions    // 推荐购买选项
{
    NSArray *array = @[@"5", @"10", @"15", @"20"];
    
    int amountCount = [_need_people intValue];

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

// 中午12：00的那一场活动
- (int)isFirstActivity
{
    int i=0;
    if (_start_time.length > 0 && [_start_time isEqualToString:@"21:30:30"]) {
        i = 1;
    }
    
    return i;
}

- (NSInteger)countdownSeconds
{
    NSInteger countdownSeconds = 0;
    NSDate *date = [NSDate date];
    
    NSString *yyyyMMdd = [date stringWithFormat:@"yyyyMMdd"];
    NSString *timeStr = [yyyyMMdd stringByAppendingString:_start_time];
    NSDate *startDate = [NSDate dateWithString:timeStr format:@"yyyyMMddHH:mm:ss"];
    
    countdownSeconds = [startDate secondsAfterDate:date];
    
    return countdownSeconds;
}

- (NSString *)firstImage
{
    NSString  *str = nil;
    
    str = [[_good_imgs componentsSeparatedByString:@","] firstObject];
    return str;
}

- (NSString *)goodsNameWithoutFreePurchase
{
    NSString *originalGoodName = _good_name;
    NSString *goodsName = [originalGoodName stringByReplacingOccurrencesOfString:@"[零元购]" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"【零元购】" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"(零元购)" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"[0元购]" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"【0元购】" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"(0元购)" withString:@""];
    
    return goodsName;
}

- (NSDictionary *)dictionary
{
//    NSString *need_people = [NSString stringWithFormat:@"%ld", self.need_people];
//    NSString *now_people = [NSString stringWithFormat:@"%ld", self.now_people];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:self.good_header?:@"" forKey:@"good_header"];
    [dict setObject:self.good_period?:@"" forKey:@"good_period"];
    [dict setObject:self.good_id?:@"" forKey:@"good_id"];
    [dict setObject:self.good_name?:@"" forKey:@"good_name"];
    [dict setObject:self.good_single_price?:@"" forKey:@"good_single_price"];
    [dict setObject:self.progress?:@"" forKey:@"progress"];
    [dict setObject:self.need_people?:@"" forKey:@"need_people"];
    [dict setObject:self.now_people?:@"" forKey:@"now_people"];
    [dict setObject:self.part_sanpei?:@"" forKey:@"part_sanpei"];
    [dict setObject:self.id?:@"" forKey:@"id"];
    
    return dict;
}


@end

@implementation NextDuoBaoInfo

@end
