//
//  RecoverAddressListInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "RecoverAddressListInfo.h"

@implementation RecoverAddressListInfo

- (NSString *)address
{
    NSString *str = @"";
    
    if (self.province_name.length > 0) {
        str = [str stringByAppendingString:self.province_name];
    }
    
    if (self.city_name.length > 0) {
        str = [str stringByAppendingString:self.city_name];
    }
    
    if (self.detail_address.length > 0) {
        str = [str stringByAppendingString:self.detail_address];
    }
    
    return str;
}

- (NSString *)province_name
{
    NSString *str = _province_name;
    
    if ([str isEqualToString:@"<null>"]) {
        str = nil;
    }
    
    return str;
}

- (NSString *)detail_address
{
    NSString *str = _detail_address;
    
    if ([str isEqualToString:@"<null>"]) {
        str = nil;
    }
    
    return str;
}

- (NSString *)city_name
{
    NSString *str = _city_name;
    
    if ([str isEqualToString:@"<null>"]) {
        str = nil;
    }
    
    return str;
}

@end
