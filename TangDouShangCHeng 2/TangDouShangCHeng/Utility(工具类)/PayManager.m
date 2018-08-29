//
//  PayManager.m
//  DuoBao
//
//  Created by clove on 2/4/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PayManager.h"
#import "MustPayHeader.h"

@interface PayManager ()<MustPayResultDelegate>
@property (nonatomic, strong) void (^completionBlock)(BOOL result, NSString *description,  NSDictionary *dict);
@property (nonatomic) int money;
@property (nonatomic) BOOL autoreturnHappened;

@end

@implementation PayManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [MustPaySDK sharedSingleton].delegate = nil;
        [MustPaySDK sharedSingleton].delegate = self;
        
        //你的支付界面要监听一个通知 示例代码：
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nispectOrder:) name:kNotificationMustpayCheck object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayNotification:) name:kWeiXinPayNotif object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayNotification:) name:kAlipayNotification object:nil];
    }
    
    return self;
}

//- (void)payMoney:(int)money
//         orderNo:(NSString *)orderNo
//      completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
//{
//    [self payWithOrderNo:orderNo
//              order_type:@"订单"
//                   money:money
//              completion:completion];
//}
//
//- (void)rechargeCrowdfundingCoin:(int)money
//                         orderNo:(NSString *)orderNo
//                      completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
//{
//    [self payWithOrderNo:orderNo
//              order_type:@"充值"
//                   money:money
//              completion:completion];
//}
//
//- (void)rechargeThriceCoin:(int)money
//                   orderNo:(NSString *)orderNo
//                completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
//{
//    [self payWithOrderNo:orderNo
//              order_type:@"小米"
//                   money:money
//              completion:completion];
//}

- (void)payWithOrderNo:(NSString *)orderNo
            order_type:(NSString *)order_type
                 money:(int)all_price
               payType:(PayType)spayType
            completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
//    __block typeof(self) wself = self;
//    HttpHelper *helper = [HttpHelper helper];
//    [helper getMustpayInfoWithOrderNo:orderNo
//                            total_fee:allPriceStr
//                     spbill_create_ip:@"127.0.0.1"
//                                 body:order_type
//                               detail:@"充值支付"
//                              success:^(NSDictionary *resultDic){
//                                  
//                                  NSString *description = [resultDic objectForKey:@"desc"];
//                                  NSString *status = [resultDic objectForKey:@"status"];
//                                  NSString *orderNo = [resultDic objectForKey:@"data"];
//                                  BOOL result = [status isEqualToString:@"0"];
//                                  
//                                  if (result) {
//                                      [wself mustPayInitViewPrepayid:orderNo goodsName:nil goodsPrice:allPriceStr];
//                                  } else {
//                                      completion(NO, description, nil);
//                                  }
//                                  
//                              }fail:^(NSString *description){
//                                  completion(NO, description, nil);
//                              }];
    
}


/**
 @param appid       MustPay平台分配的唯一应用ID
 @param prepayid    服务端通过统一下单接口获取的prepayid
 @param goodsName   商品名字
 @param goodsPrice  商品价格
 @param scheme     支付宝用到 ，用于支付宝返回本应用
 */
- (void)mustPayInitViewPrepayid:(NSString*)prepayid goodsName:(NSString*)goodsName goodsPrice:(NSString*)goodsPrice {
    
    _autoreturnHappened = NO;
//    [[MustPaySDK sharedSingleton] mustPayInitViewAppid:kMustpayAppId prepayid:prepayid goodsName:@"购买商品" goodsPrice:goodsPrice scheme:APPScheme];
}

#pragma mark -  Mustpay return

-(void)mustPayResult:(NSString*)code
{
    if ([code isEqualToString:@"success"]) {
        
        if (_completionBlock) {
            _completionBlock(YES, @"支付成功", nil);
        }
    }else {
        
        if (_completionBlock) {
            _completionBlock(NO, @"支付失败", nil);
        }
    }
    
    MLog(@"mustPayResult = %@", code);
}

#pragma mark -  Mustpay notification

- (void)nispectOrder:(NSNotification *)nofify
{
    [self performSelector:@selector(checkMustpay) withObject:nil afterDelay:0.5];
}

//如果对MustPay支付方式进行了有效点击进入再次返回该应用时进行订单的支付状态验证
- (void)checkMustpay
{
    if (_autoreturnHappened == NO) {
        if ([MustPaySDK sharedSingleton].clickType) {
            [[MustPaySDK sharedSingleton] erifyOrderStatus];//验证订单支付成功
            [MustPaySDK sharedSingleton].clickType = NO;
        }
    }
}

// 支付宝返回结果
- (void)alipayNotification:(NSNotification *)nofify
{
    _autoreturnHappened = YES;
    
    NSDictionary *resultDic = [nofify userInfo];
    NSString *resultCode = (NSString *)[resultDic objectForKey:@"ResultStatus"];
    if (resultCode == nil) {
        resultCode = [resultDic objectForKey:@"resultStatus"];
    }
    BOOL result = [resultCode isEqualToString:@"9000"];
    
    NSString *message = result ? @"支付成功" : @"支付失败";
    if ([resultCode isEqualToString:@"01"] || [resultCode isEqualToString:@"4000"]){
        message = @"很遗憾，您此次支付失败，请您重新支付！";
    }else if([resultCode isEqualToString:@"02"] || [resultCode isEqualToString:@"6001"]){
        message = @"您已取消了支付操作！";
    }else if([resultCode isEqualToString:@"8000"]){
        message =  @"正在处理中,请稍候查看！";
    }else if([resultCode isEqualToString:@"6002"]){
        message = @"网络连接出错，请您重新支付！";
    }
    
    
    if (_completionBlock) {
        NSDictionary *resultInfo = [NSDictionary dictionaryWithObjectsAndKeys:resultCode, @"resCode", nil];
        _completionBlock(result, message, resultInfo);
    }
    
    if (result) {
        // 支付宝成功付款充值
        double money = _money;
        NSNumber *number = [NSNumber numberWithDouble:money];
           }
    
    MLog(@"notifia = %@", nofify);
}

- (void)weixinPayNotification:(NSNotification *)nofify
{
    _autoreturnHappened = YES;
    
    NSString *message = @"支付失败";
    BOOL result = NO;
    
    NSDictionary *userInfo = [nofify userInfo];
    int code = [[userInfo objectForKey:@"statue"] intValue];
    
    if(userInfo)
    {
        switch(code){
            case 0:
            {
                message = @"支付成功";
                result = YES;
            }
                break;
            case -2:
            {
                message = @"您已取消了支付操作！";
            }
                break;
            default:
            {
                message = @"很遗憾，您此次支付失败，请您重新支付！";
            }
                break;
        }
    }
    
    
    if (_completionBlock) {
        _completionBlock(result, message, nil);
    }
}

@end
