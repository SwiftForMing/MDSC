//
//  AppDelegate.m
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/4/16.
//  Copyright © 2018年 黎应明. All rights reserved.
//


//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                           O\  =  /O
//                        ____/`---'\____
//                      .'  \\|     |//  `.
//                     /  \\|||  :  |||//  \
//                    /  _||||| -:- |||||-  \
//                    |   | \\\  -  /// |   |
//                    | \_|  ''\---/''  |   |
//                    \  .-\__  `-`  ___/-. /
//                   ___`. .'  /--.--\  `. . __
//                ."" '<  `.___\_<|>_/___.'  >'"".
//              | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//              \  \ `-.   \_ __\ /__ _/   .-` /  /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                    佛祖保佑         永无BUG


#import "AppDelegate.h"
#import "BaseTabBarViewController.h"
#import "Tool.h"
//腾讯SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "SPayClient.h"

#import <MeiQiaSDK/MQManager.h>

#import "AlertViewOperation.h"

#import "AFNetworking.h"

#import <UserNotifications/UserNotifications.h>

static NSString *const testAppKey = @"24994496";
static NSString *const testAppSecret = @"a287bdf48dd913f644fa365704f91edd";

@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation AppDelegate{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*  获取服务器配置信息
     *
     *  1.校验版本判断是否正在进行苹果审核
     *  2.是否需要强制更新
     */
    [self monitorNetworking];
    [Tool getServerConfigure];
    
    [NSThread sleepForTimeInterval:2.0];
    
    
    //web加载内存控制
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 30*1024*1024; // 30MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    [Tool getUserInfoFromSqlite];
    application.applicationIconBadgeNumber = 0;
    //注册推送
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    [self initCloudPush];
    // 监听推送通道打开动作
    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    
    [CloudPushSDK sendNotificationAck:launchOptions];

    
    // Google analytics
    //    [GA init];
    //    [GA enable];
    
    // 微信注册
    [self initWXApi];
    
    [self initShareFunction];
    //#error 请填写您的美洽 AppKey
    [MQManager initWithAppkey:kMeiQiaAppKey completion:^(NSString *clientId, NSError *error) {
        if (!error) {
            MLog(@"美洽 SDK：初始化成功");
        } else {
            MLog(@"美洽error:%@", error);
        }
    }];
    
    
    //推送注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    [self autoLogin];
    
    //2.判断程序是不是第一次启动
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] boolForKey:@"isFirst"];

    if (!isFirst) {
        //是第一次启动
        //1.设置已经启动过的标识
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirst"];
        //2.展示引导页
        self.window.rootViewController = [[LeadeViewController alloc]init];
    }else{
        BOOL isMK = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMK"];
        if (isMK) {
            [ShareManager shareInstance].isEnterMK = YES;
            EntTabBarViewController *tabVC = [[EntTabBarViewController alloc]init];
            self.window.rootViewController = tabVC;
        }else{
            BaseTabBarViewController *tabVC = [[BaseTabBarViewController alloc]init];
            self.window.rootViewController = tabVC;
        }
       
    }
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
    wechatConfigModel.appScheme = @"wx4309f9639f60286a";
    wechatConfigModel.wechatAppid = @"wx4309f9639f60286a";
    
    wechatConfigModel.isEnableMTA =YES;
    
    //配置微信APP支付
    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
    [[SPayClient sharedInstance] application:application
               didFinishLaunchingWithOptions:launchOptions];
    
    // 配置支付宝支付
    SPayClientAlipayConfigModel *alipayConfigModel = [[SPayClientAlipayConfigModel alloc] init];
    alipayConfigModel.appScheme = @"MiHuaTang";
    [[SPayClient sharedInstance] alipayAppConfig:alipayConfigModel];
    
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
    
    return YES;
}









//App 进入后台时，关闭美洽服务
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MQManager closeMeiqiaService];
}

//App 进入前台时，开启美洽服务
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [MQManager openMeiqiaService];
    MLog(@"更新用户信息");
    //    [self autoLogin];
    [Tool getUserInfo];
}

- (void)autoLogin
{
    if ([Tool islogin])
    {
        if (![ShareManager shareInstance].userinfo) {
            return;
        }
        
        // Token未失效, 不用自动登录
        BOOL tokenIsValid = [LoginModel validateToken];
        if (tokenIsValid) {
            return;
        }
        
        [Tool autoLoginSuccess:^(NSDictionary *resultDic) {
            
            NSInteger resultCode = [resultDic[@"status"] integerValue];
            if (resultCode != 0) {
                MLog(@"自动登录失败");
                [ShareManager shareInstance].userinfo.islogin = NO;
                
            }else{
                MLog(@"自动登录成功%@",resultDic);
                [ShareManager shareInstance].userinfo.islogin = YES;
//                UserInfo *info = [resultDic objectByClass:[UserInfo class]];
//                [ShareManager shareInstance].userinfo = info;
//                [Tool saveUserInfoToDB:YES];
                [Tool httpAddressList];
            }
            
        } fail:^(NSString *description) {
            MLog(@"fail自动登录失败%@",description);
            [ShareManager shareInstance].userinfo.islogin = NO;
        }];
    }
}


//检测网络状态
-(void)monitorNetworking
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                MLog(@"未知网络");
                [ShareManager shareInstance].isNotNet = NO;
                break;
            case 0:
                MLog(@"网络不可用");
                [ShareManager shareInstance].isNotNet = NO;
                break;
            case 1:
            {
                MLog(@"GPRS网络");
                [ShareManager shareInstance].isNotNet = YES;
                //发通知，带头搞事
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"1" userInfo:nil];
            }
                break;
            case 2:
            {
                MLog(@"wifi网络");
                [ShareManager shareInstance].isNotNet = YES;
                //发通知，搞事情
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"2" userInfo:nil];
            }
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            //            MLog(@"有网");
        }else{
            //            MLog(@"没网");
        }
    }];
}




//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - 各平台回调

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *,id> *)options{
    MLog(@"optionsalipayURL%@",url);
    if([url.host isEqualToString:@"data_success"])
    {
        //在safari中支付成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessInSafari object:nil userInfo:nil];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        NSString *str = url.query;
        NSDictionary *resultDict = [str.stringByRemovingPercentEncoding objectFromJSONString];
        if (resultDict) {
            NSDictionary *dict = [resultDict objectForKey:@"memo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayNotification object:nil userInfo:dict];
        }
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      MLog(@"processOrderWithPaymentResult = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    
    if ([url.host isEqualToString:@"pay"])
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    [[SPayClient sharedInstance] application:app openURL:url options:options];
    
    return YES;
};

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    MLog(@"sourceApplicationalipayURL%@",url);
    if([url.host isEqualToString:@"data_success"])
    {
        //在safari中支付成功
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccessInSafari object:nil userInfo:nil];
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        
        
        NSString *str = url.query;
        NSDictionary *resultDict = [str.stringByRemovingPercentEncoding objectFromJSONString];
        if (resultDict) {
            NSDictionary *dict = [resultDict objectForKey:@"memo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAlipayNotification object:nil userInfo:dict];
        }
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      MLog(@"processOrderWithPaymentResult = %@",resultDic);
                                                      NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
                                                      [self handlePayResultNotification:resultStatue];
                                                  }];
    }
    
    if ([url.host isEqualToString:@"pay"])
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    [[SPayClient sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    return YES;
    
    //    return [ShareSDK handleOpenURL:url
    //                 sourceApplication:sourceApplication
    //                        annotation:annotation
    //                        wxDelegate:self];
}

/**
 *  支付结果处理支付结果
 */
- (void)handlePayResultNotification:(NSString *)resultStatue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPaySuccess object:@{@"resultStatue":[resultStatue init]}];
    switch ([resultStatue intValue] ) {
            
        case 9000:
            [Tool showPromptContent:@"恭喜您，支付成功！" onView:self.window];
            break;
        case 8000:
            [Tool showPromptContent:@"正在处理中,请稍候查看！" onView:self.window];
            break;
        case 4000:
            [Tool showPromptContent:@"很遗憾，您此次支付失败，请您重新支付！" onView:self.window];
            break;
        case 6001:
            [Tool showPromptContent:@"您已取消了支付操作！" onView:self.window];
            break;
        case 6002:
            [Tool showPromptContent:@"网络连接出错，请您重新支付！" onView:self.window];
            break;
        default:
            break;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    MLog(@"%@ %@", NSStringFromSelector(_cmd), url);
    
    return  [[SPayClient sharedInstance] application:application handleOpenURL:url];
    
    //    return [ShareSDK handleOpenURL:url  wxDelegate:self];
}

//#pragma mark - 微信支付回调
#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    MLog(@"%@", NSStringFromSelector(_cmd));
}

-(void)onResp:(BaseResp *)resp{
    
    MLog(@"%@", NSStringFromSelector(_cmd));
    
    NSString *strTitle;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        int isSuccess  = 0;
        
        switch (resp.errCode) {
            case WXSuccess:
            {
                MLog(@"支付成功!");
                [[NSNotificationCenter defaultCenter] postNotificationName:kWXPaySuccess object:nil];
                isSuccess = 0;
            }
                break;
            case WXErrCodeCommon:
                isSuccess = -1;
                break;
            case WXErrCodeUserCancel:
                isSuccess = -2;
                break;
            case WXErrCodeSentFail:
                isSuccess = -3;
                break;
            case WXErrCodeUnsupport:
                isSuccess = -5;
                break;
            case WXErrCodeAuthDeny:
                isSuccess = -4;
                break;
            default:
                break;
        }
        
        NSDictionary *parameters = nil;
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",isSuccess],@"statue",nil];
        //登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinPayNotif object:nil userInfo:parameters];
        
    }
}


#pragma mark -

- (void)initWXApi
{
    [WXApi registerApp:WeiXinKey];
    BOOL result = [WXApi isWXAppInstalled];
    MLog(@"isWXAppInstalled = %d", result);
    
    result = [WXApi isWXAppSupportApi];
    MLog(@"isWXAppSupportApi = %d", result);
    
    MLog(@"getApiVersion %@", [WXApi getApiVersion]);
}

#pragma mark - init sharesdk

- (void)initShareFunction
{
    // ShareSDK
    //    [ShareSDK registerApp:@"1c05c5f5ff82f"
    [ShareSDK registerApp:@"218bd186360c4"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeTencentWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                     
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:WeiBoKey
                                                appSecret:WeiBoSecret
                                              redirectUri:@"http://sns.whalecloud.com/sina2/callback"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      //设置微信应用信息
                      [appInfo SSDKSetupWeChatByAppId:WeiXinKey
                                            appSecret:WeiXinSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      //设置QQ应用信息，其中authType设置为只用SSO形式授权
                      [appInfo SSDKSetupQQByAppId:QQKey
                                           appKey:QQSecret
                                         authType:SSDKAuthTypeSSO];
                      break;
                  default:
                      break;
              }
          }];
    
}


#pragma mark - jpush
/**
 *    向APNs注册，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        if (@available(iOS 10.0, *)) {
            _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
            // 创建category，并注册到通知中心
            [self createCustomNotificationCategory];
            _notificationCenter.delegate = self;
            // 请求推送权限
            [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    // granted
                    NSLog(@"User authored notification.");
                    // 向APNs注册，获取deviceToken
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [application registerForRemoteNotifications];
                    });
                } else {
                    // not granted
                    NSLog(@"User denied notification.");
                }
            }];
        } else {
            // Fallback on earlier versions
        }
      
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus {
    if (@available(iOS 10.0, *)) {
        [_notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                NSLog(@"User authed.");
            } else {
                NSLog(@"User denied.");
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

/*
 *  APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Upload deviceToken to CloudPush server.");
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *  创建并注册通知category(iOS 10+)
 */
- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    if (@available(iOS 10.0, *)) {
        UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
        UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
        // 创建id为`test_category`的category，并注册两个action到category
        // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
        UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                            UNNotificationCategoryOptionCustomDismissAction];
        // 注册category到通知中心
        [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
    } else {
        // Fallback on earlier versions
    }
   
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleiOS10Notification:(UNNotification *)notification  API_AVAILABLE(ios(10.0)){
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    // 通知时间
    NSDate *noticeDate = notification.date;
    // 标题
    NSString *title = content.title;
    // 副标题
    NSString *subtitle = content.subtitle;
    // 内容
    NSString *body = content.body;
    // 角标
    int badge = [content.badge intValue];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *extras = [userInfo valueForKey:@"Extras"];
    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    NSLog(@"Notification, date: %@, title: %@, subtitle: %@, body: %@, badge: %d, extras: %@.", noticeDate, title, subtitle, body, badge, extras);
}

/**
 *  App处于前台时收到通知(iOS 10+)
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSLog(@"Receive a notification in foregound.");
    // 处理iOS 10通知，并上报通知打开回执
    [self handleiOS10Notification:notification];
    // 通知不弹出
    completionHandler(UNNotificationPresentationOptionNone);
    
    // 通知弹出，且带有声音、内容和角标
    //completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}

/**
 *  触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
 */

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleiOS10Notification:response.notification];
    }
    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
    }
    NSString *customAction1 = @"action1";
    NSString *customAction2 = @"action2";
    // 点击用户自定义Action1
    if ([userAction isEqualToString:customAction1]) {
        NSLog(@"User custom action1.");
    }
    
    // 点击用户自定义Action2
    if ([userAction isEqualToString:customAction2]) {
        NSLog(@"User custom action2.");
    }
    completionHandler();
}

#pragma mark SDK Init
- (void)initCloudPush {
    // 正式上线建议关闭
//    [CloudPushSDK turnOnDebug];
    // SDK初始化，手动输出appKey和appSecret
        [CloudPushSDK asyncInit:testAppKey appSecret:testAppSecret callback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            } else {
                NSLog(@"Push SDK init failed, error: %@", res.error);
            }
        }];
    
   
}

#pragma mark Notification Open
/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得通知自定义字段内容，例：获取key为"Extras"的内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 同步通知角标数到服务端
    // [self syncBadgeNum:0];
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}

#pragma mark Channel Opened
/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *    推送通道打开回调
 *
 *    @param     notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
//    [Tool showAlert:@"温馨提示" content:@"消息通道建立成功"];
}

#pragma mark Receive Message
/**
 *    @brief    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jpfNetworkDidReceiveMessage:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}

/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    NSLog(@"Receive one message!");
    
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    
  
}


/* 同步通知角标数到服务端 */
- (void)syncBadgeNum:(NSUInteger)badgeNum {
    [CloudPushSDK syncBadgeNum:badgeNum withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Sync badge num: [%lu] success.", (unsigned long)badgeNum);
        } else {
            NSLog(@"Sync badge num: [%lu] failed, error: %@", (unsigned long)badgeNum, res.error);
        }
    }];
}


- (void)jpfNetworkDidReceiveMessage:(NSNotification *)notify
{
    CCPSysMessage *message = [notify object];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSData * datadic = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:datadic options:NSJSONReadingMutableLeaves error:nil];
    
     MLog(@"Receive message content: %@.", body);
    
//    NSDictionary *userInfo = notify.userInfo;
//    NSDictionary *dict = [userInfo objectForKey:@"extras"];
 
    NSString *messageType = [dict objectForKey:@"messageType"];
    
    NSDictionary *data = dict;
    
    // 是否支持版本
//    BOOL containThisVersion = NO;
//    NSDictionary *versionsDict = [dict objectForKey:@"versions"];
//    NSArray *versions = [[versionsDict objectForKey:@"ios"] componentsSeparatedByString:@","];
//    NSString *currenVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    for (NSString *version in versions) {
//        if ([version isEqualToString:currenVersion]) {
//            containThisVersion = YES;
//            break;
//        }
//    }
    
    // 字段为空支持所有版本
//    if (versions.count == 0) {
//        containThisVersion = YES;
//    }

        MLog(@"messageType%@",messageType);
        // 显示中奖动画
        if ([messageType isEqualToString:@"win_lottery"]) {
            
                NSOperation *operation = [[AlertViewOperation alloc] initWithWinningCrowdfundingData:data];
                [_operationQueue addOperation:operation];

            // 显示提示信息
        } else if ([messageType isEqualToString:@"show_alert_0"]) {
            
            NSString *message = [data objectForKey:@"message"];
            NSString *title = [data objectForKey:@"title"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            // 购买成功返回数据
        } else if ([messageType isEqualToString:@"payResult_alert"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kPayNotification object:nil userInfo:data];
            [Tool getUserInfo];
            MLog(@"NSNotificationCenterdatad%@",data);
            
            // 配置信息发生变化
        } else if ([messageType isEqualToString:@"configs_Change"]) {
            
            [Tool getConfigurePaymentChannels];
            
            // 小米兑换比例发生变化
        } else if ([messageType isEqualToString:@"happy_specific"]) {
            
            [self autoLogin];
            
            // 三赔中奖
        } else if ([messageType isEqualToString:@"sanpei_win_lottery"]) {
            
            NSString *status = [data objectForKey:@"status"];
            if (data && [status isEqualToString:@"待发货"]) {
                
                NSOperation *operation = [[AlertViewOperation alloc] initWithWinningThriceData:data];
                [_operationQueue addOperation:operation];
            }
        }else if([messageType isEqualToString:@"donor_alert"]){
            MLog(@"data%@",data);
            NSString *message = [data objectForKey:@"good_name"];
            NSString *message1 = [data objectForKey:@"good_period"];
            NSString *userid = [data objectForKey:@"user_id"];
            NSString *mes = [NSString stringWithFormat:@"用户(ID:%@)向您转让商品第[%@]期:%@",userid,message1,message];
            NSString *title = [data objectForKey:@"title"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:mes delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert show];
        }else if([messageType isEqualToString:@"update_userInfo"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserNotification object:nil userInfo:data];
            MLog(@"更新用户信息");
            [Tool getUserInfo];
        }
    
}




@end
