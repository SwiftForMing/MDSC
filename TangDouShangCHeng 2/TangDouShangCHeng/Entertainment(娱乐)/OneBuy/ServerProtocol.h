//
//  ServerProtocol.h
//  DuoBao
//
//  Created by clove on 4/6/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerProtocol : NSObject



// 三赔数据转换
+ (NSString *)fights_counts:(NSArray *)thricePurchaseArray;
+ (NSString *)fights_choices:(NSArray *)thricePurchaseArray;
+ (NSArray *)thriceBettingArrayWithData:(NSArray *)data;
+ (NSString *)thricePrizeNumber:(NSDictionary *)dictionary;


+ (float)progress:(NSDictionary *)dict;

// [第32期]50电话卡
+ (NSString *)periodAndGoodsName:(NSDictionary *)dictionary;

// 还需人次
+ (int)remainderCrowdfundingTimes:(NSDictionary *)dictionary;

@end
