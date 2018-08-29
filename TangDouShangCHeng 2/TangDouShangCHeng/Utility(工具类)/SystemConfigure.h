//
//  SystemConfigure.h
//  DuoBao
//
//  Created by clove on 11/16/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PaySelectedData;

@interface SystemConfigure : NSObject
@property (nonatomic, assign) int cantVerifyVersion;
@property (nonatomic, copy) NSString *latestVersion;       // 服务器最新版本号

@property (nonatomic, strong) NSArray<PaySelectedData *> *paymentChannels;  //  当前服务器支持的支付方式
@property (nonatomic) double exchangeRate;      // 小米兑换比例
@property (nonatomic, copy) NSString *is_happy_shop;       // 首页菜单最后一个显示米豆商城 或者 邀请好友
@property (nonatomic, copy) NSString *show_qdc_status;
@property (nonatomic, copy) NSString *show_dwc_status; 
+ (SystemConfigure *)defaultConfigure;

// 首页菜单最后一个显示米豆商城 或者 邀请好友
- (BOOL)shouldShowMall;

@end
