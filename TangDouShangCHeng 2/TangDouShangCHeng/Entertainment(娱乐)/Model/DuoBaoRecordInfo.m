//
//  DuoBaoRecordInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "DuoBaoRecordInfo.h"

@implementation DuoBaoRecordInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

- (NSString *)user_ip_address
{
    NSString *name = _user_ip_address;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"定位失败";
    }
    
    return name;
}

- (NSString *)user_ip
{
    NSString *name = _user_ip;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"";
    }
    
    return name;
}

@end
