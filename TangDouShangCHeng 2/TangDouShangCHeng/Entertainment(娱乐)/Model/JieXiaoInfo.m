//
//  JieXiaoInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "JieXiaoInfo.h"

@implementation JieXiaoInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

- (BOOL)isThriceGoods
{
    BOOL result = NO;
    
    if ([_part_sanpei isEqualToString:@"y"]) {
        result = YES;
    }
    
    return result;
}

@end
