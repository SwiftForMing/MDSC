//
//  RecoverAddressListInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecoverAddressListInfo : NSObject
/*
 "city_id" = 257;
 "city_name" = "\U6210\U90fd\U5e02";
 "create_time" = 1505378037000;
 "detail_address" = "\U5929\U5e9c\U4e09\U8857";
 id = 10003;
 "is_default" = y;
 "province_id" = 23;
 "province_name" = "\U56db\U5ddd\U7701";
 "user_id" = 1215116;
 "user_name" = "\U9ece\U5e94\U660e";
 "user_tel" = 15309015564;
 
 */
@property (nonatomic, strong) NSString *province_id;
@property (nonatomic, strong) NSString *is_default;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *province_name;
@property (nonatomic, strong) NSString *detail_address;
@property (nonatomic, strong) NSString *city_id;
@property (nonatomic, strong) NSString *city_name;
@property (nonatomic, strong) NSString *user_tel;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *create_time;


- (NSString *)address;

@end
