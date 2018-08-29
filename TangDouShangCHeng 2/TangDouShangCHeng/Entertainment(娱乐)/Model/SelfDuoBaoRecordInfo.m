//
//  SelfDuoBaoRecordInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SelfDuoBaoRecordInfo.h"

@implementation SelfDuoBaoRecordInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

- (NSString *)win_num
{
    NSString *str = _win_num;
    
    if ([str isEqualToString:@"<null>"]) {
        str = @"";
    }
    
    return str;
}

- (int)remainderCount
{
    int amount = [_need_people intValue];
    int currentCount = [_now_people intValue];
    int remainder = amount - currentCount;
    return remainder < 0 ? 0 : remainder;
}

- (BOOL)amWinLottery
{
    BOOL result = NO;
    
    NSString *myUserID = [ShareManager shareInstance].userinfo.id;
    if (myUserID != nil && [myUserID isEqualToString:_win_user_id]) {
        result = YES;
    }
    
    return result;
}

//- (float)progress
//{
//    float progress = 0.0f;
//    
//    int amount = [_need_people intValue];
//    int currentCount = [_now_people intValue];
//    if (currentCount == 0) {
//        progress = 0.0f;
//    } else {
//        progress = currentCount * 1.0f/ amount;
//    }
//    
//    return progress;
//}

- (BOOL)hasWinThrice
{
    BOOL result = NO;
    
    NSArray *array = _sanpeiRecordList;
    if (array.count > 0) {
        NSString *prizeNumber = [self thricePrizeNumber];
        int prizeType = [prizeNumber intValue] % 3;
        NSArray *thriceBettingArray = [ServerProtocol thriceBettingArrayWithData:array];
        
        for (NSDictionary *bettingDict in thriceBettingArray) {
            NSString *str = [bettingDict objectForKey:@"type"];
            int type = [str intValue];
            if (type == prizeType) {
                result = YES;
                break;
            }
        }
    }
    
    return result;
}

- (BOOL)isThriceGoods
{
    BOOL result = NO;
    
    if ([_part_sanpei isEqualToString:@"y"]) {
        result = YES;
    }
    
    return result;
}

- (NSString *)thricePrizeNumber
{
    NSString *win_num = _win_num;
    NSString *str = [win_num substringFromIndex:win_num.length - 1];
    return str;
}

- (BOOL)hasBettingThrice
{
    BOOL result = NO;
    if (_sanpeiRecordList.count > 0) {
        result = YES;
    }
    
    return result;
}

@end
