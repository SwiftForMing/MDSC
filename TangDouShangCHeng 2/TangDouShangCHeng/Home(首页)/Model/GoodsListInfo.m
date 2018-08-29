//
//  GoodsListInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsListInfo.h"

@implementation GoodsListInfo


- (GoodsDetailInfo *)covertToGoodsDetailInfo
{
    GoodsDetailInfo *object = [[GoodsDetailInfo alloc] init];
    object.good_header = self.good_header;
    object.good_id = self.good_id;
    object.good_name = self.good_name;
    object.good_period = self.good_period;
    object.id = self.id;
    object.progress = self.progress;
    object.good_single_price = self.good_single_price;
    object.now_people = [NSString stringWithFormat:@"%ld", self.now_people];
    object.need_people = [NSString stringWithFormat:@"%ld", self.need_people];

    return object;
}

- (BOOL)isThriceGoods
{
    BOOL result = NO;
    
    if ([_part_sanpei isEqualToString:@"y"]) {
        result = YES;
    }
    
    return result;
}

- (NSDictionary *)dictionary
{
    NSString *need_people = [NSString stringWithFormat:@"%ld", self.need_people];
    NSString *now_people = [NSString stringWithFormat:@"%ld", self.now_people];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict setObject:self.good_header?:@"" forKey:@"good_header"];
    [dict setObject:self.good_period?:@"" forKey:@"good_period"];
    [dict setObject:self.good_id?:@"" forKey:@"good_id"];
    [dict setObject:self.good_name?:@"" forKey:@"good_name"];
    [dict setObject:self.good_single_price?:@"" forKey:@"good_single_price"];
    [dict setObject:self.progress?:@"" forKey:@"progress"];
    [dict setObject:need_people?:@"" forKey:@"need_people"];
    [dict setObject:now_people?:@"" forKey:@"now_people"];
    [dict setObject:self.part_sanpei?:@"" forKey:@"part_sanpei"];
    [dict setObject:self.id?:@"" forKey:@"id"];

    return dict;
}



@end
