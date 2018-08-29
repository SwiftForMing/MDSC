//
//  InviteModel.m
//  DuoBao
//
//  Created by clove on 12/19/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "InviteModel.h"

@implementation InviteModel


- (NSString *)remainderMoney
{
    return self.user_earnings;
}

- (NSString *)user_earnings
{
    return [self fixFloatString:_user_earnings];
}
- (NSString *)all_earnings
{
    return [self fixFloatString:_all_earnings];
}
- (NSString *)today_earnings
{
    return [self fixFloatString:_today_earnings];
}



- (NSString *)fixFloatString:(NSString *)str
{
    MLog(@"我要看看%@",str);
    float value = [str floatValue];
    NSString *fixed = [NSString stringWithFormat:@"%.2f", value];
    
    return fixed;
}

@end
