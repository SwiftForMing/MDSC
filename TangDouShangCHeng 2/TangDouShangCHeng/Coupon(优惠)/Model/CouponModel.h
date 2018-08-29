//
//  CouponModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
/*
 "after_coupons_price" = 55;
 "coupons_condition" = 200;
 "coupons_id" = 1005;
 "coupons_name" = "3\U74f6\U7ec4\U5408\U88c5\U2009|\U2009\U65b0\U519c\U54e5 \U6df7\U5408\U5e72\U679c\U4ec1 200g/\U74f6 \U4f18\U60e0\U5238";
 "coupons_price" = 5;
 "coupons_type" = 1;
 "coupons_value" = 20;
 "effct_time" = "2017-01-01";
 "good_header" = "";
 "good_id" = 522860622582;
 "good_imgs" = "";
 "good_name" = "";
 "good_price" = 75;
 "goods_type_id" = 100195;
 id = Tply4wB37nP4kR6azhrR;
 "love_num" = 0;
 "order_num" = 764;
 "profit_price" = 20;
 status = "\U672a\U4f7f\U7528";
 "transfer_user" = "<null>";
 "use_date" = "<null>";
 "valid_date" = "2018-09-12 00:00";
 */






/*
 "coupons_condition": 200,
 "profit_price": 20,
 "coupons_name": "2016新茶上市 西湖牌明前特级西湖龙井茶叶250g礼盒装 绿茶春茶优惠券",
 "id": 522860622583,
 "order_num": 894,
 "coupons_price": 5,
 "love_num": 0,
 "valid_date": 1893427200000,
 "goods_type_id": "100195",
 "good_name": "2016新茶上市 西湖牌明前特级西湖龙井茶叶250g礼盒装 绿茶春茶",
 "coupons_value": 20,
 "after_coupons_price": 290,
 "coupons_type": "1",
 "good_imgs": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474992378333.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474992378341.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474992378359.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474992378371.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474992378392.jpg",
 "coupons_id": 1006,
 "good_price": 310,
 "good_header": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1474992378320.jpg"
 
 */

@property (nonatomic, strong) NSString * coupons_id;
@property (nonatomic, strong) NSString * coupons_type;
@property (nonatomic, strong) NSString * coupons_name;
@property (nonatomic, assign) NSString *coupons_value;
@property (nonatomic, strong) NSString * order_num;
@property (nonatomic, strong) NSString * effct_time;
@property (nonatomic, strong) NSString * good_id;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSString * transfer_user;
@property (nonatomic, strong) NSString * use_date;
@property (nonatomic, strong) NSString * valid_date;
@property (nonatomic, strong) NSString * love_num;
@property (nonatomic, strong) NSString * good_name;
@property (nonatomic, strong) NSString * good_header;
@property (nonatomic, assign) NSString * after_coupons_price;
@property (nonatomic, strong) NSString * goods_type_id;
@property (nonatomic, strong) NSString * good_price;
@property (nonatomic, strong) NSString * profit_price;
@property (nonatomic, strong) NSString * coupons_condition;
@property (nonatomic, strong) NSString * good_imgs;
@property (nonatomic, strong) NSString * coupons_price;

-(HomeGoodModel*)setHomeGoodMode;
@end
