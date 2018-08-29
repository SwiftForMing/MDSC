//
//  CouponsListInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CouponsListInfo.h"

@implementation CouponsListInfo

- (BOOL)isGoIntoEffect
{
    BOOL result = NO;
    
    if ([_is_effct isEqualToString:@"y"]) {
        result = YES;
    }
    
    return result;
}

- (BOOL)isUsable
{
    BOOL result = NO;
    
    if ([_status isEqualToString:@"未使用"]) {
        result = YES;
    }
    
    return result;
}

- (BOOL)isThriceCoupon
{
    BOOL result = NO;
    
    if ([_ticket_id isEqualToString:@"GetForHappyBean"]) {
        result = YES;
    }
    
    return result;
}

@end
