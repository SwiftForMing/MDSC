//
//  HttpHelper.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/1.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "HttpHelper.h"
#import "AFNetworking.h"
#import "SecurityUtil.h"
#import "Tool.h"
#import "RSA.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "RSAEncryptor.h"
#import "DataSigner.h"
#define httprivateKey @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2L/+V9y00HV63Bsh9hMRZxDEnhqiEjXZ3c9qFRGXFy6hKq1D+n6aG7/w3+LkyLySbLkqIxnBzriV7a1lpJfRlZL26d4YUtpLZVo0qVwUA1piBQP1NwIp8VkRmhc0FazsVsMsFxYoVqyATK6iXhQFOZe8Ph9YdPLirED3ub61cBumAiZZxuDHGatF0NI4zsHBCFebjY2i6XVMGnCTe3HIqvxxYsmNWXrxNSh4rZV5A39TYA8doGZzjHo1Mobmgl+2eiI96a3yEuhXdx5ZheIDla6OcGk9yS85PDUkfaaDyVfvOTJz5FRcZI1aUiGs2bIrpxjsVA22jkeZMvWNNJD6BwIDAQAB"

@interface HttpHelper()


@end
@implementation HttpHelper

- (void)dealloc
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

+ (instancetype)helper
{
    HttpHelper *helper = [[HttpHelper alloc] init];
    return helper;
}
#pragma mark - 拼接:URL_Server+keyURL
/**
 * 拼接:URL_Server+keyURL
 */
+ (NSString *)getURL{
    
    NSString *str =  URL_Server;
    
    if ([ShareManager shareInstance].isInReview == YES) {
        str =  URL_ServerTest;
    }
    
    return str;
}
#pragma mark - 获取版本号
/**
 * 获取版本号
 * 本地版本号 >= 服务器版本号，表示新版本正在审核阶段
 */
+ (void)getVersion:(void (^)(NSDictionary *resultDic))success
              fail:(void (^)(NSString *description))fail
{
    NSString *URLString = [NSMutableString stringWithFormat:@"%@%@", URL_Server, URL_GetVersion];
    [self getHttpBaseQuestWithUrl:URLString success:success fail:fail];
}

#pragma mark - 注册、登录、获取验证码、找回密码
/**
 * 获取验证码
 * type:[1.注册,2.找回密码,3.修改电话号码和微信绑定]
 */
+ (void)getVerificationCodeByMobile:(NSString *)mobile
                               type:(NSString *)type
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetVerificationCode];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

+ (void)getConfigure:(void (^)(NSDictionary *resultDic))success
                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:@"appInterface/getConfiguration.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 注册
 */
+ (void)registerByWithMobile:(NSString *)mobile
                    password:(NSString *)password
           recommend_user_id:(NSString *)recommend_user_id
                   auth_code:(NSString *)auth_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (recommend_user_id) {
        [parameters setObject:recommend_user_id forKey:@"recommend_user_id"];
    }else{
        [parameters setObject:@"" forKey:@"recommend_user_id"];
    }
    if (auth_code) {
        [parameters setObject:auth_code forKey:@"auth_code"];
    }
   
    NSString *URLString = [self getURLbyKey:URL_Register];

    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 手机号登录
 */
+ (void)loginByWithMobile:(NSString *)mobile
                 password:(NSString *)password
                 jpush_id:(NSString *)jpush_id
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    if (password) {
        
        [parameters setObject:password forKey:@"password"];
    }
    if (jpush_id) {
        
        [parameters setObject:jpush_id forKey:@"jpush_id"];
    }else{
        
        [parameters setObject:@"" forKey:@"jpush_id"];
    }
    
    
#if TARGET_IPHONE_SIMULATOR
    [parameters setObject:@"iOS test" forKey:@"jpush_id"];
#endif
    MLog(@"loginByWithMobilelog%@",parameters);
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Login];

    [self loginWithAbsoluteURLString:URLString parameter:parameters success:success fail:fail];
}

/**
 * 第三方登录
 * jpush_id :极光推送id(registrationId)
 * type:登陆形式[weixin,qq]
 */
+ (void)thirdloginByWithLoginId:(NSString *)app_login_id
                      nick_name:(NSString *)nick_name
                    user_header:(NSString *)user_header
                           type:(NSString *)type
                       jpush_id:(NSString *)jpush_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (app_login_id) {
        [parameters setObject:app_login_id forKey:@"app_login_id"];
    }
    if (nick_name) {
        
        [parameters setObject:nick_name forKey:@"nick_name"];
    }else{
        [parameters setObject:@"" forKey:@"nick_name"];
    }
    
    if (user_header) {
        
        [parameters setObject:user_header forKey:@"user_header"];
    }else{
        [parameters setObject:@"" forKey:@"user_header"];
    }
    
    if (type) {
        
        [parameters setObject:type forKey:@"type"];
    }else{
        [parameters setObject:@"" forKey:@"type"];
    }
    
    if (jpush_id) {
        
        [parameters setObject:jpush_id forKey:@"jpush_id"];
    }else{
        [parameters setObject:@"" forKey:@"jpush_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ThirdLogin];
    
    [self loginWithAbsoluteURLString:URLString parameter:parameters success:success fail:fail];
}


// 登录接口统一增加uuid， 客户编号，token保存
+ (void)loginWithAbsoluteURLString:(NSString *)absoluteURL
                         parameter:(NSMutableDictionary *)parameters
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSString *uuid = [Tool getUUID];
    NSString *clien_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *clien_type = @"iOS";
    
    if (uuid) {
        [parameters setObject:uuid forKey:@"mac_address"];
    }
    
    if (clien_version) {
        [parameters setObject:clien_version forKey:@"clien_version"];
    }
    if (clien_type) {
        [parameters setObject:clien_type forKey:@"clien_type"];
    }
    
    [self postHttpWithDic:parameters urlStr:absoluteURL success:^(NSDictionary *resultDic) {
        
        // 保存token
        NSDictionary *data = [resultDic objectForKey:@"data"];
        if (data) {
            NSString *token = [data objectForKey:@"token"];
            NSString *nowTime = [data objectForKey:@"nowTime"];
            NSInteger timeDifference = [NSDate serverTimeDifference:[nowTime longLongValue]];
            
            [[ShareManager shareInstance] setToken:token];
            [[ShareManager shareInstance] setServerTimeDifference:timeDifference];
            
            // 保存登录信息
            UserInfo *userInfo = [data objectByClass:[UserInfo class]];
            userInfo.islogin = YES;
            userInfo.loginPassword = [ShareManager shareInstance].userinfo.loginPassword;
            [ShareManager shareInstance].userinfo = userInfo;
            [Tool saveUserInfoToDB:YES];
        }
        
        success(resultDic);
        
    } fail:^(NSString *description) {
        fail(description);
    }];
}


/**
 * 找回密码
 */
+ (void)findPwdByWithMobile:(NSString *)mobile
                   password:(NSString *)password
                  auth_code:(NSString *)auth_code
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (auth_code) {
        [parameters setObject:auth_code forKey:@"auth_code"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_FindPwd];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 第三方绑定
 */
+ (void)bangDingByWithLoginId:(NSString *)app_login_id
                         type:(NSString *)type
                      url_tel:(NSString *)url_tel
                    auth_code:(NSString *)auth_code
            recommend_user_id:(NSString *)recommend_user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (app_login_id) {
        [parameters setObject:app_login_id forKey:@"app_login_id"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    if (url_tel) {
        [parameters setObject:url_tel forKey:@"user_tel"];
    }
    if (auth_code) {
        [parameters setObject:auth_code forKey:@"auth_code"];
    }
    if (recommend_user_id) {
        [parameters setObject:recommend_user_id forKey:@"recommend_user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_BangDing];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 拼接:URL_Server+keyURL
/**
 * 拼接:URL_Server+keyURL
 */
+ (NSString *)getURLbyKey:(NSString *)URLKey{
    
    NSString *str = [NSMutableString stringWithFormat:@"%@%@", URL_Server, URLKey];
  
    if ([ShareManager shareInstance].isInReview == YES) {
        str = [NSMutableString stringWithFormat:@"%@%@", URL_ServerTest, URLKey];
    }
    
//    if ([ShareManager shareInstance].isEnterMK == YES) {
//        str = [NSMutableString stringWithFormat:@"%@%@", URL_MKEntOneServer, URLKey];
//        MLog(@"str:%@",str);
//    }
   
    return str;
}

+ (NSString *)getEntURLbyKey:(NSString *)URLKey{
    
    NSString *str = [NSMutableString stringWithFormat:@"%@%@", URL_EntOneServer, URLKey];
   
     if ([ShareManager shareInstance].isInReview == YES) {
     str = [NSMutableString stringWithFormat:@"%@%@", URL_EntOneServerTest, URLKey];
     }
    
    if ([ShareManager shareInstance].isEnterMK == YES) {
      str = [NSMutableString stringWithFormat:@"%@%@", URL_MKEntOneServer, URLKey];
        MLog(@"str:%@",str);
    }
    return str;
}
#pragma mark - 获取分类相关数据
+(void)getSearchIDDataWithID:(NSString *)goodID
                     pageNum:(NSString *)page
                     limitNum:(NSString *)limit
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodID) {
        [parameters setObject:goodID forKey:@"goodsTypeId"];
    }else{
        MLog(@"缺少参赛goodID");
    }
    if (page) {
        [parameters setObject:page forKey:@"pageNum"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (limit) {
        [parameters setObject:limit forKey:@"limitNum"];
    }else{
        MLog(@"缺少参赛page");;
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GoodType];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取关键字搜索数据
 *
 */
+(void)getSearchKeyDataWithKeyWord:(NSString *)key success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (key) {
        [parameters setObject:key forKey:@"searchKey"];
    }else{
        [parameters setObject:@"" forKey:@"searchKey"];
    }

    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GoodsSearchKeyList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];

}
#pragma mark -
+(void)WhetherCutPhotoWithUserId:(NSString *)user_id
                   good_fight_id:(NSString *)good_fight_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛user_id");
    }
    if (good_fight_id) {
        [parameters setObject:good_fight_id forKey:@"goods_fight_id"];
    }else{
        MLog(@"缺少参赛good_fight_id");;
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_CutPhoto];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
    
    
}
#pragma mark -
+(void)getQuanBeanDateWithPageNum:(NSString *)page
                         limitNum:(NSString *)limit
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (page) {
        [parameters setObject:page forKey:@"pageNum"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (limit) {
        [parameters setObject:limit forKey:@"limitNum"];
    }else{
        MLog(@"缺少参赛page");;
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_BeanList];
    MLog(@"URLString%@",URLString);
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}


#pragma mark - 获取首页相关数据
+(void)getHomeListDataWithPageNum:(NSString *)page
                         limitNum:(NSString *)limit
                          success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (page) {
        [parameters setObject:page forKey:@"pageNum"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (limit) {
        [parameters setObject:limit forKey:@"limitNum"];
    }else{
        MLog(@"缺少参赛page");;
    }

    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Recommend];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}


#pragma mark - 获取优惠券相关数据
+(void)getEntCouponListDataWithPageNum:(NSString *)page
                              limitNum:(NSString *)limit
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  
    if (page) {
        [parameters setObject:page forKey:@"pageNum"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (limit) {
        [parameters setObject:limit forKey:@"limitNum"];
    }else{
        MLog(@"缺少参赛page");;
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_EntCouponsList];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
    
}
#pragma mark - 获取优惠券相关数据
+(void)getCouponListDataWithUserID:(NSString *)user_id
                           PageNum:(NSString *)page
                          limitNum:(NSString *)limit
                              type:(NSString *)type
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛goodID");
    }
    if (page) {
        [parameters setObject:page forKey:@"pageNum"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (limit) {
        [parameters setObject:limit forKey:@"limitNum"];
    }else{
        MLog(@"缺少参赛page");;
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }else{
        MLog(@"缺少参赛type");
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_MyCouponsList];
    MLog(@"URLString%@",URLString);
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
    
}

+(void)getSharaCouponIDWithUserID:(NSString *)user_id
                   Coupons_secret:(NSString *)coupons_secret
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail{
    
      NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛user_id");
    }
    if (coupons_secret) {
        [parameters setObject:coupons_secret forKey:@"coupons_secret"];
    }else{
        MLog(@"缺少参赛coupons_secret");
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:@"appInterface/shareCoupons.jhtml"];
//    NSString *URLString = @"http://192.168.31.170:9595/TaoQuan/appInterface/shareCoupons.jhtml";
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

+(void)getAddCouponDataWithUserID:(NSString *)user_id
                   Coupons_secret:(NSString *)secret
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛goodID");
    }
    if (secret) {
        [parameters setObject:secret forKey:@"coupons_secret"];
    }else{
        MLog(@"缺少参赛secret");
    }
        //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_AddCoupon];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];

}

#pragma mark - 获取基础数据
+ (void)getHttpWithUrlStr:(NSString *)urlStr
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    NSString *URLString = [self getURLbyKey:urlStr];
    [self getHttpBaseQuestWithUrl:URLString success:success fail:fail];
}


+ (void)getHttpBaseQuestWithUrl:(NSString *)urlstr
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self postHttpWithDic:parameters urlStr:urlstr success:success fail:fail];
}


#pragma mark -  获取充值记录
/**
 * 获取充值记录
 */
+ (void)getCZRecordWithUserId:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
                         type:(NSString *)type
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetCZReord];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark -  充值
/**
 * 充值
 * type:[weixin/zhifubao]
 */
+ (void)payCZWithUserId:(NSString *)user_id
                  money:(NSString *)money
                typeStr:(NSString *)typeStr
                success:(void (^)(NSDictionary *resultDic))success
                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (money) {
        [parameters setObject:money forKey:@"money"];
    }
    if (typeStr) {
        [parameters setObject:typeStr forKey:@"type"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_PayCZ];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取aibei支付参数
 *
 */
+ (void)getABpayInfoWithOrderNo:(NSString *)out_trade_no
                     total_fee:(NSString *)total_fee
              spbill_create_ip:(NSString *)spbill_create_ip
                          body:(NSString *)body
                        detail:(NSString *)detail
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (spbill_create_ip) {
        [parameters setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    }else{
        [parameters setObject:@"" forKey:@"spbill_create_ip"];
    }
    
    if (body) {
        [parameters setObject:body forKey:@"body"];
    }else{
        [parameters setObject:@"" forKey:@"body"];
    }
    
    if (detail) {
        [parameters setObject:detail forKey:@"detail"];
    }else{
        [parameters setObject:@"" forKey:@"detail"];
    }
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:@"appInterface/iappayUnifiedorder.jhtml"];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 获取中信支付参数
//iappayUnifiedorder.jhtml
/**
 * 获取中信支付参数
 *
 */
+ (void)getSpayInfoWithOrderNo:(NSString *)out_trade_no
                     total_fee:(NSString *)total_fee
              spbill_create_ip:(NSString *)spbill_create_ip
                          body:(NSString *)body
                        detail:(NSString *)detail
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (spbill_create_ip) {
        [parameters setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    }else{
        [parameters setObject:@"" forKey:@"spbill_create_ip"];
    }
    
    if (body) {
        [parameters setObject:body forKey:@"body"];
    }else{
        [parameters setObject:@"" forKey:@"body"];
    }
    
    if (detail) {
        [parameters setObject:detail forKey:@"detail"];
    }else{
        [parameters setObject:@"" forKey:@"detail"];
    }
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:@"appInterface/zxpayUnifiedorder.jhtml"];

    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取支付宝支付参数
 *
 */
+ (void)getZFBInfoWithOrderNo:(NSString *)out_trade_no
                     total_fee:(NSString *)total_fee
              spbill_create_ip:(NSString *)spbill_create_ip
                          body:(NSString *)body
                        detail:(NSString *)detail
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (spbill_create_ip) {
        [parameters setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    }else{
        [parameters setObject:@"" forKey:@"spbill_create_ip"];
    }
    
    if (body) {
        [parameters setObject:body forKey:@"body"];
    }else{
        [parameters setObject:@"" forKey:@"body"];
    }
    
    if (detail) {
        [parameters setObject:detail forKey:@"detail"];
    }else{
        [parameters setObject:@"" forKey:@"detail"];
    }
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
//    MLog(@"httphelperuser_id%@",user_id);
    
    //拼接:URL_Server+keyURLPOST alipayUnifiedorder.jhtml
    NSString *URLString = [self getURLbyKey:@"appInterface/alipayUnifiedorder.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//GLpayUnifiedorder

/**
 * 获取Mustpay支付参数
 *
 */
+ (void)getMustpayInfoWithOrderNo:(NSString *)out_trade_no
                        total_fee:(NSString *)total_fee
                 spbill_create_ip:(NSString *)spbill_create_ip
                             body:(NSString *)body
                           detail:(NSString *)detail
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (spbill_create_ip) {
        [parameters setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    }else{
        [parameters setObject:@"" forKey:@"spbill_create_ip"];
    }
    
    if (body) {
        [parameters setObject:body forKey:@"body"];
    }else{
        [parameters setObject:@"" forKey:@"body"];
    }
    
    if (detail) {
        [parameters setObject:detail forKey:@"detail"];
    }else{
        [parameters setObject:@"" forKey:@"detail"];
    }
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL mustpayUnifiedorder
    NSString *URLString = [self getURLbyKey:@"appInterface/mustpayUnifiedorder.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];

}
/**
 * 获取weix支付参数
 *
 */
+ (void)getWXInfoWithOrderNo:(NSString *)out_trade_no
                    total_fee:(NSString *)total_fee
             spbill_create_ip:(NSString *)spbill_create_ip
                         body:(NSString *)body
                       detail:(NSString *)detail
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (spbill_create_ip) {
        [parameters setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    }else{
        [parameters setObject:@"" forKey:@"spbill_create_ip"];
    }
    
    if (body) {
        [parameters setObject:body forKey:@"body"];
    }else{
        [parameters setObject:@"" forKey:@"body"];
    }
    
    if (detail) {
        [parameters setObject:detail forKey:@"detail"];
    }else{
        [parameters setObject:@"" forKey:@"detail"];
    }
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    MLog(@"httphelperuser_id%@",user_id);
    
    //拼接:URL_Server+keyURLPOST alipayUnifiedorder.jhtml
    NSString *URLString = [self getURLbyKey:@"appInterface/wechatUnifiedorder.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


#pragma mark - 生成预订单
// 生成预订单
+(void)getOrderWithOrderType:(NSString *)orderType
                    goods_id:(NSString *)goodID
                     buy_num:(NSString *)num
                 coupons_ids:(NSArray *)coupons_ids
                        type:(NSString *)type
                     user_id:(NSString *)user_id
              consignee_name:(NSString *)consignee_name
               consignee_tel:(NSString *)consignee_tel
           consignee_address:(NSString *)consignee_address
                      remark:(NSString *)remark
                  express_id:(NSString *)express_id
                     success:(void (^)(NSDictionary *data))success
                     failure:(void (^)(NSString *description))failure

{
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderType) {
        [parameters setObject:orderType forKey:@"orderType"];
    }else{
        MLog(@"没有orderType参数");
        return;
    }

    if (goodID) {
        [parameters setObject:goodID forKey:@"goods_id"];
    }else{
        MLog(@"没有goodID参数");
        return;
    }

    if (num) {
        [parameters setObject:num forKey:@"buy_num"];
    }else{
        MLog(@"没有num参数");
        return;
    }

    if (coupons_ids.count>0) {
        NSArray * array= coupons_ids;
        NSString *ns=[array componentsJoinedByString:@","];
        [parameters setObject:ns forKey:@"coupons_ids"];
    }else{
        MLog(@"没有coupons_ids参数");
         [parameters setObject:@"NUL" forKey:@"coupons_ids"];
//        return;
    }

    if (type) {
        [parameters setObject:type forKey:@"type"];
    }else{
        MLog(@"没有type参数");
        return;
    }

    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        MLog(@"没有user_id参数");
        return;
    }

    if (![consignee_name isEqualToString:@""]) {
        [parameters setObject:consignee_name forKey:@"consignee_name"];
    }else{
        MLog(@"没有consignee_name参数");
        [parameters setObject:@"NUL" forKey:@"consignee_name"];
//        return;
    }

    if (![consignee_tel isEqualToString:@""]) {
        [parameters setObject:consignee_tel forKey:@"consignee_tel"];
    }else{
        MLog(@"没有consignee_tel参数");
        [parameters setObject:@"NUL" forKey:@"consignee_tel"];
//        return;
    }

    if (![consignee_address isEqualToString:@""]) {
        [parameters setObject:consignee_address forKey:@"consignee_address"];
    }else{
        MLog(@"没有consignee_address参数");
         [parameters setObject:@"NUL" forKey:@"consignee_address"];
//        return;
    }

    if (![remark isEqualToString:@""] ) {
        [parameters setObject:remark forKey:@"remark"];
    }else{
        MLog(@"没有remark参数");
         [parameters setObject:@"NUL" forKey:@"remark"];
//        return;
    }

    if (![express_id isEqualToString:@""]) {
        [parameters setObject:express_id forKey:@"express_id"];
    }else{
        MLog(@"没有express_id参数");
        [parameters setObject:@"NUL" forKey:@"express_id"];
//        return;
    }

//    MLog(@"parameters%@",parameters);
    
    NSString *path = [self apiWithPathExtension:@"genOrder.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:path success:success fail:failure];
 
}

#pragma mark -获取结算也没详情 
+(void)getDetialOrderWithGoodId:(NSString *)goods_id
                           type:(NSString *)type
                         buyNum:(NSString *)num
                         userId:(NSString *)user_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    if (goods_id) {
        [parameters setObject:goods_id forKey:@"goods_id"];
    }
    if (num) {
        [parameters setObject:num forKey:@"buy_num"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetOrderDetail];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];


}

#pragma mark - 获取我的订单列表

+ (void)getMyorderLisetWithUserID:(NSString *)user_id
                             type:(NSString *)type
                          pageNum:(NSString *)page
                            limitNum:(NSString *)limit
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    if (page) {
        [parameters setObject:page forKey:@"pageNum"];
    }
    if (limit) {
        [parameters setObject:limit forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetMyOrderList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];

}

#pragma mark -  修改默认地址
/**
 * 修改默认地址
 */
+ (void)changeDefaultAddressWithUserId:(NSString *)user_id
                             addressId:(NSString *)addressId
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (addressId) {
        [parameters setObject:addressId forKey:@"id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeDefaultAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 收获地址列表
 */
+ (void)receiveAddressListWithUserId:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetAdressList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 *添加或修改我的收获地址
 *
 */
+ (void)addAddressWithUserId:(NSString *)user_id
                   addressId:(NSString *)addressId
                    user_tel:(NSString *)user_tel
                   user_name:(NSString *)user_name
                 province_id:(NSString *)province_id
                     city_id:(NSString *)city_id
              detail_address:(NSString *)detail_address
                  is_default:(NSString *)is_default
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (addressId) {
        [parameters setObject:addressId forKey:@"id"];
    }else{
        [parameters setObject:@"" forKey:@"id"];
    }
    
    if (user_tel) {
        [parameters setObject:user_tel forKey:@"user_tel"];
    }
    if (user_name) {
        [parameters setObject:user_name forKey:@"user_name"];
    }
    if (province_id) {
        [parameters setObject:province_id forKey:@"province_id"];
    }
    if (city_id) {
        [parameters setObject:city_id forKey:@"city_id"];
    }
    if (detail_address) {
        [parameters setObject:detail_address forKey:@"detail_address"];
    }
    if (is_default) {
        [parameters setObject:is_default forKey:@"is_default"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_AddAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取城市列表
 */
+ (void)getCityInfoWithProvinceId:(NSString *)provinceId
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (provinceId) {
        [parameters setObject:provinceId forKey:@"provinceId"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetCityInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 删除地址
 */
+ (void)deleteAddressWithAddressId:(NSString *)addressId
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (addressId) {
        [parameters setObject:addressId forKey:@"id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_DeleteMyAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
#pragma mark -  获取用户信息
/**
 * 获取用户信息
 */
+ (void)getUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetUserInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取幸运信息
 */
+ (void)getCurrentLiftInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetLiftInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


+ (void)getEntUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetUserInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

//+ (void)getUpDateUserInfoWithUserId:(NSString *)user_id
//                      success:(void (^)(NSDictionary *resultDic))success
//                         fail:(void (^)(NSString *description))fail
//{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    
//    if (user_id) {
//        [parameters setObject:user_id forKey:@"user_id"];
//    }
//    //拼接:URL_Server+keyURL
//    NSString *URLString = [self getURLbyKey:URL_GetGoodsType];
//    
//    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
//}

/**
 * 修改用户信息
 * fieldName:字段名称(多个请用,隔开)
 * fieldNameValue:修改后的字段值(多个请用,隔开)
 * updateFieldNameNum:修改字段数量
 */
+ (void)changeUserInfoWithUserId:(NSString *)user_id
                       fieldName:(NSString *)fieldName
                  fieldNameValue:(NSString *)fieldNameValue
              updateFieldNameNum:(NSString *)updateFieldNameNum
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (fieldName) {
        [parameters setObject:fieldName forKey:@"fieldName"];
    }
    
    if (fieldNameValue) {
        [parameters setObject:fieldNameValue forKey:@"fieldNameValue"];
    }
    if (updateFieldNameNum) {
        [parameters setObject:updateFieldNameNum forKey:@"updateFieldNameNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeUserInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * Post 上传图片
 */
+ (void)postImageHttpWithImage:(UIImage*)image
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:[NSString stringWithFormat:@"%@", [ShareManager shareInstance].userinfo.id] forKey:@"id"];
    
    //当前时间戳 单位毫秒
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *requestTime = [NSString stringWithFormat:@"%lld",recordTime];
    
    [parameter setObject:requestTime forKey:@"request_time"];
    NSArray *allkeys = [parameter allKeys];
    NSString *sign = nil;
    for (NSString *mkey in allkeys)
    {
        NSObject *value = [parameter objectForKey:mkey];
        if (!sign) {
            sign = [NSString stringWithFormat:@"%@",value];
        }else{
            sign = [NSString stringWithFormat:@"%@|$|%@", sign, value];
        }
    }
    NSString *str = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAESData:sign publick:EncryptPublicKey]];
    [parameter setObject:str forKey:@"sign"];
    
    // 登录授权验证
    NSString *token = [[ShareManager shareInstance] token];
    if (token) {
        [parameter setObject:token forKey:@"token"];
    }
    
    NSData *jsParameters = [NSJSONSerialization dataWithJSONObject:parameter  options:NSJSONWritingPrettyPrinted error:nil];
    NSString *aString = [[NSString alloc] initWithData:jsParameters encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *jiamistr = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAESData:aString publick:EncryptPublicKey2]];
    [parameters setObject:jiamistr forKey:@"param"];
    
    AFHTTPSessionManager *om = [AFHTTPSessionManager manager];
    om.responseSerializer = [AFHTTPResponseSerializer serializer];
    om.requestSerializer.timeoutInterval = 20;
    NSString *URLString = [self getURLbyKey:URL_UpdateImageUrl];
    [om POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if(image)
        {
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"111.jpg" mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject;
        NSData *data = (NSData *)responseObject;
        if ([data isKindOfClass:[NSData class]]) {
            dict = [data objectFromJSONData];
        }
        
        if (success) {
            success((NSDictionary *)dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(@"网络请求失败了");
        }
    }];
}



/**
 * 拼接:URL_Server+keyURL
 */
+ (NSString *)apiWithPathExtension:(NSString *)pathExtension{
    
    NSString *str = [NSMutableString stringWithFormat:@"%@appInterface/%@", URL_Server, pathExtension];
    
    if ([ShareManager shareInstance].isInReview == YES) {
        str = [NSMutableString stringWithFormat:@"%@appInterface/%@", URL_ServerTest, pathExtension];
    }
    
    return str;
}

+ (NSString *)apiWithEntPathExtension:(NSString *)pathExtension{
    
    NSString *str = [NSMutableString stringWithFormat:@"%@appInterface/%@", URL_EntOneServer, pathExtension];
    
    if ([ShareManager shareInstance].isInReview == YES) {
        str = [NSMutableString stringWithFormat:@"%@appInterface/%@", URL_EntOneServerTest, pathExtension];
    }
    if ([ShareManager shareInstance].isEnterMK == YES) {
        str = [NSMutableString stringWithFormat:@"%@appInterface/%@", URL_MKEntOneServer, pathExtension];
        MLog(@"str:%@",str);
    }
    return str;
}

// 直接购买 = 生成与订单 -> 小米小米均足够可直接购买
+ (void)purchaseGoodsFightID:(NSString *)goods_fight_ids
                       count:(int)goodsCount
              goods_buy_nums:(NSString *)goods_buy_nums
              thricePurchase:(NSArray *)thricePurchaseArray
                  isShopCart:(NSString *)is_shop_cart
                      coupon:(NSString *)ticket_send_id
         exchangedThriceCoin:(int)exchangedThriceCoin
                     goodsID:(NSString *)goods_ids
                     buyType:(NSString *)buyType
                     success:(void (^)(NSDictionary *data))success
                     failure:(void (^)(NSString *description))failure
{
    NSString *payType = @"money";
    NSString *fights_choices = [ServerProtocol fights_choices:thricePurchaseArray];
    NSString *fights_counts = [ServerProtocol fights_counts:thricePurchaseArray];
    
//    NSString *goods_buy_nums =
    NSString *happy_bean_price = [NSString stringWithFormat:@"%d", exchangedThriceCoin];
    
    
    is_shop_cart = is_shop_cart?:@"n";
    goods_fight_ids = goods_fight_ids?:@"";
    ticket_send_id = ticket_send_id?:@"";
    fights_choices = fights_choices?:@"";
    fights_counts = fights_counts?:@"";
//    goods_buy_nums = goods_buy_nums?:@"";
    happy_bean_price = happy_bean_price?:@"";
    goods_ids = goods_ids?:@"";
    buyType = buyType?:@"";
    
    
    if ([goods_fight_ids isKindOfClass:[NSNumber class]]) {
        goods_fight_ids = [NSString stringWithFormat:@"%lld", [goods_fight_ids longLongValue]];
    }
    if ([goods_ids isKindOfClass:[NSNumber class]]) {
        goods_ids = [NSString stringWithFormat:@"%lld", [goods_ids longLongValue]];
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:payType forKey:@"payType"];
    [parameters setObject:goods_fight_ids forKey:@"goods_fight_ids"];
    [parameters setObject:is_shop_cart forKey:@"is_shop_cart"];
    [parameters setObject:ticket_send_id forKey:@"ticket_send_id"];
    [parameters setObject:fights_choices forKey:@"fights_choices"];
    [parameters setObject:fights_counts forKey:@"fights_counts"];
    if([goods_buy_nums isEqualToString:@""]){
       [parameters setObject: [NSString stringWithFormat:@"%d", goodsCount] forKey:@"goods_buy_nums"];;
    }else{
        [parameters setObject:goods_buy_nums forKey:@"goods_buy_nums"];
    }
   
    [parameters setObject:happy_bean_price forKey:@"happy_bean_price"];
    [parameters setObject:goods_ids forKey:@"goods_ids"];
    [parameters setObject:buyType forKey:@"buyType"];
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    MLog(@"paymentGoodsFight%@",parameters);
    
    NSString *path = [self apiWithEntPathExtension:@"paymentGoodsFight.jhtml"];
//     NSString *path = @"http://118.178.92.99:51501/TaoQuan/zmlgApi/paymentGoodsFight.jhtml";
    [self postWithDictionary:parameters path:path success:success fail:failure];
}
#pragma mark - 底层 post数据请求和图片上传

+ (void)postWithDictionary:(NSMutableDictionary *)parameter
                      path:(NSString *)path
                   success:(void (^)(NSDictionary *resultDictionary))success //成功
                      fail:(void (^)(NSString *description))fail      //失败
{
    [self postHttpWithDic:parameter
                   urlStr:path success:^(NSDictionary *responseObject) {
                       
                       BOOL result = NO;
                       NSString *description = @"";
                       NSDictionary *data = nil;
                       
                       if ([responseObject isKindOfClass:[NSDictionary class]]) {
                           NSDictionary *responseDict = (NSDictionary *)responseObject;
                           
                           int status = [[responseDict objectForKey:@"status"] intValue];
                           description = [responseDict objectForKey:@"desc"];
                           data = [responseDict objectForKey:@"data"];
                           
                           if (status == 0) {
                               result = YES;
                           }
                       }
                       
                       if (result) {
                           success(data);
                       } else {
                           fail(description);
                       }
                       
                   } fail:fail];
}


/**
 * Post请求数据
 */
+ (void)postHttpWithDic:(NSMutableDictionary *)parameter
                 urlStr:(NSString *)urlStr
                success:(void (^)(NSDictionary *resultDic))success //成功
                   fail:(void (^)(NSString *description))fail      //失败
{
    //当前时间戳 单位毫秒
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *requestTime = [NSString stringWithFormat:@"%lld",recordTime];
    [parameter setObject:requestTime forKey:@"request_time"];
    
    // iOS
    [parameter setObject:@"ios" forKey:@"system"];
    
    // version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [parameter setObject:version forKey:@"version"];
    
    NSArray *allkeys = [parameter allKeys];
    NSString *sign = nil;
    for (NSString *mkey in allkeys)
    {
        NSObject *value = [parameter objectForKey:mkey];
        if (!sign) {
            sign = [NSString stringWithFormat:@"%@",value];
        }else{
            sign = [NSString stringWithFormat:@"%@|$|%@",sign,value];
        }
    }
    MLog(@"signpost url = %@", sign);
    
    NSString *str = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAESData:sign publick:EncryptPublicKey]];
    [parameter setObject:str forKey:@"sign"];
    
    
    // 登录授权验证
    NSString *token = [[ShareManager shareInstance] token];
    if (token) {
        [parameter setObject:token forKey:@"token"];
    }
    NSData *jsParameters = [NSJSONSerialization dataWithJSONObject:parameter  options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *aString = [[NSString alloc] initWithData:jsParameters encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *duicstr = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAESData:aString publick:EncryptPublicKey2]];
    [parameters setObject:duicstr forKey:@"param"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLRequest *request = [requestSerializer requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];
    MLog(@"textparameter = %@", parameter);
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            MLog(@"---------------------------------------------------------------");
            MLog(@"post url = %@", urlStr);
            MLog(@"parameter = %@", parameter);
            MLog(@"result :%@", str);
            if (fail) {
                
                fail(@"网络请求失败了");
            }
        } else {
            
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                int code = [[(NSDictionary *)responseObject objectForKey:@"code"] intValue];
                int status = [[(NSDictionary *)responseObject objectForKey:@"status"] intValue];
                
                if (status == 0) {
                    if (code == 100 || code == 101) {
                        
                        [ShareManager shareInstance].userinfo.islogin = NO;
                        
                        [Tool autoLoginSuccess:^(NSDictionary *success) {
                        } fail:^(NSString *failure) {
                        }];
                        
                    } else {
                        // 刷新登录token
                        
                        [LoginModel refreshToken];
                    }
                }
            }
            
            if (success) {
                success((NSDictionary *)responseObject);
                
            }
        }
    }];
    
    [dataTask resume];
}

/**
 * 邀请好友列表
 * level: 好友层级[1,2,3]
 */
+ (void)getFriendsByLevelWithUserId:(NSString *)user_id
                              level:(NSString *)level
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (level) {
        [parameters setObject:level forKey:@"level"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetFriendsByLevel];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 邀请好友

// 邀请好友
+ (void)getInviteInfo:(void (^)(NSDictionary *resultDic))success
                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    
    if (userID) {
        [parameters setObject:userID forKey:@"user_id"];
    }
    
    NSString *URLString = [self getEntURLbyKey:URL_GetInviteInfo];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

// Income from friends
+ (void)getEarningHistoryByDays:(NSString *)pageNum
                       limitNum:(NSString *)limitNum
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getEarningHistoryByDays.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

// bind recommend user ID
+ (void)saveRecommendUserID:(NSString *)recommnedUserID
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    if (recommnedUserID) {
        [parameters setObject:recommnedUserID forKey:@"up_friend"];
    }else{
        [parameters setObject:@"" forKey:@"up_friend"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/saveUpFriend.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

// withdraw money
+ (void)withdrawMoney:(NSString *)money
         withdrawType:(NSString *)type
              success:(void (^)(NSDictionary *resultDic))success
                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"exchange_type"];
    }
    
    if (money) {
        [parameters setObject:money forKey:@"pay_earning"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/exchangeInEarning.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

// Withdraw history
+ (void)getExchangeEarningHistory:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getExchangeEarningHistory.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
#pragma mark 一元购
#pragma mark 图表
// /appInterface/getTrendChart.jhtml
+ (void)TrendChartGoods:(NSString *)goodsID
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goodsID && ![goodsID isEqualToString:@"null"]) {
        [parameters setObject:goodsID forKey:@"good_id"];
    }
//    MLog(@"parameters%@",parameters);
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getTrendChart.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}
//getChartGoodsInfoData.jhtml

+ (void)GetChartGoodsInfoDat:(NSString *)goods_fight_id
                success:(void (^)(NSDictionary *resultDic))success
                   fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (goods_fight_id && ![goods_fight_id isEqualToString:@"null"]) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }
    MLog(@"parameters,parameters%@",parameters);
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getChartGoodsInfoData.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}
/*一元购*/
#pragma mark - 0元购


+ (void)shareFreeGoodsSucceed:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/shareFreeGoodsSucceed.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

+ (void)paymentFreeGoods:(NSString *)goodsID
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (goodsID && ![goodsID isEqualToString:@"null"]) {
        [parameters setObject:goodsID forKey:@"goods_fight_id"];
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/paymentFreeGoods.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

+ (void)getIndexFreeGoodsList:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getIndexFreeGoodsList.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

+ (void)getOneWeekFreeGoodsList:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getOneWeekFreeGoodsList.jhtml"];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
#pragma mark 大转盘



//大转盘数据
+ (void)playRotaryGame:(void (^)(NSDictionary *data))success
               failure:(void (^)(NSString *description))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        
        [parameters setObject:@"" forKey:@"user_id"];
    }
    NSString *path = [self apiWithEntPathExtension:@"playRotaryGame.jhtml"];
    //   NSString *path = @"http://192.168.1.8:8080/GetTreasureAppSesame/appInterface/playRotaryGame.jhtml";
    [self postWithDictionary:parameters path:path success:success fail:failure];
}

//getRotaryGameHistory.jhtml
+(void)getRotaryGameHistory:(NSString *)pageNum
                   limitNum:(NSString *)limitNum
                    success:(void (^)(NSDictionary *data))success
                    failure:(void (^)(NSString *description))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        
        [parameters setObject:@"" forKey:@"user_id"];
    }
    NSString *path = [self apiWithEntPathExtension:@"getRotaryGameHistory.jhtml"];
    //    NSString *path = @"http://192.168.1.8:8080/GetTreasureAppSesame/appInterface/getRotaryGameHistory.jhtml";
    [self postWithDictionary:parameters path:path success:success fail:failure];
}


+(void)getRotaryGameAllHistory:(NSString *)pageNum
                      limitNum:(NSString *)limitNum
                       success:(void (^)(NSDictionary *data))success
                       failure:(void (^)(NSString *description))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    [parameters setObject:@"0" forKey:@"user_id"];
    NSString *path = [self apiWithEntPathExtension:@"getRotaryGameHistory.jhtml"];
    //    NSString *path = @"http://192.168.1.8:8080/GetTreasureAppSesame/appInterface/getRotaryGameHistory.jhtml";
    [self postWithDictionary:parameters path:path success:success fail:failure];
}


/**
 * 获取大转盘大奖历史纪录
 */
+ (void)getRotaryGameHistoryWithPageNum:(NSString *)pageNum
                               limitNum:(NSString *)limitNum
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetRotaryGameHistory];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取分类下商品列表
 *
 */
+ (void)getGoodsListOfTypeWithGoodsTypeIde:(NSString *)goodsTypeId
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsTypeId) {
        [parameters setObject:goodsTypeId forKey:@"goodsTypeId"];
    }else{
        [parameters setObject:@"" forKey:@"goodsTypeId"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetGoodsListOfType];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


+ (void)searchGoodsWithSearchKey:(NSString *)searchKey
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (searchKey) {
        [parameters setObject:searchKey forKey:@"searchKey"];
    }else{
        [parameters setObject:@"" forKey:@"searchKey"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_SearchGoodsInfo];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}

/**
 * 获取往期揭晓数据
 *
 */
+ (void)getOldDuoBaoDataWithGoodsId:(NSString *)good_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (good_id) {
        [parameters setObject:good_id forKey:@"good_id"];
    }else{
        [parameters setObject:@"" forKey:@"good_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetOldDuoBaoData];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 查询是否有某期活动
 *
 */
+ (void)queryPeriodWithGoodsId:(NSString *)good_id
                   good_period:(NSString *)good_period
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (good_id) {
        [parameters setObject:good_id forKey:@"good_id"];
    }else{
        [parameters setObject:@"" forKey:@"good_id"];
    }
    
    if (good_period) {
        [parameters setObject:good_period forKey:@"good_period"];
    }else{
        [parameters setObject:@"" forKey:@"good_period"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_QueryPeriod];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 加载商品详情
 *
 */
+ (void)loadGoodsDetailInfoWithGoodsId:(NSString *)goods_fight_id
                                userId:(NSString *)user_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_LoadGoodsDetailInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取活动记录（参与活动的所以人）
 *
 */
+ (void)loadDuoBaoRecordWithGoodsId:(NSString *)goods_fight_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_LoadDuoBaoRecord];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}



// 米豆商城足额直接购买
+ (void)purchaseWithThriceCoin:(NSString *)goods_fight_ids
                       goodsID:(NSString *)goods_ids
                    thriceCoin:(int)thriceCoin
                       success:(void (^)(NSDictionary *data))success
                       failure:(void (^)(NSString *description))failure
{
    int goodsCount = 0;
    NSArray *thricePurchaseArray = [NSArray array];
    NSString *is_shop_cart = @"n";
    NSString *ticket_send_id = @"";
    int exchangedThriceCoin = thriceCoin;
    NSString *buyType = @"now";
    
    
    NSString *payType = @"money";
    NSString *fights_choices = [ServerProtocol fights_choices:thricePurchaseArray];
    NSString *fights_counts = [ServerProtocol fights_counts:thricePurchaseArray];
    NSString *goods_buy_nums = [NSString stringWithFormat:@"%d", goodsCount];
    NSString *happy_bean_price = [NSString stringWithFormat:@"%d", exchangedThriceCoin];
    
    
    is_shop_cart = is_shop_cart?:@"n";
    goods_fight_ids = goods_fight_ids?:@"";
    ticket_send_id = ticket_send_id?:@"";
    fights_choices = fights_choices?:@"";
    fights_counts = fights_counts?:@"";
    goods_buy_nums = goods_buy_nums?:@"";
    happy_bean_price = happy_bean_price?:@"";
    goods_ids = goods_ids?:@"";
    buyType = buyType?:@"";
    
    
    if ([goods_fight_ids isKindOfClass:[NSNumber class]]) {
        goods_fight_ids = [NSString stringWithFormat:@"%lld", [goods_fight_ids longLongValue]];
    }
    if ([goods_ids isKindOfClass:[NSNumber class]]) {
        goods_ids = [NSString stringWithFormat:@"%lld", [goods_ids longLongValue]];
    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:payType forKey:@"payType"];
    [parameters setObject:goods_fight_ids forKey:@"goods_fight_ids"];
    [parameters setObject:is_shop_cart forKey:@"is_shop_cart"];
    [parameters setObject:ticket_send_id forKey:@"ticket_send_id"];
    [parameters setObject:fights_choices forKey:@"fights_choices"];
    [parameters setObject:fights_counts forKey:@"fights_counts"];
    [parameters setObject:@"1" forKey:@"goods_buy_nums"];
    [parameters setObject:happy_bean_price forKey:@"happy_bean_price"];
    [parameters setObject:goods_ids forKey:@"goods_ids"];
    [parameters setObject:buyType forKey:@"buyType"];
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    NSString *path = [self apiWithEntPathExtension:@"buyHappyBeanGoods.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:path success:success fail:failure];
}

/**
 * 获取活动记录
 * status: 活动状态[全部、已揭晓、进行]
 */
+ (void)getDuoBaoRecordWithUserid:(NSString *)user_id
                           status:(NSString *)status
                          pageNum:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (status) {
        [parameters setObject:status forKey:@"status"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    NSString *url = URL_GetDuoBaoRecordList;
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:url];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 我的中奖记录
 */
+ (void)getZJRecordWithUserid:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
           is_happybean_goods:(NSString *)is_happybean_goods
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
   
    if (is_happybean_goods) {
         [parameters setObject:is_happybean_goods forKey:@"is_happybean_goods"];
    }
    
    NSString *url = URL_GetOtherDuoBaoRecordList;
    
    NSString *myUserID = [ShareManager shareInstance].userinfo.id;
    if (user_id != nil && [myUserID isEqualToString:user_id]) {
        url = URL_GetZJRecord;
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:url];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
#pragma mark - 转赠
/**
 * 转赠发起
 */
+ (void)sendRecordWithUserid:(NSString *)user_id
                    order_id:(NSString *)order_id
                  order_type:(NSString *)order_type
                 receive_tel:(NSString *)receive_tel
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (order_id) {
        [parameters setObject:order_id forKey:@"id"];
    }
    
    if (order_type) {
        [parameters setObject:order_type forKey:@"order_type"];
    }
    if (receive_tel) {
        [parameters setObject:receive_tel forKey:@"receive_tel"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/donorOrder.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}

/**
 * 我的转赠记录
 */
+ (void)getRecordWithUserid:(NSString *)user_id
                    pageNum:(NSString *)pageNum
                   limitNum:(NSString *)limitNum
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    NSLog(@"params%@",parameters);
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getDonorList.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 转赠发起
 */
+ (void)affirmRecordWithUserid:(NSString *)user_id
                      order_id:(NSString *)order_id
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (order_id) {
        [parameters setObject:order_id forKey:@"id"];
        
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/receiveDonorOrder.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}


/**
 * 获取用户消息
 */
+(void)getUserInfoWithTell:(NSString *)tel
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (tel) {
        [parameters setObject:tel forKey:@"receive_tel"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getReceiveUser.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}

/**
 * 选择发货给转赠人
 */
+(void)sendToOther:(NSString *)orderID userid:(NSString *)userid
           success:(void (^)(NSDictionary *resultDic))success
              fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderID) {
        [parameters setObject:orderID forKey:@"id"];
    }
    if (userid) {
        [parameters setObject:userid forKey:@"userid"];
    }
    
    NSString *URLString = [self getEntURLbyKey:@"saveDonorOrderGetType.jhtml"];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}

#pragma mark - 晒单
/**
 * 晒单列表
 *
 */
+ (void)queryZoneListWithGoodsId:(NSString *)goods_fight_id
                  target_user_id:(NSString *)target_user_id
                         pageNum:(NSString *)pageNum
                        limitNum:(NSString *)limitNum
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (target_user_id) {
        [parameters setObject:target_user_id forKey:@"target_user_id"];
    }else{
        [parameters setObject:@"" forKey:@"target_user_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetZoneList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 晒单详情
 *
 */
+ (void)queryZoneDetailInfoWithGoodsId:(NSString *)bask_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (bask_id) {
        [parameters setObject:bask_id forKey:@"bask_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetZoneDetail];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 晒单分享回调或者app分享回调
 *
 */
+ (void)getShaiDanOrAppShareBackWithUserId:(NSString *)user_id
                                      type:(NSString *)type
                                 target_id:(NSString *)target_id
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    
    if (target_id) {
        [parameters setObject:target_id forKey:@"target_id"];
    }
    else
    {
        [parameters setObject:@"" forKey:@"target_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetShaiDanOrAppShareBack];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 发布晒单
 */
+ (void)publicShaiDanWithUserId:(NSString *)user_id
                 goods_fight_id:(NSString *)goods_fight_id
                          title:(NSString *)title
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }
    
    if (title) {
        [parameters setObject:title forKey:@"title"];
    }
    
    if (content) {
        [parameters setObject:content forKey:@"content"];
    }else{
        [parameters setObject:@"" forKey:@"content"];
    }
    
    if (imgs) {
        [parameters setObject:imgs forKey:@"imgs"];
    }else{
        [parameters setObject:@"" forKey:@"imgs"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_PublishFightBask];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 查看活动号码
 *
 */
+ (void)loadDuoBaoLuckNumWithGoodsId:(NSString *)goods_fight_id
                             user_id:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_LoadDuoBaoLuckNum];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}



+ (void)getMallGoods:(int)pageNum
            limitNum:(int)limitNum
             success:(void (^)(NSDictionary *resultDic))success
             failure:(void (^)(NSString *description))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *pageNumStr = [NSString stringWithFormat:@"%d", pageNum];
    NSString *limitNumStr = [NSString stringWithFormat:@"%d", limitNum];
    
    NSString *user_id = [ShareManager shareInstance].userinfo.id;
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (pageNumStr) {
        [parameters setObject:pageNumStr forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNumStr) {
        [parameters setObject:limitNumStr forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    NSString *path = [self apiWithEntPathExtension:@"getHappyGoodsList.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:path success:success fail:failure];
}


/**
 * 修改订单地址
 */
+ (void)changeOrderAddressWithOrderId:(NSString *)orderId
                       consignee_name:(NSString *)consignee_name
                        consignee_tel:(NSString *)consignee_tel
                    consignee_address:(NSString *)consignee_address
                           order_type:(NSString *)order_type
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderId) {
        [parameters setObject:orderId forKey:@"id"];
    }
    
    
    if (consignee_name) {
        [parameters setObject:consignee_name forKey:@"consignee_name"];
    }
    
    if (consignee_tel) {
        [parameters setObject:consignee_tel forKey:@"consignee_tel"];
    }
    
    if (consignee_address) {
        [parameters setObject:consignee_address forKey:@"consignee_address"];
    }
    if (order_type) {
        [parameters setObject:order_type forKey:@"order_type"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_ChangeOrderAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 选择充值卡兑换方式
 */
+ (void)setCardCollectPrizeMode:(NSString *)orderID
                 virtualGetType:(NSString *)type
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderID) {
        [parameters setObject:orderID forKey:@"id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"virtualGetType"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_ChangeCardCollectPrize];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 选择充值卡兑换方式
 */
+ (void)setCardDonorCollectPrizeMode:(NSString *)orderID
                      virtualGetType:(NSString *)type
                          order_type:(NSString *)order_type
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderID) {
        [parameters setObject:orderID forKey:@"id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"virtualGetType"];
    }
    NSString *URLString = [self getURLbyKey:URL_ChangeCardCollectPrizeDonor];
    //拼接:URL_Server+keyURL
    if ([order_type isEqual:@"donor"]) {
        URLString = [self getEntURLbyKey:URL_ChangeCardCollectPrizeDonor];
    }else{
        
        URLString = [self getEntURLbyKey:URL_ChangeCardCollectPrize];
    }
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


#pragma mark - 最新揭晓
/**
 * 获取最新揭晓数据
 *
 */
+ (void)getZXJXWithPageNum:(NSString *)pageNum
                  limitNum:(NSString *)limitNum
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetZXJX];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 余额购买
+(void)buyGoodForMyMoneyWithGoodId:(NSString *)goods_id
                           buy_num:(NSString *)num
                       coupons_ids:(NSArray *)coupons_ids
                              type:(NSString *)type
                           user_id:(NSString *)user_id
                    consignee_name:(NSString *)consignee_name
                     consignee_tel:(NSString *)consignee_tel
                 consignee_address:(NSString *)consignee_address
                            remark:(NSString *)remark
                        express_id:(NSString *)express_id
                           success:(void (^)(NSDictionary *data))success
                           failure:(void (^)(NSString *description))failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"money" forKey:@"payType"];
    if (goods_id) {
        [parameters setObject:goods_id forKey:@"goods_id"];
    }else{
        MLog(@"没有goods_id参数");
        return;
    }
    
    if (num) {
        [parameters setObject:num forKey:@"buy_num"];
    }else{
        MLog(@"没有num参数");
        return;
    }
    
    if (coupons_ids) {
        NSArray * array= coupons_ids;
        NSString *ns=[array componentsJoinedByString:@","];
        [parameters setObject:ns forKey:@"coupons_ids"];
    }else{
        MLog(@"没有coupons_ids参数");
        return;
    }
    
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }else{
        MLog(@"没有type参数");
        return;
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        MLog(@"没有user_id参数");
        return;
    }
    
    if (consignee_name) {
        [parameters setObject:consignee_name forKey:@"consignee_name"];
    }else{
        MLog(@"没有consignee_name参数");
        return;
    }
    
    if (consignee_tel) {
        [parameters setObject:consignee_tel forKey:@"consignee_tel"];
    }else{
        MLog(@"没有consignee_tel参数");
        return;
    }
    
    if (consignee_address) {
        [parameters setObject:consignee_address forKey:@"consignee_address"];
    }else{
        MLog(@"没有consignee_address参数");
        return;
    }
    
    if (remark) {
        [parameters setObject:remark forKey:@"remark"];
    }else{
        MLog(@"没有remark参数");
        return;
    }
    
    if (express_id) {
        [parameters setObject:express_id forKey:@"express_id"];
    }else{
        MLog(@"没有express_id参数");
        return;
    }
    
    NSString *path = [self apiWithEntPathExtension:@"paymentOrderGoods.jhtml"];
    
    [self postHttpWithDic:parameters urlStr:path success:success fail:failure];
    
}



#pragma mark - 购物车

/**
 * 添加购物车
 *
 */
+ (void)addGoodsForShopCartWithUserId:(NSString *)user_id
                            goods_ids:(NSString *)goods_ids
                       goods_buy_nums:(NSString *)goods_buy_nums
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (goods_ids) {
        [parameters setObject:goods_ids forKey:@"goods_ids"];
    }
    if (goods_buy_nums) {
        [parameters setObject:goods_buy_nums forKey:@"goods_buy_nums"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_AddShopCart];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取购物车列表
 *
 */
+ (void)getShopCartListWithUserId:(NSString *)user_id
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetShopCarList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 修改购物车商品
 *
 */
+ (void)changeShopCartListInfoWithGoodsId:(NSString *)goodsId
                                 goodsNum:(NSString *)goods_buy_num
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"goods_id"];
    }
    
    if (goods_buy_num) {
        [parameters setObject:goods_buy_num forKey:@"goods_buy_num"];
    }
    
    if ([ShareManager shareInstance].userinfo.id) {
        [parameters setObject:[ShareManager shareInstance].userinfo.id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_ChangeShopCarListInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 删除购物车
 *
 */
+ (void)deleteShopCartListInfoWithGoodsId:(NSString *)goodsIds
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsIds) {
        [parameters setObject:goodsIds forKey:@"ids"];
    }
    if ([ShareManager shareInstance].userinfo.id) {
        [parameters setObject:[ShareManager shareInstance].userinfo.id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_DeleteShopCart];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}



#pragma mark - 首页
/**
 * 获取首页商品数据
 *
 * order_by_name: 排序字段名称[now_people(人气),create_time(最新),progress(进度),need_people(总需人次)
 * order_by_rule: 排序规则[desc,asc]
 *
 */
#pragma mark - 获取基础数据
+ (void)getEntHttpWithUrlStr:(NSString *)urlStr
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    NSString *URLString = [self getEntURLbyKey:urlStr];
    [self getHttpBaseQuestWithUrl:URLString success:success fail:fail];
}


+ (void)getGoodsListWithOrder_by_name:(NSString *)order_by_name
                        order_by_rule:(NSString *)order_by_rule
                              pageNum:(NSString *)pageNum
                             limitNum:(NSString *)limitNum
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (order_by_name) {
        [parameters setObject:order_by_name forKey:@"order_by_name"];
    }
    if (order_by_rule) {
        [parameters setObject:order_by_rule forKey:@"order_by_rule"];
    }else{
        [parameters setObject:@"" forKey:@"order_by_rule"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    if ([ShareManager shareInstance].userinfo.id) {
        [parameters setObject:[ShareManager shareInstance].userinfo.id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetGoodsInfoList];
    
    if ([ShareManager shareInstance].isEnterMK == YES) {
        URLString = [self getEntURLbyKey:URL_SexGetGoodsInfoList];
    }else{
         URLString = [self getEntURLbyKey:URL_GetIndexTHGoodsList];
    }

    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

+ (void)getPKGoodsListWithOrder_by_name:(NSString *)order_by_name
                        order_by_rule:(NSString *)order_by_rule
                              pageNum:(NSString *)pageNum
                             limitNum:(NSString *)limitNum
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (order_by_name) {
        [parameters setObject:order_by_name forKey:@"order_by_name"];
    }
    if (order_by_rule) {
        [parameters setObject:order_by_rule forKey:@"order_by_rule"];
    }else{
        [parameters setObject:@"" forKey:@"order_by_rule"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    if ([ShareManager shareInstance].userinfo.id) {
        [parameters setObject:[ShareManager shareInstance].userinfo.id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetPKGoodsInfoList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


+ (void)getTHGoodsListsuccess:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if ([ShareManager shareInstance].userinfo.id) {
        [parameters setObject:[ShareManager shareInstance].userinfo.id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:URL_GetIndexTHGoodsList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

//
/**
 * 获取中奖订单
 */
+ (void)getFightOneWinRecord:(NSString *)userID
                     orderID:(NSString *)orderID
                  order_type:(NSString *)order_type
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderID) {
        [parameters setObject:orderID forKey:@"order_id"];
    }
    
    if (userID) {
        [parameters setObject:userID forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getEntURLbyKey:@"appInterface/getFightOneWinRecordList.jhtml"];
    if ([order_type isEqual:@"donor"]) {
        URLString = [self getEntURLbyKey:@"appInterface/getFightOneDonorRecord.jhtml"];
    }else{
        
        URLString = [self getEntURLbyKey:@"appInterface/getFightOneWinRecordList.jhtml"];
    }
    
    
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}




#pragma mark - 获取分类相关数据
+(void)getChangeJiFenWithID:(NSString *)userID
                     getUserId:(NSString *)getUserId
                    changeNum:(NSString *)changeNum
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (userID) {
        [parameters setObject:userID forKey:@"userID"];
    }else{
        MLog(@"缺少参赛userID");
    }
    if (getUserId) {
        [parameters setObject:getUserId forKey:@"getUserId"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (changeNum) {
        [parameters setObject:changeNum forKey:@"changeNum"];
    }else{
        MLog(@"缺少参赛page");;
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeJiFen];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 积分明细
+(void)getChangeJiFenDetialWithID:(NSString *)userID
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (userID) {
        [parameters setObject:userID forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛userID");
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeDetial];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 积分明细
+(void)getScoreListWithID:(NSString *)userID
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (userID) {
        [parameters setObject:userID forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛userID");
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetScoreList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 转让红包
+(void)getChangeScoresWithID:(NSString *)userID
                  getUserId:(NSString *)getUserId
                  changeScores:(NSString *)changeScores
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (userID) {
        [parameters setObject:userID forKey:@"userID"];
    }else{
        MLog(@"缺少参赛userID");
    }
    if (getUserId) {
        [parameters setObject:getUserId forKey:@"getUserId"];
    }else{
        MLog(@"缺少参赛page");
    }
    if (changeScores) {
        [parameters setObject:changeScores forKey:@"changeScores"];
    }else{
        MLog(@"缺少参赛page");;
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeScores];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
#pragma mark - 签到
+(void)getQianDaoDateWithUserId:(NSString *)userId
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        [parameters setObject:userId forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛userID");
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_QianDao];
//     MLog(@"userID%@",parameters);
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


+(void)qianDaoWithUserId:(NSString *)userId
                     tag:(NSString *)tag
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        [parameters setObject:userId forKey:@"user_id"];
    }else{
        MLog(@"缺少参赛userID");
    }
    if (tag) {
        [parameters setObject:tag forKey:@"tag"];
    }else{
        MLog(@"缺少参赛tag");
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_QianDaoTag];
    //     MLog(@"userID%@",parameters);
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


@end
