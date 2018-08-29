//
//  BannerInfo.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerInfo : NSObject
/*
 "url": "http://zhima.h5h5h5.cn/GetTreasureAppSesame/appInterface/advertisementContentInfo.jhtml?id=1",
 "header": "http://download.v-ma.net/cj/GetTreasureAppWeiMa/newsIntro/1458269610247.jpg",
 "id": 1,
 "is_jump": "y",
 "title": "详情页面广告"
 */
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_jump;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *content_txt;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *title;

@end
