//
//  GoodsListInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsDetailInfo.h"

@interface GoodsListInfo : NSObject

@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_id;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *good_period;
@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *progress;
@property (strong, nonatomic) NSString *good_single_price;
@property (assign, nonatomic) NSInteger now_people;
@property (assign, nonatomic) NSInteger need_people;
@property (strong, nonatomic) NSString *part_sanpei;
@property (assign, nonatomic) int buynum;
@property(assign,nonatomic) BOOL selectState;//是否选中状态

- (GoodsDetailInfo *)covertToGoodsDetailInfo;
- (BOOL)isThriceGoods;

- (NSDictionary *)dictionary;

@end
