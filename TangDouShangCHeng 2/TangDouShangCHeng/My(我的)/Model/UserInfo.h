//
//  UserInfo.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, assign) BOOL islogin;   //是否登录
/*
"app_login_id" = 15309015564;
"fight_time" = 0;
"happy_bean_num" = 0;
id = 1215116;
"is_money_pay" = y;
"is_open" = y;
"jpush_id" = "";
"level_name" = "\U67e5\U65e0\U7b49\U7ea7";
"login_id" = "";
"nick_name" = "<null>";
nowTime = 1505289479537;
"oauth_token" = "tDdxSIJ32jUtJa2JFJ8THI9DqydZHv0ir5D_Dw46V5Q";
password = 123456;
"payment_id" = "<null>";
"payment_name" = "<null>";
"qq_login_id" = "<null>";
"recommend_user_id" = "";
"share_img" = "<null>";
"share_url" = "<null>";
shoppCartNum = 0;
token = "tDdxSIJ32jUtJa2JFJ8THF9L_RVfApas8iGskXLdbc8";
"user_header" = "<null>";
"user_ip" = "192.168.31.106";
"user_ip_address" = "\U5b9a\U4f4d\U5931\U8d25";
"user_is_sign" = y;
"user_money" = 0;
"user_money_all" = 0;
"user_score" = 0;
"user_score_all" = 0;
"user_tel" = 15309015564;
"weixin_login_id" = "<null>";
"win_time" = 0;
*/


@property (nonatomic, strong) NSString *app_login_id;
@property (nonatomic, strong) NSString *weixin_login_id;
@property (nonatomic, strong) NSString *qq_login_id;

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *is_open;// y;
@property (nonatomic, strong) NSString *is_robot;//n;
@property (nonatomic, strong) NSString *jpush_id;
@property (nonatomic, strong) NSString *level_name;
@property (nonatomic, strong) NSString *login_id;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *loginPassword;
@property (nonatomic, strong) NSString *payment_id;
@property (nonatomic, strong) NSString *payment_name;
@property (nonatomic, strong) NSString *recommend_user_id;//推荐人id
@property (nonatomic, strong) NSString *user_agency; //是否是代理
@property (nonatomic, strong) NSString *share_img;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *user_header;
@property (nonatomic, strong) NSString *user_ip;
@property (nonatomic, strong) NSString *user_ip_address;
@property (nonatomic, strong) NSString *user_is_sign;// n;
@property (nonatomic, assign) double user_money;
@property (nonatomic, assign) double user_money_all;
@property (nonatomic, assign) NSInteger user_score;
@property (nonatomic, assign) NSInteger user_score_all;
@property (nonatomic, strong) NSString *user_tel;
@property (nonatomic, strong) NSString *win_time;
@property (nonatomic, strong) NSString *donorAll_num;
@property (nonatomic, strong) NSString *donor_num;
@property (nonatomic, assign) double happy_bean_num;
@property (nonatomic, assign) NSInteger shoppCartNum;
@property (nonatomic, assign) NSInteger user_balance;
@property (nonatomic, strong) NSString *is_pay_check;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSString *home_show;
@property (nonatomic, strong) NSString *am_show;

+ (NSURL *)avatarURL;
- (NSURL *)avatarURL;
- (BOOL)hasAlias;


@end
