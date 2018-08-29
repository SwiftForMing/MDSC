//
//  BuyCouponModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/22.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyCouponModel : NSObject
/*
 "good_id": "522860622586",
 "coupons_value": 20,
 "id": 1009,
 "buy_num": 1,
 "coupons_price": 5,
 "status": "y",
 "coupons_imge": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1475915143151.jpg",
 "coupons_name": "iphone 6s  64g优惠券"
 
 */
@property (nonatomic, strong) NSString *coupons_value;
@property (nonatomic, strong) NSString *good_id;
@property (nonatomic, strong) NSString *buy_num;
@property (nonatomic, strong) NSString *coupons_price;
@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *status;
@property (nonatomic, strong) NSString *coupons_imge;
@property (strong, nonatomic) NSString *coupons_name;
@end
