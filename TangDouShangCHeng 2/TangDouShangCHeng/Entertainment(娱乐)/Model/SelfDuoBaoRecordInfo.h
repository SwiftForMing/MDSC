//
//  SelfDuoBaoRecordInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelfDuoBaoRecordInfo : NSObject

@property (nonatomic, strong) NSString *count_num;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *good_period;
@property (nonatomic, strong) NSString *id ;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *need_people;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *now_people;
@property (nonatomic, strong) NSString *progress;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *win_fight_time;
@property (nonatomic, strong) NSString *win_num;
@property (nonatomic, strong) NSString *win_user_id;
@property (nonatomic, strong) NSString *part_sanpei;
@property (nonatomic, strong) NSArray *sanpeiRecordList;



- (int)remainderCount;
- (BOOL)amWinLottery;
- (BOOL)hasWinThrice;
- (BOOL)hasBettingThrice;
- (BOOL)isThriceGoods;
- (NSString *)thricePrizeNumber;

@end
