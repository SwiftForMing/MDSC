//
//  JieXiaoInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JieXiaoInfo : NSObject

@property (nonatomic, strong) NSString *daojishi_message;
@property (nonatomic, strong) NSString *daojishi_time;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_show_daojishi;
@property (nonatomic, strong) NSString *lottery_time;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *part_sanpei;

- (BOOL)isThriceGoods;
@end
