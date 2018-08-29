//
//  InviteModel.h
//  DuoBao
//
//  Created by clove on 12/19/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteModel : NSObject

@property (nonatomic, strong) NSString *all_earnings;       // 累计收益
@property (nonatomic, strong) NSString *today_earnings;     // 今日收益
@property (nonatomic, strong) NSString *friends_all;        // 好友总数
@property (nonatomic, strong) NSString *up_friend;          // 推荐人ID
@property (nonatomic, strong) NSString *user_earnings;      // 我的余额


- (NSString *)remainderMoney;


@end
