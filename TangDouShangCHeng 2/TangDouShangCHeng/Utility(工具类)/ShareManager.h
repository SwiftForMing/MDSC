//
//  ShareManager.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/1.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Reachability.h"
#import "UserInfo.h"
#import "LoginModel.h"
#import "SystemConfigure.h"
#import "RecoverAddressListInfo.h"
#import "InviteModel.h"
#import "UserModel.h"
typedef void (^selectImage_block_t)(UIImage* image,NSString* imageName);

@interface ShareManager : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

+ (ShareManager *)shareInstance;
@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, strong) UserInfo *userinfo;
@property (nonatomic, strong) InviteModel *inviteModel;
@property (nonatomic, strong) LoginModel *loginModel;
@property (nonatomic, strong) UserModel *usermodel;
@property (nonatomic, copy) NSString *passWord;
@property (nonatomic, strong) RecoverAddressListInfo *addressModel;
@property (nonatomic, assign) int shareType;//0 无 1文章分析 2 晒单分享 3 app分享
@property (nonatomic) BOOL isInReview;  // 是否正在审核中
@property (nonatomic) BOOL isEnterMK;
@property (nonatomic) BOOL isInYlc;
@property (nonatomic) BOOL isNotNet;
@property (nonatomic, copy) NSArray *configureArray;    //支付方式配置信息
@property (nonatomic, copy) NSArray *ClassifyData; 
@property (nonatomic, copy) NSString *token;
@property (nonatomic) NSInteger serverTimeDifference;       // 与服务器时间差
@property (nonatomic, strong) NSString *isShowThird;
@property (nonatomic, strong) NSString *serverPhoneNum;
@property (nonatomic, strong) NSString *domain;
//@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) SystemConfigure *configure;
+ (NSString *)userID;
/**
 *  添加监听：网络状态变化
 */
- (void)addReachabilityChangedObserver;

/**
 *  拨打电话
 *
 *  @param phoneNumber 要拨打的号码
 *   view 拨号所在的页面
 */
- (void)dialWithPhoneNumber:(NSString *)phoneNumber inView:(UIView *)selfView;

/**
 *  从相册或相机中获取照片
 *
 *  @param vc        需要选择的图片的 UIViewController
 *  @param block     获取到图片后的操作
 */
- (void)selectPictureFromDevice:(UIViewController*)vc isReduce:(BOOL)isreduce isSelect:(BOOL)isSelect isEdit:(BOOL)isEdit block:(selectImage_block_t)block;

// 登录成功后，保存支付方式配置信息
+ (void)initConfigure:(NSArray *)array;

+ (void)refreshToken;



@end
