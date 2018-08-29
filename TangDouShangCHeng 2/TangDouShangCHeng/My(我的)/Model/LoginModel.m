//
//  LoginModel.m
//  DuoBao
//
//  Created by clove on 3/6/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

+ (void)refreshToken
{
    [ShareManager refreshToken];
}


+ (BOOL)validateToken
{
    LoginModel *loginModel = [ShareManager shareInstance].loginModel;
    return [loginModel validateToken];
}

- (BOOL)validateToken
{
    BOOL result = YES;
    
    if (_lastAccessDate == nil) {
        
        _lastAccessDate = [NSDate date];
        result = NO;
    } else {
        
        NSDate *date = [NSDate date];
        NSInteger minutes = [_lastAccessDate minutesBeforeDate:date];
        
        if (minutes >= 30) {
            result = NO;
        }
    }
    
    return result;
}

@end
