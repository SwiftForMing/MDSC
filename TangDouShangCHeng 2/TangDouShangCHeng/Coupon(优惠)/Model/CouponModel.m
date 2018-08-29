//
//  CouponModel.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel
-(HomeGoodModel*)setHomeGoodMode{
    HomeGoodModel *model = [[HomeGoodModel alloc]init];
    model.id = self.id;
    
    model.coupons_id = self.coupons_id;
    
    model.coupons_type = self.coupons_type;
    
    model.coupons_name = self.coupons_name;
    
    model.coupons_value = self.coupons_value;
    
    model.order_num = self.order_num;
    
    model.status = self.status;
    
    model.valid_date = self.valid_date;
    
    
    model.good_name = self.good_name;
    
    model.good_header = self.good_header;
    
    model.after_coupons_price = self.after_coupons_price;
    
    model.goods_type_id = self.goods_type_id;
    
    model.good_price = self.good_price;
    
    model.profit_price = self.profit_price;
    
    model.coupons_condition = self.coupons_condition;
    
    model.good_imgs = self.good_imgs;
    
    model.coupons_price = self.coupons_price;
    
//    model.content_imgs = self.content_imgs;
//    
//    model.good_details = self.good_details;
//    
//    model.good_option = self.good_option;
    
    return model;
}
@end
