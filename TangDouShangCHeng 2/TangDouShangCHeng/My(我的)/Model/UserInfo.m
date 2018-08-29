//
//  UserInfo.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserInfo.h"
#import "LKDBHelper.h"

@implementation UserInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    return name;
}

- (BOOL)hasAlias
{
    BOOL result = YES;
    NSString *name = _nick_name;
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        result = NO;
    }

    return result;
}

- (NSString *)user_header
{
    NSString *str = _user_header;
    if (str.length == 0 || [str isEqualToString:@"<null>"]) {
        str = nil;;
    }
    
    return str;
}

- (void)updateWithDictionary:(NSDictionary *)data
{
    UserInfo *temp = [data objectByClass:[UserInfo class]];
    _weixin_login_id = temp.weixin_login_id;
    _app_login_id = temp.app_login_id;
    _qq_login_id = temp.qq_login_id;
    _login_id = temp.login_id;

    [self saveToDB];
}

+ (NSURL *)avatarURL
{
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    NSURL *url = [NSURL URLWithString:userInfo.user_header];
    return url;
}

- (NSURL *)avatarURL
{
    NSString *str = self.user_header ?: @"";
    NSURL *url = [NSURL URLWithString:str];
    return url;
}


- (NSString *)payment_id
{
    return [self pretreatmentString:_payment_id];
}

- (NSString *)payment_name
{
    return [self pretreatmentString:_payment_name];
}


- (NSString *)pretreatmentString:(NSString *)originString
{
    NSString *str = originString;
    if (str.length == 0 || [str isEqualToString:@"<null>"]) {
        str = @"";
    }
    
    return str;
}

- (double)user_money
{
    double value = _user_money;
    if (value <= 0) {
        value = 0;
    }
    
    return value;
}

-(NSInteger)user_balance{
    NSInteger value = _user_balance;
    if (value <= 0) {
        value = 0;
    }
    
    return value;
    
}
- (double)happy_bean_num
{
    double value = _happy_bean_num;
    if (value <= 0) {
        value = 0;
    }
    
    return value;
}


@end
