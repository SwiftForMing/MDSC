//
//  OrderModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/19.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
/*
 "good_id": "522860622586",
 "courier_id": null,
 "type": "b",
 "create_time": "2017-09-19 11:13",
 "user_id": "20017",
 "express_name": "免邮",
 "profit_price": 20,
 "consignee_tel": "17710105050",
 "courier_name": null,
 "good_name": "iphone 6s  64g",
 "pay_money": 6500,
 "good_price": 6500,
 "status": "待发货",
 "consignee_address": "成都 天府三街",
 "pay_status": "已支付",
 "buy_num": 1,
 "goods_Price": 6500,
 "goods_type_id": "100195",
 "remark": "白色",
 "good_header": ",
 "coupons_price": 0,
 "consignee_name": "selfim",
 "express_price": 0,
 "good_imgs": "",
 "coupons_ids": "'1'",
 "id": "z4U4EFapluPLFXDRsJpj",
 "order_num": 987,
 "love_num": 0
 */
@property (nonatomic, strong) NSString *confirm_good;

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *consignee_address;
@property (nonatomic, strong) NSString *buy_num;
@property (nonatomic, strong) NSString *consignee_tel;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *courier_name;
@property (nonatomic, strong) NSString *good_price;
@property (nonatomic, strong) NSString *consignee_name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *express_name;
@property (nonatomic, strong) NSString *pay_status;
@property (nonatomic, strong) NSString *pay_money;
@property (nonatomic, strong) NSString *good_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *coupons_price;
@property (nonatomic, strong) NSString *express_price;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *coupons_ids;
@property (nonatomic, strong) NSString *courier_id;
@property (nonatomic, strong) NSString *profit_price;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *goods_type_id;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_imgs;
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *love_num;

@property (nonatomic, strong) NSString *retoure_type;
@end
