//
//  SPayManager.m
//  DuoBao
//
//  Created by clove on 3/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "SPayManager.h"
#import "SPayClient.h"

@interface SPayManager()

@property (nonatomic, strong) void (^completionBlock)(BOOL result, NSString *description,  NSDictionary *dict);
@property (nonatomic) int money;
@property (nonatomic, strong) UIViewController *payInViewController;

@end

@implementation SPayManager

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    MLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _payInViewController = viewController;
    }
    
    return self;
}


- (void)payWithZFBOrderNo:(NSString *)orderNo
            order_type:(NSString *)order_type
                 money:(int)all_price
               payType:(NSString *)payType
            completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    [HttpHelper getZFBInfoWithOrderNo:orderNo
                             total_fee:allPriceStr
                      spbill_create_ip:@"127.0.0.1"
                                  body:order_type
                                detail:@"充值支付"
                               success:^(NSDictionary *resultDic){
                                   NSString *status = [resultDic objectForKey:@"status"];
                                   NSDictionary *data = [resultDic objectForKey:@"data"];
                                   NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                   BOOL result = [status isEqualToString:@"0"];
                                   if (result) {
                                       //调用支付宝支付接口
                                       [[AlipaySDK defaultService] payOrder:transaction_id fromScheme:@"TaoPiao" callback:^(NSDictionary *resultDic) {
                                           MLog(@"resultDic%@",resultDic);

                                       }];
                                       
                                       
                                   }
                                   
                               }fail:^(NSString * description){
                                   completion(NO, description, nil);
                               }];
}


- (void)payWithZXOrderNo:(NSString *)orderNo
               order_type:(NSString *)order_type
                    money:(int)all_price
                  payType:(NSString *)payType
               completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    [HttpHelper getSpayInfoWithOrderNo:orderNo
                            total_fee:allPriceStr
                     spbill_create_ip:@"127.0.0.1"
                                 body:order_type
                               detail:@"充值支付"
                              success:^(NSDictionary *resultDic){
                                  MLog(@"充值支付resultDic？？？？？%@",resultDic);
                                  NSString *status = [resultDic objectForKey:@"status"];
                                  NSString *data = [resultDic objectForKey:@"data"];
//                                  NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                  BOOL result = [status isEqualToString:@"0"];
                                  MLog(@"充值支付resultDicdata%@",data);
                                  if (result) {
                                      //调用支付宝支付接口
                                      NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",data]];
                                      [[UIApplication sharedApplication] openURL:url];
                                  }
                                  
                              }fail:^(NSString * description){
                                  completion(NO, description, nil);
                              }];
}

- (void)payWithABOrderNo:(NSString *)orderNo
              order_type:(NSString *)order_type
                   money:(int)all_price
                 payType:(NSString *)payType
              completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    [HttpHelper getABpayInfoWithOrderNo:orderNo
                             total_fee:allPriceStr
                      spbill_create_ip:@"127.0.0.1"
                                  body:order_type
                                detail:@"充值支付"
                               success:^(NSDictionary *resultDic){
                                   MLog(@"充值支付resultDicpayWithABOrderNo%@",resultDic);
                                   NSString *status = [resultDic objectForKey:@"status"];
                                   NSString *data = [resultDic objectForKey:@"data"];
                                   //                                  NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                    MLog(@"充值支付resultDicpaydata%@",data);
                                   BOOL result = [status isEqualToString:@"0"];
                                   if (result) {
                                       //调用支付接口
                                       NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",data]];
                                       [[UIApplication sharedApplication] openURL:url];
                                   }
                                   
                               }fail:^(NSString * description){
                                   completion(NO, description, nil);
                               }];
}

- (void)payWithWXOrderNo:(NSString *)orderNo
              order_type:(NSString *)order_type
                   money:(int)all_price
                 payType:(NSString *)payType
              completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    [HttpHelper getWXInfoWithOrderNo:orderNo
                              total_fee:allPriceStr
                       spbill_create_ip:@"127.0.0.1"
                                   body:order_type
                                 detail:@"充值支付"
                                success:^(NSDictionary *resultDic){
                                    MLog(@"getWXInfoWithOrderNo%@",resultDic);
                                    NSString *description = [resultDic objectForKey:@"desc"];
                                  
                                    NSString *status = [resultDic objectForKey:@"status"];
                                    NSString *orderNo = [resultDic objectForKey:@"data"];
                                    BOOL result = [status isEqualToString:@"0"];
                                    //                                  NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                    if (result) {
                                        //调用支付接口
//                                        [Tool jumpToWeiXinPay:resultDic];
                                         [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:orderNo]];
                                    }
                                    
                                }fail:^(NSString * description){
                                    completion(NO, description, nil);
                                }];
}

- (void)payWithMustOrderNo:(NSString *)orderNo
              order_type:(NSString *)order_type
                   money:(int)all_price
                 payType:(NSString *)payType
              completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    [HttpHelper getMustpayInfoWithOrderNo:orderNo
                            total_fee:allPriceStr
                     spbill_create_ip:@"127.0.0.1"
                                 body:order_type
                               detail:@"充值支付"
                              success:^(NSDictionary *resultDic){
                                
                                  NSString *description = [resultDic objectForKey:@"desc"];
                                  MLog(@"getWXInfoWithOrderNo%@,%@",resultDic,description);
                                  NSString *status = [resultDic objectForKey:@"status"];
                                  NSString *orderNo = [resultDic objectForKey:@"data"];
                                  BOOL result = [status isEqualToString:@"0"];
//                                  Must支付
                                  if (result) {
                                      [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:orderNo]];
                                  } else {
                                      completion(NO, description, nil);
                                  }
                                  
                              }fail:^(NSString *description){
                                  completion(NO, description, nil);
                              }];
}


- (void)payWithOrderNo:(NSString *)orderNo
            order_type:(NSString *)order_type
                 money:(int)all_price
               payType:(PayType)payType
            completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion
{
    _completionBlock = completion;
    
    NSString *allPriceStr = [NSString stringWithFormat:@"%d", all_price];
    
    __block typeof(self) wself = self;
    
    [HttpHelper getSpayInfoWithOrderNo:orderNo
                         total_fee:allPriceStr
                  spbill_create_ip:@"127.0.0.1"
                              body:order_type
                            detail:@"充值支付"
                           success:^(NSDictionary *resultDic){
                               
                               NSString *status = [resultDic objectForKey:@"status"];
                               NSDictionary *data = [resultDic objectForKey:@"data"];
                               NSString *transaction_id = [data objectForKey:@"token_id"];
                               BOOL result = [status isEqualToString:@"0"];
                               
                               if (result) {
                                   [wself spayOrderNo:transaction_id priceStr:allPriceStr type:payType];
                               }
                               
                           }fail:^(NSString * description){
                               completion(NO, description, nil);
                           }];
}

- (void)spayOrderNo:(NSString *)orderNo priceStr:(NSString *)priceStr type:(PayType)payType
{
    NSNumber *amount = [NSNumber numberWithInt:[priceStr intValue]];
    NSString *payTypeStr = [self stringWithPayType:payType];

    [[SPayClient sharedInstance] pay:_payInViewController
                              amount:amount
                   spayTokenIDString:orderNo
                   payServicesString:payTypeStr
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
                                          if (_completionBlock) {
                                              _completionBlock(YES, @"支付成功", nil);
                                          }
                                      
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      
                                      if (_completionBlock) {
                                          _completionBlock(NO, @"支付失败", nil);
                                      }

                                      NSLog(@"支付失败，错误号:%d = %@",payStateModel.payState, payStateModel.messageString);
                                  }
                              }];
}

- (NSString *)stringWithPayType:(PayType)payType
{
    NSString *str = @"pay.weixin.app";
    
    if (payType == PayTypeWeChat) {
        str = @"pay.weixin.app";
    } else if (payType == PayTypeAlipay) {
        str = @"pay.alipay.native.towap";
    } else if (payType == PayTypeQQ) {
        str = @"pay.qq.app";
    }
    
    return str;
}



@end
