//
//  ServerProtocol.m
//  DuoBao
//
//  Created by clove on 4/6/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ServerProtocol.h"

@implementation ServerProtocol


+ (NSString *)fights_counts:(NSArray *)thricePurchaseArray
{
    NSString *fights_counts = @"";
    
    for (NSDictionary *dict in thricePurchaseArray) {
        
        NSString *thriceType = [dict objectForKey:@"type"];
        NSString *thriceCount = [(NSNumber *)[dict objectForKey:@"count"] stringValue];
        
        fights_counts = [fights_counts stringByAppendingFormat:@"%@_", thriceCount];
    }
    
    if (fights_counts.length > 0) {
        fights_counts = [fights_counts substringToIndex:fights_counts.length-1];
    }
    
    return fights_counts;
}


+ (NSString *)fights_choices:(NSArray *)thricePurchaseArray
{
    NSString *fights_choices = @"";
    
    for (NSDictionary *dict in thricePurchaseArray) {
        
        NSString *thriceType = [dict objectForKey:@"type"];
//        NSString *thriceType = [[dict allKeys] firstObject];
        fights_choices = [fights_choices stringByAppendingFormat:@"%@_", thriceType];
    }
    
    if (fights_choices.length > 0) {
        fights_choices = [fights_choices substringToIndex:fights_choices.length-1];
    }
    
    return fights_choices;
}

+ (NSArray *)thriceBettingArrayWithData:(NSArray *)data
{
    NSMutableArray *array = [NSMutableArray array];

    for (NSDictionary *dictionary in data) {
        
        NSString *type = [dictionary objectForKey:@"fight_choice"];
        NSString *count = [dictionary objectForKey:@"fight_count_all"];
        
        NSDictionary *dict = @{
                               @"type":type?:@"",
                               @"count":count?:@""
                               };
        [array addObject:dict];
    }
    
    return array;
}

+ (NSString *)thricePrizeNumber:(NSDictionary *)dictionary
{
    NSString *win_num = [dictionary objectForKey:@"win_num"];
    NSString *str = [win_num substringFromIndex:win_num.length - 1];
    return str;
}

+ (float)progress:(NSDictionary *)dictionary
{
    float progress = 0.0f;
    
    int value = [[dictionary objectForKey:@"progress"] intValue];
    progress = value / 100.0f;
    
    if (progress > 1.01) {
        progress = 1.0f;
    }
    
    if (progress < -0.999) {
        progress = 0;
    }
    
    return progress;
}

// [第32期]50电话卡
+ (NSString *)periodAndGoodsName:(NSDictionary *)dictionary
{
    NSString *str = @"";
    
    NSString *goodsName = [dictionary objectForKey:@"good_name"];
    NSString *period = [dictionary objectForKey:@"good_period"];
    
    str = [NSString stringWithFormat:@"[第%@期]%@", period?:@"", goodsName?:@""];

    return str;
}

+ (int)remainderCrowdfundingTimes:(NSDictionary *)dict
{
    int count = 0;
    
    NSString *amount = [dict objectForKey:@"need_people"];
    NSString *current = [dict objectForKey:@"now_people"];
//    NSString *cardinalNumber = [dict objectForKey:@"good_single_price"];
    int remainder = [amount intValue] - [current intValue];
    count = remainder;
    
//    if (remainder > 0) {
//        count = remainder / [cardinalNumber intValue];
//    } else {
//        count = 0;
//    }
    
    return count;
}


@end
