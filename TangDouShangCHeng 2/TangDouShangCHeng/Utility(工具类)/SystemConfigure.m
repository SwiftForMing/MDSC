//
//  SystemConfigure.m
//  DuoBao
//
//  Created by clove on 11/16/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "SystemConfigure.h"

@implementation SystemConfigure

+ (SystemConfigure *)defaultConfigure
{
    SystemConfigure *configure = [ShareManager shareInstance].configure;
    return configure;
}

- (BOOL)shouldShowMall
{
    BOOL result = YES;
    
    if ([_is_happy_shop isEqualToString:@"n"]) {
        result = NO;
    }
    
    return result;
}

@end
