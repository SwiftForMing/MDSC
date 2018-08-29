//
//  BeanModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeanModel : NSObject
/*
 "good_header": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1480484295894.jpg",
 "bean_price": 5770,
 "goods_type_id": "100187",
 "good_name": "小米MIX 手机 全网通标配版",
 "id": 522860622727,
 "order_num": 950,
 "good_imgs": "http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1480484295949.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1480484295960.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1480484295981.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1480484295988.jpg,http://zhimalegou.oss-cn-shanghai.aliyuncs.com/FtpUpload/newsIntro/1480484296001.jpg"
 
 */
@property (nonatomic, strong) NSString *good_header;
@property (nonatomic, strong) NSString *bean_price;
@property (nonatomic, strong) NSString *goods_type_id;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *order_num;
@property (nonatomic, strong) NSString *good_imgs;


@end
