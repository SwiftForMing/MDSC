//
//  HomeGoodModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/5.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGoodModel : NSObject
/*
 "id": 522860622579,
 "good_price": 159,
 "coupons_id": "1002",
 "profit_price": 20,
 "goods_type_id": "100194",
 "good_header": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474988582254.jpg",
 "good_name": "1箱8袋 | 百草味 在一起礼盒 坚果干果零食大礼包",
 "order_num": 900,
 "coupons_name": "1箱8袋 | 百草味 在一起礼盒 坚果干果零食大礼包 优惠券",
 "valid_date": 1893427200000,
 "after_coupons_price": 139,
 "coupons_value": 20,
 "coupons_status": "y",
 "status": "n",
 "coupons_type": "1",
 "coupons_condition": 200
 good_imgs
 */
@property (nonatomic, strong) NSString *id;
@property (nonatomic,strong) NSString *good_imgs;
@property (nonatomic,strong) NSString *coupons_price;
@property (nonatomic, strong) NSString *good_price;
@property (nonatomic, strong) NSString *coupons_id;
@property (nonatomic, strong) NSString *profit_price;
@property (nonatomic, strong) NSString *goods_type_id;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *coupons_name;
@property (nonatomic, strong) NSString *valid_date;
@property (nonatomic, strong) NSString *after_coupons_price;
@property (nonatomic, strong) NSString *coupons_value;
@property (nonatomic, strong) NSString *coupons_status;
@property (nonatomic, strong) NSString *coupons_type;
@property (nonatomic, strong) NSString *coupons_condition;
@property (nonatomic, strong) NSString *status;

@end
