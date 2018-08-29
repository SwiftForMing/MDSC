//
//  radioInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "radioInfo.h"

@implementation RadioInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

@end
