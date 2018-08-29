//
//  OrderAddressModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/22.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderAddressModel : NSObject

/*
 "is_default": "y",
 "city_name": "成都市",
 "user_id": "1215116",
 "province_name": "四川省",
 "province_id": "23",
 "user_tel": "15309015564",
 "create_time": 1505378037000,
 "detail_address": "天府三街",
 "city_id": "257",
 "id": 10003,
 "user_name": "黎应明"
 */
@property (nonatomic, strong) NSString *is_default;
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *create_time;
@property (strong, nonatomic) NSString *user_tel;
@property (nonatomic, strong) NSString *province_id;
@property (strong, nonatomic) NSString *detail_address;
@property (strong, nonatomic) NSString *city_id;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *user_name;

@end
