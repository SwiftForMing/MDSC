//
//  BuyGoodModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/22.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyGoodModel : NSObject
/*
 "profit_price": 20,
 "id": 522860622586,
 "good_header": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1475915143151.jpg",
 "good_price": 6500,
 "buy_num": 1,
 "good_name": "iphone 6s  64g",
 "goods_type_id": "100195",
 "order_num": 987,
 "status": "n"
 */
@property (nonatomic, strong) NSString *coupons_value;
@property (nonatomic, strong) NSString *profit_price;
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *good_price;
@property (nonatomic, strong) NSString *buy_num;
@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *status;
@property (nonatomic, strong) NSString *good_name;
@property (strong, nonatomic) NSString *order_num;
@property (strong, nonatomic) NSString *goods_type_id;
@end
