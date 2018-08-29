//
//  ZJRecordListInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZJRecordListInfo : NSObject

// 收货地址
@property (nonatomic, strong) NSString *confirm_adress;
@property (nonatomic, strong) NSString *consignee_address;
@property (nonatomic, strong) NSString *consignee_name;
@property (nonatomic, strong) NSString *consignee_tel;

// 物流信息
@property (nonatomic, strong) NSString *courier_id;
@property (nonatomic, strong) NSString *courier_name;

@property (nonatomic, strong) NSString *count_num;
@property (nonatomic, strong) NSString *good_fight_id;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *good_period;
@property (nonatomic, strong) NSString *is_bask;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_status;
@property (nonatomic, strong) NSString *need_people;
@property (nonatomic, strong) NSString *win_num;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *goodvalues;     //如果是虚拟商品才有。虚拟商品价值
@property (nonatomic, strong) NSString *get_type;       //获得方式（兑换小米，兑换充值卡）
@property (nonatomic, strong) NSString *goods_type;     //是否虚拟商品（虚拟商品、物流商品）
@property (nonatomic, copy) NSArray *rechargeList;      //充值卡卡密列表
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *win_user_id;
@property (nonatomic, strong) NSString *part_sanpei;
@property (nonatomic, strong) NSArray *sanpeiRecordList;
@property (nonatomic, strong) NSString *receivor_confirm;
@property (nonatomic, strong) NSString *thriceOrderID;  // 三赔中奖订单ID
@property (nonatomic, strong) NSString *thriceOrderStatus;  // 三赔中奖订单status
@property (nonatomic, strong) NSString *get_beans;
@property (nonatomic, strong) NSString *donor_user_id;
@property (nonatomic, strong) NSString *create_time;
@property(assign,nonatomic) BOOL selectState;//是否

- (BOOL)isVirtualGoods;
- (NSString *)goodsStatus;
- (BOOL)onlyOneRecharge;
- (int)cardCount;

- (NSString *)firstCardNumber;
- (NSString *)firstCardPassword;

- (BOOL)hasBettingThrice;
- (BOOL)isThriceGoods;
- (NSString *)thricePrizeNumber;
- (BOOL)hasWinThrice;
- (BOOL)hasWinCrowdfunding;
- (BOOL)hasAcceptWinningThirceCoin;

@end

//id = 522860623694;
//"lottery_time" = "2016-03-20 20:22:50";
//"need_people" = 20;
//"order_id" = 1000001545;
//"order_status" = "\U5f85\U53d1\U8d27";
//"win_num" = 10000014;
