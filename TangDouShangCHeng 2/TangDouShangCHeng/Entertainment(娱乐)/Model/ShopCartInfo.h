//
//  ShopCartInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartInfo : NSObject


@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, assign) NSInteger good_single_price;
@property (nonatomic, strong) NSString *goods_buy_num;
@property (nonatomic, strong) NSString *goods_fight_id;
@property (nonatomic, strong) NSString *goods_id;
@property (nonatomic, strong) NSString *goods_type_name;
@property (nonatomic, strong) NSString *id ;
@property (nonatomic, assign) NSInteger need_people;
@property (nonatomic, assign) NSInteger now_people;
@property (nonatomic, strong) NSString *progress;
@property (nonatomic, strong) NSString *user_id;
@property(assign,nonatomic) BOOL selectState;//是否选中状态

//查看购买详情使用
@property (nonatomic, strong) NSString *good_period;

- (int)amountBuy;
- (NSArray *)recommendedPurchaseOptions;
@end
