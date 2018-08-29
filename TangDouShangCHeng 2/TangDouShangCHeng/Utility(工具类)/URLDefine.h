//
//  URLDefine.h
//  Esport
//
//  Created by linqsh on 15/5/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

/*** Server URL ***/

#if DEBUG

//正式服http://5208579b.nat123.cc/TaoQuan/
//#define URL_Server @"http://118.178.92.99:51501/TaoQuan/"
//#define URL_EntOneServer @"http://118.178.92.99:51501/TaoQuan/zmlgApi/"
//#define URL_MKEntOneServer @"http://118.178.92.99:51501/TaoQuan/zmkkApi/"

//阿里云服务器
#define URL_Server @"http://47.104.239.138:8080/TaoQuan/"
#define URL_EntOneServer @"http://47.104.140.87:8080/GetTreasureAppSesame/"
#define URL_MKEntOneServer @"http://47.104.140.87:8080/GetTreasureAppSesame/"

//自己服务器
//#define URL_Server @"http://f2048837y3.51mypc.cn:16147/TaoQuan/"
//#define URL_EntOneServer @"http://192.168.31.201:8080/GetTreasureAppSesame/"
//#define URL_MKEntOneServer @"http://f2048837y3.51mypc.cn:13970/GetTreasureAppSesame/"

////
//#define URL_Server @"http://192.168.31.168:8080/TaoQuan/"
//#define URL_EntOneServer @"http://192.168.31.168:8082/GetTreasureAppSesame/"
//#define URL_MKEntOneServer @"http://192.168.31.168:8082/GetTreasureAppSesame/"

#else
 //大包正式的url
#define URL_Server @"http://47.104.239.138:8080/TaoQuan/"
#define URL_EntOneServer @"http://47.104.140.87:8080/GetTreasureAppSesame/"
//秒开URL
#define URL_MKEntOneServer @"http://47.104.140.87:8080/GetTreasureAppSesame/"

#endif

//审核服务器
//#define URL_Server_Still @"http://118.178.92.99:51501/TaoQuan/"
//商城
//#define URL_ServerTest @"http://118.31.236.99:51301/TaoQuan/"
//一元购
//#define URL_EntOneServerTest @"http://118.31.236.99:51301/TaoQuan/"

#define URL_Server_Still @"http://47.104.239.138:8080/TaoQuan/"
#define URL_ServerTest @"http://47.104.239.138:8080/TaoQuan/"
#define URL_EntOneServerTest @"http://47.104.140.87:8080/GetTreasureAppSesame/"


//分享的url
#define URL_ShareServer @""


//图片地址
#define URL_UpdateImageUrl @"appInterface/uploadImg.jhtml"

//上架接口，判断是否隐藏第三方登录
#define URL_GetIsSJ @"appInterface/getStaticData.jhtml"


#pragma mark  登录注册模块

//获取验证码
#define URL_GetVerificationCode @"appInterface/getCode.jhtml"

//注册
#define URL_Register @"appInterface/addUser.jhtml"

//登陆
#define URL_Login @"appInterface/userLogin.jhtml"

//第三方登陆
#define URL_ThirdLogin @"appInterface/otherAddUser.jhtml"

//找回密码
#define URL_FindPwd @"appInterface/updateUserPassword.jhtml"

//第三方绑定接口
#define URL_BangDing @"appInterface/otherUserFirstLogin.jhtml"
//计算详情
#define Wap_JSXQ @"appInterface/countInfo.jhtml?"

#pragma mark  首页 
//获取基础数据
#define URL_HomeBasics @"appInterface/getIndexData.jhtml"
//获取人气推荐
#define URL_Recommend @"appInterface/getIndexGoodsList.jhtml"
//获取人气推荐
#define URL_BeanList @"appInterface/beanGoodsList.jhtml"
//截图
#define URL_CutPhoto @"appInterface/screenshot.jhtml"
//截图
#define URL_SynchUserName @"appInterface/synchUserName.jhtml"

//获取分类数据
#define URL_GetGoodsType @"appInterface/getGoodsTypeData.jhtml"

#pragma mark  分类
//获取热门搜索
#define URL_HotSearchData @"appInterface/getHotSearchData.jhtml"
//获取分类数据
#define URL_GoodType @"appInterface/getGoodsTypeList.jhtml"

//转让小米数据数据
#define URL_ChangeJiFen @"appInterface/receiveDonorBeans.jhtml"

//转让小米明细
#define URL_ChangeDetial @"appInterface/receiveDonorScoresAndBeansList.jhtml"

//获得小米明细
#define URL_GetScoreList @"appInterface/getPayScoreList.jhtml"

#define URL_ChangeScores @"appInterface/receiveDonorScores.jhtml"
//获取分类数据
#define URL_GoodsSearchKeyList @"appInterface/getGoodsSearchList.jhtml"

#pragma mark  口袋
//获取优惠劵
#define URL_MyCouponsList @"appInterface/getMyCouponsList.jhtml"

//获取一元购优惠劵
#define URL_EntCouponsList @"appInterface/getAmRechargeList.jhtml"
#define URL_AddCoupon @"appInterface/addCoupons.jhtml"

//获取版本号
#define URL_GetVersion @"appInterface/getAppVersion.jhtml"

//获取好友列表
#define URL_GetFriendsByLevel @"appInterface/getFriendsByLevel.jhtml"

#define URL_GetInviteInfo @"appInterface/inviteFriends.jhtml"

//一元购
//获取大转盘的大奖历史
#define URL_GetRotaryGameHistory @"appInterface/getRotaryGameHistory.jhtml"
//获取首页数据
#define URL_GetIndexTHGoodsList @"appInterface/getIndexTHGoodsList.jhtml"
#define URL_GetPKGoodsInfoList @"appInterface/getIndexPKGoodsList.jhtml"
#define URL_GetGoodsInfoList @"appInterface/getIndexGoodsList.jhtml"
#define URL_SexGetGoodsInfoList @"appInterface/getIndexSecGoodsList.jhtml"
//获取往期揭晓数据
#define URL_GetOldDuoBaoData @"appInterface/getHistoryGoodsFightList.jhtml"
//查询是否有某期活动
#define URL_QueryPeriod @"appInterface/getGoodsFightIdByPeriod.jhtml"
//加载商品详情
#define URL_LoadGoodsDetailInfo @"appInterface/getGoodsInfoData.jhtml"
//加载活动记录
#define URL_LoadDuoBaoRecord @"appInterface/getFightRecordList.jhtml"
//刷新首页数据
#define kUpdateHomePageData @"kUpdateHomePageData"
//获取首页数据
#define URL_GetHomePageData @"appInterface/getIndexData.jhtml"
//活动记录
#define URL_GetDuoBaoRecordList @"appInterface/getFightRecordInfoList.jhtml"
//查看他人的活动记录
#define URL_GetOtherDuoBaoRecordList @"appInterface/getOtherFightWinRecordList.jhtml"
//中奖记录
#define URL_GetZJRecord @"appInterface/getFightWinRecordList.jhtml"

//晒单列表
#define URL_GetZoneList @"appInterface/getBaskList.jhtml"

//晒单分享详情
#define URL_GetZoneDetail @"appInterface/getBaskContent.jhtml"

//晒单分享回调或者app分享回调
#define URL_GetShaiDanOrAppShareBack @"appInterface/shareReturn.jhtml"

//修改中奖地址
#define URL_ChangeOrderAddress @"appInterface/saveOrderAddress.jhtml"
//选择充值卡兑换方式
#define URL_ChangeCardCollectPrize @"appInterface/saveOrderGetType.jhtml"
#define URL_ChangeCardCollectPrizeDonor @"appInterface/saveDonorOrderGetType.jhtml"
//发布晒单
#define URL_PublishFightBask @"appInterface/publishFightBask.jhtml"
//查看活动号码
#define URL_LoadDuoBaoLuckNum @"appInterface/getMoreFightNum.jhtml"
#pragma mark  － 最新揭晓

//获取分类下商品列表
#define URL_GetGoodsListOfType @"appInterface/getGoodsTypeList.jhtml"
//搜索商品
#define URL_SearchGoodsInfo @"appInterface/getGoodsSearchList.jhtml"
//获取最新揭晓
#define URL_GetZXJX @"appInterface/getWillDoGoodsList.jhtml"


//添加购物车
#define URL_AddShopCart @"appInterface/addShopCart.jhtml"

//获取购物车列表
#define URL_GetShopCarList @"appInterface/getShopCartList.jhtml"

//修改购物车商品
#define URL_ChangeShopCarListInfo @"appInterface/updateShopCart.jhtml"

//删除购物车
#define URL_DeleteShopCart @"appInterface/delShopCart.jhtml"

//签到URL
#define URL_QianDao @"appInterface/signInInfo.jhtml"
#define URL_QianDaoTag @"appInterface/signInAward.jhtml"
@interface URLDefine : NSObject

@end
