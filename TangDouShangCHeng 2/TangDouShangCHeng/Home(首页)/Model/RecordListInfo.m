//
//  RecordListInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "RecordListInfo.h"

@implementation RecordListInfo

- (NSString *)type
{
    NSString *str = _type;
    str = [str stringByReplacingOccurrencesOfString:@"(mp)" withString:@""];
    
    return str;
}

@end
