//
//  HttpHelper.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/1.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject

+ (instancetype)helper;
/**
*获取公共资源 get请求
*/

+ (void)getHttpWithUrlStr:(NSString *)urlStr
success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail;


/**
 *获取服务器接口
 */
+ (NSString *)getURL;
#pragma mark - System

/**
 * 获取版本号
 */
+ (void)getVersion:(void (^)(NSDictionary *resultDic))success
              fail:(void (^)(NSString *description))fail;


+ (void)getConfigure:(void (^)(NSDictionary *resultDic))success
                fail:(void (^)(NSString *description))fail;
#pragma mark - 登录、注册、找回密码

/**
 * 获取验证码
 */
+ (void)getVerificationCodeByMobile:(NSString *)mobile
                               type:(NSString *)type
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;
/**
 * 注册
 */
+ (void)registerByWithMobile:(NSString *)mobile
                    password:(NSString *)password
           recommend_user_id:(NSString *)recommend_user_id
                   auth_code:(NSString *)auth_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;
/**
 * 登录
 */
+ (void)loginByWithMobile:(NSString *)mobile
                 password:(NSString *)password
                 jpush_id:(NSString *)jpush_id
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail;

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
                           fail:(void (^)(NSString *description))fail;
/**
 * 找回密码
 */
+ (void)findPwdByWithMobile:(NSString *)mobile
                   password:(NSString *)password
                  auth_code:(NSString *)auth_code
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail;

/**
 * 第三方绑定
 */
+ (void)bangDingByWithLoginId:(NSString *)app_login_id
                         type:(NSString *)type
                      url_tel:(NSString *)url_tel
                    auth_code:(NSString *)auth_code
            recommend_user_id:(NSString *)recommend_user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;
#pragma mark - 获取分类相关数据

/**
 * 关键字搜索
 */
+(void)getSearchKeyDataWithKeyWord:(NSString *)key
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;
/**
 * ID搜索
 */
+(void)getSearchIDDataWithID:(NSString *)goodID
                     pageNum:(NSString *)page
                    limitNum:(NSString *)limit
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;
#pragma mark - 获取首页相关数据

+(void)getHomeListDataWithPageNum:(NSString *)page
                         limitNum:(NSString *)limit
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;
#pragma mark - 获取口袋相关数据
+(void)getCouponListDataWithUserID:(NSString *)user_id
                           PageNum:(NSString *)page
                          limitNum:(NSString *)limit
                              type:(NSString *)type
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;
+(void)getAddCouponDataWithUserID:(NSString *)user_id
                   Coupons_secret:(NSString *)secret
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

+(void)getSharaCouponIDWithUserID:(NSString *)user_id
                   Coupons_secret:(NSString *)coupons_secret
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 修改默认地址
 */
+ (void)changeDefaultAddressWithUserId:(NSString *)user_id
                             addressId:(NSString *)addressId
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;


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
                        fail:(void (^)(NSString *description))fail;


/**
 * 获取城市列表
 */
+ (void)getCityInfoWithProvinceId:(NSString *)provinceId
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 删除地址
 */
+ (void)deleteAddressWithAddressId:(NSString *)addressId
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

/**
 * 收获地址列表
 */
+ (void)receiveAddressListWithUserId:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;


+ (void)getUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

+ (void)getCurrentLiftInfoWithUserId:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;
//+ (void)getUpDateUserInfoWithUserId:(NSString *)user_id
//                            success:(void (^)(NSDictionary *resultDic))success
//                               fail:(void (^)(NSString *description))fail;

+ (void)getEntUserInfoWithUserId:(NSString *)user_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;
//改变用户信息
+ (void)changeUserInfoWithUserId:(NSString *)user_id
                       fieldName:(NSString *)fieldName
                  fieldNameValue:(NSString *)fieldNameValue
              updateFieldNameNum:(NSString *)updateFieldNameNum
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;


/**
 * Post 上传图片
 */
+ (void)postImageHttpWithImage:(UIImage*)image
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;
/**
 * 获取aib支付参数
 *
 */

+ (void)getABpayInfoWithOrderNo:(NSString *)out_trade_no
                      total_fee:(NSString *)total_fee
               spbill_create_ip:(NSString *)spbill_create_ip
                           body:(NSString *)body
                         detail:(NSString *)detail
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;
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
                          fail:(void (^)(NSString *description))fail;

+ (void)getZFBInfoWithOrderNo:(NSString *)out_trade_no
                    total_fee:(NSString *)total_fee
             spbill_create_ip:(NSString *)spbill_create_ip
                         body:(NSString *)body
                       detail:(NSString *)detail
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;


+ (void)getWXInfoWithOrderNo:(NSString *)out_trade_no
                   total_fee:(NSString *)total_fee
            spbill_create_ip:(NSString *)spbill_create_ip
                        body:(NSString *)body
                      detail:(NSString *)detail
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;

+ (void)getMustpayInfoWithOrderNo:(NSString *)out_trade_no
                        total_fee:(NSString *)total_fee
                 spbill_create_ip:(NSString *)spbill_create_ip
                             body:(NSString *)body
                           detail:(NSString *)detail
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;
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
                     failure:(void (^)(NSString *description))failure;


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
                     failure:(void (^)(NSString *description))failure;

#pragma mark - 获取订单详情
+(void)getDetialOrderWithGoodId:(NSString *)goods_id
                           type:(NSString *)type
                         buyNum:(NSString *)num
                         userId:(NSString *)user_id
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

+(void)getQuanBeanDateWithPageNum:(NSString *)page
                         limitNum:(NSString *)limit
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;
#pragma mark - 获取我的订单列表

+ (void)getMyorderLisetWithUserID:(NSString *)user_id
                             type:(NSString *)type
                          pageNum:(NSString *)page
                         limitNum:(NSString *)limit
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 获取充值记录
 */
+ (void)getCZRecordWithUserId:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
                         type:(NSString *)type
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/**
 * 充值
 * type:[weixin/zhifubao]
 */
+ (void)payCZWithUserId:(NSString *)user_id
                  money:(NSString *)money
                typeStr:(NSString *)typeStr
                success:(void (^)(NSDictionary *resultDic))success
                   fail:(void (^)(NSString *description))fail;




/**
 * 邀请好友列表
 * level: 好友层级[1,2,3]
 */
+ (void)getFriendsByLevelWithUserId:(NSString *)user_id
                              level:(NSString *)level
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;

// bind recommend user ID
+ (void)saveRecommendUserID:(NSString *)recommnedUserID
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail;
#pragma mark - 邀请好友

// 邀请好友
+ (void)getInviteInfo:(void (^)(NSDictionary *resultDic))success
                 fail:(void (^)(NSString *description))fail;

// Income from friends
+ (void)getEarningHistoryByDays:(NSString *)pageNum
                       limitNum:(NSString *)limitNum
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

// withdraw money
+ (void)withdrawMoney:(NSString *)money
         withdrawType:(NSString *)type
              success:(void (^)(NSDictionary *resultDic))success
                 fail:(void (^)(NSString *description))fail;

// Withdraw history
+ (void)getExchangeEarningHistory:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

#pragma mark - 一元购
//是否截图
+(void)WhetherCutPhotoWithUserId:(NSString *)user_id
                   good_fight_id:(NSString *)good_fight_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;
#pragma mark - 图表
+ (void)TrendChartGoods:(NSString *)goodsID
                success:(void (^)(NSDictionary *resultDic))success
                   fail:(void (^)(NSString *description))fail;

+ (void)GetChartGoodsInfoDat:(NSString *)goods_fight_id
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;


+ (void)getOneWeekFreeGoodsList:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

+ (void)getIndexFreeGoodsList:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

+ (void)paymentFreeGoods:(NSString *)goodsID
                 success:(void (^)(NSDictionary *resultDic))success
                    fail:(void (^)(NSString *description))fail;

+ (void)shareFreeGoodsSucceed:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/**
 * 修改订单地址
 */
+ (void)changeOrderAddressWithOrderId:(NSString *)orderId
                       consignee_name:(NSString *)consignee_name
                        consignee_tel:(NSString *)consignee_tel
                    consignee_address:(NSString *)consignee_address
                           order_type:(NSString *)order_type
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;


#pragma mark - 购物车


/**
 * 添加购物车
 *
 */
+ (void)addGoodsForShopCartWithUserId:(NSString *)user_id
                            goods_ids:(NSString *)goods_ids
                       goods_buy_nums:(NSString *)goods_buy_nums
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

/**
 * 获取购物车列表
 *
 */
+ (void)getShopCartListWithUserId:(NSString *)user_id
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 修改购物车商品
 *
 */
+ (void)changeShopCartListInfoWithGoodsId:(NSString *)goodsId
                                 goodsNum:(NSString *)goods_buy_num
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail;

/**
 * 删除购物车
 *
 */
+ (void)deleteShopCartListInfoWithGoodsId:(NSString *)goodsIds
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail;


#pragma mark 大转盘

+(void)getRotaryGameAllHistory:(NSString *)pageNum
                      limitNum:(NSString *)limitNum
                       success:(void (^)(NSDictionary *data))success
                       failure:(void (^)(NSString *description))failure;
/**
 * 获取大转盘大奖历史纪录
 */
+ (void)getRotaryGameHistoryWithPageNum:(NSString *)pageNum
                               limitNum:(NSString *)limitNum
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail;

//getRotaryGameHistory.jhtml
+(void)getRotaryGameHistory:(NSString *)pageNum
                   limitNum:(NSString *)limitNum
                    success:(void (^)(NSDictionary *data))success
                    failure:(void (^)(NSString *description))failure;

//大转盘数据
+ (void)playRotaryGame:(void (^)(NSDictionary *data))success
               failure:(void (^)(NSString *description))failure;

#pragma mark - 转赠
/**
 * 转赠发起
 */
+ (void)sendRecordWithUserid:(NSString *)user_id
                    order_id:(NSString *)order_id
                  order_type:(NSString *)order_type
                 receive_tel:(NSString *)receive_tel
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;

/**
 * 我的转赠记录
 */
+ (void)getRecordWithUserid:(NSString *)user_id
                    pageNum:(NSString *)pageNum
                   limitNum:(NSString *)limitNum
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail;

/**
 * 转赠发起
 */
+ (void)affirmRecordWithUserid:(NSString *)user_id
                      order_id:(NSString *)order_id
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

+(void)getUserInfoWithTell:(NSString *)tel
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail;

+(void)sendToOther:(NSString *)orderID userid:(NSString *)userid
           success:(void (^)(NSDictionary *resultDic))success
              fail:(void (^)(NSString *description))fail;

#pragma mark - 获取基础数据
+ (void)getEntHttpWithUrlStr:(NSString *)urlStr
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;
+(void)getEntCouponListDataWithPageNum:(NSString *)page
                              limitNum:(NSString *)limit
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

+ (void)getGoodsListOfTypeWithGoodsTypeIde:(NSString *)goodsTypeId
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail;

+ (void)searchGoodsWithSearchKey:(NSString *)searchKey
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;

+ (void)getOldDuoBaoDataWithGoodsId:(NSString *)good_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;
/**
 * 查询是否有某期活动
 *
 */
+ (void)queryPeriodWithGoodsId:(NSString *)good_id
                   good_period:(NSString *)good_period
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;
/**
 * 加载商品详情
 *
 */
+ (void)loadGoodsDetailInfoWithGoodsId:(NSString *)goods_fight_id
                                userId:(NSString *)user_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

/**
 * 获取活动记录（参与活动的所以人）
 *
 */
+ (void)loadDuoBaoRecordWithGoodsId:(NSString *)goods_fight_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;

// 米豆商城足额直接购买
+ (void)purchaseWithThriceCoin:(NSString *)goods_fight_ids
                       goodsID:(NSString *)goods_ids
                    thriceCoin:(int)thriceCoin
                       success:(void (^)(NSDictionary *data))success
                       failure:(void (^)(NSString *description))failure;

/**
 * 获取活动记录
 * status: 活动状态[全部、已揭晓、进行]
 */
+ (void)getDuoBaoRecordWithUserid:(NSString *)user_id
                           status:(NSString *)status
                          pageNum:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 我的中奖记录
 */
+ (void)getZJRecordWithUserid:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
           is_happybean_goods:(NSString *)is_happybean_goods
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/**
 * 查看活动号码
 *
 */
+ (void)loadDuoBaoLuckNumWithGoodsId:(NSString *)goods_fight_id
                             user_id:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

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
                            fail:(void (^)(NSString *description))fail;
/**
 * 晒单详情
 *
 */
+ (void)queryZoneDetailInfoWithGoodsId:(NSString *)bask_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

/**
 * 晒单分享回调或者app分享回调
 *
 */
+ (void)getShaiDanOrAppShareBackWithUserId:(NSString *)user_id
                                      type:(NSString *)type
                                 target_id:(NSString *)target_id
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail;

/**
 * 发布晒单
 */
+ (void)publicShaiDanWithUserId:(NSString *)user_id
                 goods_fight_id:(NSString *)goods_fight_id
                          title:(NSString *)title
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;


+ (void)getFightOneWinRecord:(NSString *)userID
                     orderID:(NSString *)orderID
                  order_type:(NSString *)order_type
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;

/**
 * 选择充值卡兑换方式
 */
+ (void)setCardCollectPrizeMode:(NSString *)orderID
                 virtualGetType:(NSString *)type
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

/**
 * 选择充值卡兑换方式
 */
+ (void)setCardDonorCollectPrizeMode:(NSString *)orderID
                      virtualGetType:(NSString *)type
                          order_type:(NSString *)order_type
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

#pragma mark - 最新揭晓
/**
 * 获取最新揭晓数据
 *
 */
+ (void)getZXJXWithPageNum:(NSString *)pageNum
                  limitNum:(NSString *)limitNum
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail;

+ (void)getMallGoods:(int)pageNum
            limitNum:(int)limitNum
             success:(void (^)(NSDictionary *resultDic))success
             failure:(void (^)(NSString *description))failure;

+ (void)getGoodsListWithOrder_by_name:(NSString *)order_by_name
                        order_by_rule:(NSString *)order_by_rule
                              pageNum:(NSString *)pageNum
                             limitNum:(NSString *)limitNum
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

//pk数据
+ (void)getPKGoodsListWithOrder_by_name:(NSString *)order_by_name
                          order_by_rule:(NSString *)order_by_rule
                                pageNum:(NSString *)pageNum
                               limitNum:(NSString *)limitNum
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail;
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
                           failure:(void (^)(NSString *description))failure;

#pragma mark - 获取分类相关数据
+(void)getChangeJiFenWithID:(NSString *)userID
                  getUserId:(NSString *)getUserId
                  changeNum:(NSString *)changeNum
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail;
#pragma mark - 获取积分明细
+(void)getChangeJiFenDetialWithID:(NSString *)userID
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

+(void)getScoreListWithID:(NSString *)userID
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail;
#pragma mark - 转让红包
+(void)getChangeScoresWithID:(NSString *)userID
                   getUserId:(NSString *)getUserId
                changeScores:(NSString *)changeScores
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;
#pragma mark -签到
+(void)getQianDaoDateWithUserId:(NSString *)userId
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

+(void)qianDaoWithUserId:(NSString *)userId
                     tag:(NSString *)tag
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

@end
