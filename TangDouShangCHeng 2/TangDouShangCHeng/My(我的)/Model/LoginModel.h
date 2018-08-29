//
//  LoginModel.h
//  DuoBao
//
//  Created by clove on 3/6/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property (nonatomic, copy) NSString *userID;

/**
 *  每一次访问刷新登录token，最后一次访问三十分钟后，token失效
 */
@property (nonatomic, copy) NSDate *lastAccessDate;

+ (void)refreshToken;
+ (BOOL)validateToken;


@end
