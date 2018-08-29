//
//  Tool.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/31.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  大小写选项
 */
typedef enum LetterCaseOption{
    UpperLetter = 1, //大写
    LowerLetter //小写
}LetterCaseOption;

@interface Tool : NSObject
/**
 *  显示提示信息
 *
 *  @param content  提示内容
 *  @param selfView 提示信息所在的页面
 */
+ (void)showPromptContent:(NSString *)content onView:(UIView *)selfView;
+ (void)showPromptContent:(NSString *)content;

//保存用户地址
+ (void)httpAddressList;

+ (void)getServerConfigure;
+ (void)getConfigurePaymentChannels;
/**
 *  present ViewController
 *
 *  @param viewController        presenting viewController
 *  @param presentViewController presented viewController
 *  @param animated              animation
 */
+ (void)presentModalFromViewController:(UIViewController *)viewController
                 presentViewController:(UIViewController *)presentViewController
                              animated:(BOOL)animated;
/**
 *  dismiss viewController
 *
 *  @param dismissViewController dismissed viewController
 *  @param animated              animation
 */
+ (void)dismissModalViewController:(UIViewController *)dismissViewController
                          animated:(BOOL)animated;

/**
 *  16进制颜色值转RGB
 *
 *  @param hexString 16进制字符串色值
 *
 *  @return RGB色值
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  保存图片到document
 */
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;

/**
 *  压缩图片
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  获取公共图片
 */
+ (UIImage *)imageInPublic:(NSString *)imageName;

/**
 *  获取连接的wifi的信息
 */
+ (NSDictionary *)wifiInfo;


/**
 *  全屏查看图片
 */
+ (void)FullScreenToSeePicture:(UIImage*)image;

/**
 *  获取当前时间
 *  @param dateFormatString 时间格式
 */
+ (NSString *)getCurrentTimeWithFormat:(NSString *)dateFormatString;

/*
 * 检查手机号是否合法
 *
 */

+ (BOOL)isMobileNumberClassification:(NSString*)phone;

/**
 *  判断用户是否登录
 */
+ (BOOL)islogin;

+ (BOOL)isTestAccount;

+ (NSString*)getUUID;
/**
 *  用户登录
 */
+ (void)loginWithAnimated:(BOOL)animated viewController:(UIViewController *)viewControl;

/**
 *  自动登录
 */
+ (void)autoLoginSuccess:(void (^)(NSDictionary *))success
                    fail:(void (^)(NSString *))fail;

//获取用户信息
+ (void)getUserInfo;
//+ (void)getUpDateUserInfo;
+ (void)saveSystemConfigureToDB:(SystemConfigure *)object;

+ (SystemConfigure *)getSystemConfigureFromDB;
/**
 *  统一收起键盘
 */
+ (void)hideAllKeyboard;

/**
 *  获取数据库相关信息(用户信息)
 */
+ (void)getUserInfoFromSqlite;

/**
 *  存储当前账号信息，本地只保存一次，覆盖逻辑
 */
+ (void)saveUserInfoToDB:(BOOL)islogin;

+ (void)saveUserModelToDB;

+ (void)showShareActionSheet:(UIView *)sender
                        text:(NSString *)text
                      images:(id)images
                         url:(NSURL *)url
                       title:(NSString *)title
                        type:(SSDKContentType)type
                  completion:(void (^)(SSDKResponseState state))completion;

/**
 *  指定大小压缩图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


/**
 * label 自适应字体大小
 */
+ (void)setFontSizeThatFits:(UILabel*)label;

/**
 *  32位MD5加密
 *
 *  @param string           加密字符串
 *  @param LetterCaseOption 加密选项 {UpperLetter:大写；LowerLetter:小写}
 *
 *  @return 加密后的字符串
 */
+ (NSString *)encodeUsingMD5ByString:(NSString *)srcString
                    letterCaseOption:(LetterCaseOption)letterCaseOption;


+(NSString *)getCurrentTime;

/*
 * 时间戳转为时间字符串
 *
 */
+ (NSString *)timeStringToDateSting:(NSString *)timestr format:(NSString *)format;

/**
 *  判断号码是否是合法手机号
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)validateMobile:(NSString *)checkString;

/**
 *  判断是否输入的金额是否合法
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (BOOL)isPureFloat:(NSString *)string;

/**
 *  随机生成字符串
 *
 *  @param checkString 号码
 *
 *  @return 判断结果
 */
+ (NSString *)randomlyGeneratedStrWithLength:(NSInteger)lenght;

/**
 *  发送短信
 *
 *  @param viewController 从哪个viewConotroller弹出的短信窗口
 *  @param recipients     收件人
 *  @param content        短信内容
 */
+ (void)sendMessageByViewController:(UIViewController *)viewController
                         recipients:(NSArray *)recipients
                            content:(NSString *)content;
/*
 * 校验身份证
 *
 */
+(BOOL)checkIdentityCardNo:(NSString*)cardNo;

//中奖动画
+ (void)showWinLottery:(NSDictionary *)data;




//把文字绘制到图片上
+ (UIImage *)imageToAddText:(UIImage *)img withText:(NSString *)text;

+ (UIImage *)getImage:(NSString *)name;
//一元购一

//上架屏蔽数据判断接口
+ (void)httpGetIsShowThridView;
+ (void)UIAdapte:(UIView *)superview deepth:(int)deepth;
// 生成二维码
+ (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size;

// 邀请好友注册链接
+ (NSString *)inviteFriendToRegisterAddress:(NSString *)recommendUserID;

+(void)getColorWithView:(UIView *)view leftColor:(NSString *)left rightColor:(NSString *)right;
//微信支付
+(void)jumpToWeiXinPay:(NSDictionary *)resultDic;

+(NSArray *)getHomeShowDatasWithArray:(NSArray *)array;

@end
