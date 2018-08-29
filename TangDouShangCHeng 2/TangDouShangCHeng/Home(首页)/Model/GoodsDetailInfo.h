//
//  GoodsDetailInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinUserInfo : NSObject

@property (nonatomic, strong) NSString *user_ip;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *fight_time;
@property (nonatomic, strong) NSString *user_header;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *user_ip_address;

@end

@interface NextDuoBaoInfo : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *good_period;
@end


@interface GoodsDetailInfo : NSObject
@property (nonatomic, assign) int buyNum;
@property (nonatomic, strong) NSString *click_num;
@property (nonatomic, strong) NSString *content ;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *daojishi_message;
@property (nonatomic, strong) NSString *daojishi_time;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_href;
@property (nonatomic, strong) NSString *good_id;                // 商品ID
@property (nonatomic, strong) NSString *good_imgs;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *good_period;
@property (nonatomic, assign) double good_price;
@property (nonatomic, strong) NSString *good_single_price;
@property (nonatomic, strong) NSString *goods_type_id;
@property (nonatomic, strong) NSString *id;                     // 商品上架ID
@property (nonatomic, strong) NSString *is_bask;
@property (nonatomic, strong) NSString *is_get_caipiao;
@property (nonatomic, strong) NSString *is_next;
@property (nonatomic, strong) NSString *is_show_daojishi;
@property (nonatomic, strong) NSString *lottery_num_id;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *need_people;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NextDuoBaoInfo *next_fight;
@property (nonatomic, strong) NSString *now_people;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *progress;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *part_sanpei;

@property (nonatomic, strong) NSString *win_num;
@property (nonatomic, strong) NSString *win_user_id;
@property (nonatomic, strong) WinUserInfo *win_user;

//最新揭晓
@property (nonatomic, strong) NSString *play_num;

- (int)remainderCount;
- (int)minCount;
- (int)maxCount;


- (int)defaultPurchaseCount;    // 默认购买次数
- (NSArray *)recommendedPurchaseOptions;    // 推荐购买选项


// 0元购
@property (nonatomic, strong) NSString *current_desc;
@property (nonatomic, strong) NSString *one_time_num;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, strong) NSString *is_free_good;   // 0元购标记

- (NSDictionary *)dictionary;


// 中午12：00的那一场活动
- (int)isFirstActivity;
- (NSInteger)countdownSeconds;
- (NSString *)firstImage;
- (NSString *)goodsNameWithoutFreePurchase;

@end
