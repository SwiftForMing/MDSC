//
//  CouponsListInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/21.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsListInfo : NSObject

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *id ;
@property (nonatomic, strong) NSString *status ;
@property (nonatomic, assign) double ticket_condition;
@property (nonatomic, strong) NSString *ticket_name;
@property (nonatomic, assign) double ticket_value;
@property (nonatomic, strong) NSString *valid_date;
@property (nonatomic, strong) NSString *is_effct;
@property (nonatomic, strong) NSString *effct_time;
@property (nonatomic, strong) NSString *ticket_id;  //  ticket_id = GetForHappyBean, 标记为三赔可堆叠欢乐券
@property (nonatomic, strong) NSString *tickt_num;  //  三赔欢乐券堆叠个数


- (BOOL)isGoIntoEffect;

// 是否可使用，包括未使用，待生效
- (BOOL)isUsable;

- (BOOL)isThriceCoupon;

@end
