//
//  PayViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "PayViewController.h"
//#import "CouponsViewController.h"
#import "ShopCartInfo.h"
#import "BuyGoodsListViewController.h"
#import "CouponsListInfo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "SelectCouponsViewController.h"
#import "PayResultViewController.h"
#import "PaySelectedController.h"

//@interface PayViewController ()<SelectCouponsViewControllerDelegate,PayResultViewControllerDelegate>
@interface PayViewController ()<SelectCouponsViewControllerDelegate>
{
    NSMutableArray * goodsSourceArray;
    NSMutableArray * couponsSourceArray;
    NSString *couponsId;
    double payMoney;
}

@property (nonatomic, strong) PaySelectedController *paySelectedController;

@end

@implementation PayViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeiXinPayNotif object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPaySuccessInSafari object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    //    [self registerNotif];
    
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithPurchaseGoods];
    [self.view addSubview:tableViewController.tableView];
    [self addChildViewController:tableViewController];
    tableViewController.tableView.top = _moneyShortcutContainer.bottom + 6;
    _paySelectedController = tableViewController;
    
    [self httpGetPayDetail];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = [_paySelectedController height];
    CGFloat constantHeigth = 23;
    height = height == 0 ? constantHeigth : constantHeigth + height+ 13;
    
    _paySelectHeight.constant = height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"支付订单";
    _payButton.layer.masksToBounds =YES;
    _payButton.layer.cornerRadius = 4;
    _allMoneyLabel.text = [NSString stringWithFormat:@"%.0f小米",_moneyNum];
    payMoney = _moneyNum;
    _payAllMoney.text = [NSString stringWithFormat:@"%.0f小米",payMoney];
    
    _djbLabel.text = [NSString stringWithFormat:@"小米支付（账户余额: %.0f 小米）",[ShareManager shareInstance].userinfo.user_money];
    
    goodsSourceArray = [NSMutableArray array];
    couponsSourceArray  = [NSMutableArray array];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    //谷歌分析用户放弃支付

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickGoodsNumAction:(id)sender
{
    BuyGoodsListViewController *vc = [[BuyGoodsListViewController alloc]initWithNibName:@"BuyGoodsListViewController" bundle:nil];
    vc.dataSourceArray = goodsSourceArray;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickPayButtonAction:(id)sender
{
    //谷歌分析立即购买
    
    if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"])    //app内支付
    {
        PayCategory payCategory = [_paySelectedController selectedPayCategory];
        if (payCategory == PayCategoryNone) {
            
            [self httpDJBPay];
        }else {
            if (couponsId.length > 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"第三方支付，不支持红包使用哦！是否继续支付" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
                return;
            }
            
            [self payMoney];
        }
    }
    else{
        NSString *isShopCart = @"n";
        if (isShopCart) {
            isShopCart = @"y";
        }
        
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_fight_ids=%@&goods_buy_nums=%@&is_shop_cart=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id,_goodsIds,_goods_buy_nums,isShopCart];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (IBAction)clickCouponsAction:(id)sender
{
    
    //谷歌分析红包
   
    if(couponsSourceArray.count < 1)
    {
        return;
    }
    SelectCouponsViewController *vc = [[SelectCouponsViewController alloc]initWithNibName:@"SelectCouponsViewController" bundle:nil];
    vc.dataSourceArray = couponsSourceArray;
    vc.couponsId = couponsId;
    vc.delegate = self;
    self.definesPresentationContext = YES;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];
}


#pragma mark - http

//获取支付详情
- (void)httpGetPayDetail
{
    NSString *shopCatStr = nil;
    if (_isShopCart) {
        shopCatStr = @"y";
    }else{
        shopCatStr = @"n";
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
//    HttpHelper *helper = [HttpHelper helper];
//    __weak PayViewController *weakSelf = self;
    MLog(@"获取支付");
//    [HttpHelper getPayDetailInfoWithUserId:[ShareManager shareInstance].userinfo.id
//                       goods_fight_ids:_goodsIds
//                        goods_buy_nums:_goods_buy_nums
//                          is_shop_cart:shopCatStr
//                               success:^(NSDictionary *resultDic){
//                                   [HUD hide:YES];
//                                   if ([[resultDic objectForKey:@"status"] integerValue] == 0)
//                                   {
//                                       [weakSelf handleloadGetPayDetailResult:resultDic];
//                                   }else{
//                                       [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                   }
//
//                               }fail:^(NSString *decretion){
//                                   [HUD hide:YES];
//                                   [Tool showPromptContent:@"网络出错了" onView:self.view];
//                               }];
}

- (void)handleloadGetPayDetailResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goods_fight_buy_List"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (goodsSourceArray.count > 0) {
            [goodsSourceArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            ShopCartInfo *info = [dic objectByClass:[ShopCartInfo class]];
            [goodsSourceArray addObject:info];
        }
    }
    
    resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"ticketList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (couponsSourceArray.count > 0) {
            [couponsSourceArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            CouponsListInfo *info = [dic objectByClass:[CouponsListInfo class]];
            [couponsSourceArray addObject:info];
        }
        
        [couponsSourceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            CouponsListInfo *data1 = obj1;
            CouponsListInfo *data2 = obj2;
            return data1.ticket_value < data2.ticket_value ? NSOrderedAscending : NSOrderedDescending;
        }];
        
        
        // 过滤不能使用的红包
        NSMutableArray *array = [NSMutableArray array];
        for (CouponsListInfo *obj in couponsSourceArray) {
            if ([obj isGoIntoEffect] && [obj isUsable]) {
                [array addObject:obj];
                MLog(@"CouponsListInfo = %f", obj.ticket_value);
            }
        }
        
        couponsSourceArray = array;
        
        _couponLabel.text = @"点击选取";
        
        // 自动选取红包
        [self chooseCouponWithBidding:_moneyNum];
    }
}

// 自动选择适用的红包
- (CouponsListInfo *)chooseCouponWithBidding:(double)money
{
    double bidding = money;
    CouponsListInfo *selectedCoupon = nil;
    
    NSArray *array = [NSArray arrayWithArray:couponsSourceArray];
    for (NSInteger i=array.count-1; i>=0; i--) {
        CouponsListInfo *object = array[i];
        if (bidding + 0.01 >= object.ticket_condition) {
            selectedCoupon = object;
            break;
        }
    }
    
    if (selectedCoupon) {
        [self selectCouponsWithID:selectedCoupon.id couponsName:selectedCoupon.ticket_name value:selectedCoupon.ticket_value];
    }
    
    return selectedCoupon;
}

//支付
- (void)httpDJBPay
{
    NSString *payStr = @"money";
    
    NSString *shopCatStr = nil;
    if (_isShopCart) {
        shopCatStr = @"y";
    }else{
        shopCatStr = @"n";
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *couponIdstr = couponsId;
    HUD.labelText = @"加载中...";
    MLog(@"下单？不着急");
//    HttpHelper *helper = [HttpHelper helper];
//    __weak PayViewController *weakSelf = self;
//    [helper payOfbuyGoodsWithPayType:payStr
//                     goods_fight_ids:_goodsIds
//                      goods_buy_nums:_goods_buy_nums
//                        is_shop_cart:shopCatStr
//                             user_id:[ShareManager shareInstance].userinfo.id
//                      ticket_send_id:couponIdstr
//                             success:^(NSDictionary *resultDic){
//                                 [HUD hide:YES];
//                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0)
//                                 {
//                                     [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
//                                 }else{
//                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                 }
//
//                             }fail:^(NSString *decretion){
//                                 [HUD hide:YES];
//                                 [Tool showPromptContent:@"网络出错了" onView:self.view];
//                             }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    //    [Tool getUserInfo];
    if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
    {
        [self.delegate payForBuyGoodsSuccess];
    }
    
    if (_isShopCart) {
        [ShareManager shareInstance].userinfo.shoppCartNum = 0;
        [Tool saveUserInfoToDB:YES];
    }else{
        //        [Tool getUserInfo];
    }
    
    PayCategory payCategory = [_paySelectedController selectedPayCategory];
    if(payCategory == PayCategoryNone)
    {
        [ShareManager shareInstance].userinfo.user_money  = [ShareManager shareInstance].userinfo.user_money - payMoney;
        _djbLabel.text = [NSString stringWithFormat:@"小米支付（账户余额: %.0f 小米）",[ShareManager shareInstance].userinfo.user_money];
    }
    
    NSMutableArray *goodsListArray = [NSMutableArray array];
    NSArray *resourceArray = [resultDic objectForKey:@"goods_fight_buy_List"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ShopCartInfo *info = [dic objectByClass:[ShopCartInfo class]];
            [goodsListArray addObject:info];
            
            // 购买商品名称和数量
        }
    }
    
    int amount = 0;
    for (NSString *str in [_goods_buy_nums componentsSeparatedByString:@","]) {
        amount += [str intValue];
    }
    
    // 购买成功
    
    //进入支付结果页面
    PayResultViewController *vc = [[PayResultViewController alloc]initWithNibName:@"PayResultViewController" bundle:nil];
//    vc.goodsListArray = goodsListArray;
//    vc.allMoney = amount;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    vc.delegate = self;
    [self presentViewController:nav animated:YES completion:^{
        //        [self.navigationController popViewControllerAnimated:YES];
    }];
}

//获取订单号
- (void)payMoney
{
    NSString *purchasePermission = [_paySelectedController paymentPermission:_moneyNum];
    if (![purchasePermission isEqualToString:@"allow"]) {
        [Tool showPromptContent:purchasePermission];
        return;
    }
    MLog(@"真的不能着姐PayViewController");
//    __block typeof(self) wself = self;
//    [_paySelectedController payMoney:_moneyNum
//                     goods_fight_ids:_goodsIds
//                      goods_buy_nums:_goods_buy_nums
//                          completion:^(BOOL result, NSString *description, NSDictionary *dict) {
//
//                              if (result) {
//
//                                  if([wself.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
//                                  {
//                                      [wself.delegate payForBuyGoodsSuccess];
//                                  }
//
//                                  [wself httpDJBPay];
//                              } else {
//                                  [Tool showPromptContent:description onView:self.view];
//                              }
//                          }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // 支付宝、微信不支持红包购买
    if (buttonIndex == 1) {
        
        couponsId = @"";
        _couponLabel.text = @"点击选取";
        payMoney = _moneyNum;
        _payAllMoney.text = [NSString stringWithFormat:@"%.0f小米",payMoney];
        
        [self payMoney];
    } else {
        [self clickLeftItemAction:nil];
    }
}

#pragma mark - SelectCouponsViewControllerDelegate

- (void)selectCouponsWithID:(NSString *)couponsIdStr couponsName:(NSString *)couponsName value:(double)value
{
    couponsId = couponsIdStr;
    
    if (!couponsId) {
        _couponLabel.text = @"点击选取";
        payMoney = _moneyNum;
        _payAllMoney.text = [NSString stringWithFormat:@"%.0f小米",payMoney];
    }
    else{
        _couponLabel.text = couponsName;
        payMoney = _moneyNum - value;
        if (payMoney <= 0) {
            payMoney = 0;
        }
        _payAllMoney.text = [NSString stringWithFormat:@"%.0f小米",payMoney];
    }
}

#pragma mark -  PayResultViewControllerDelegate <NSObject>

- (void)clickBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


//#pragma mark - notif Action
//- (void)registerNotif
//{
//    /**
//     *  微信回调监听
//     */
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveNotif:)
//                                                 name:kWeiXinPayNotif
//                                               object:nil];
//
//    /**
//     *  safari
//     */
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receivepSafariOpenNotif:)
//                                                 name:kPaySuccessInSafari
//                                               object:nil];
//}
//
//- (void)receiveNotif:(NSNotification *)notif
//{
//    NSDictionary *userInfo = [notif userInfo];
//    if(userInfo)
//    {
//        int code = [[userInfo objectForKey:@"statue"] intValue];
//        NSString *message = nil;
//        switch(code){
//            case 0:
//            {
//                if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
//                {
//                    [self.delegate payForBuyGoodsSuccess];
//                }
//                [self httpDJBPay];
//            }
//                break;
//            case -2:
//            {
//                message = @"您已取消了支付操作！";
//                [Tool showPromptContent:message onView:self.view];
//            }
//                break;
//            default:
//            {
//                message = @"很遗憾，您此次支付失败，请您重新支付！";
//                [Tool showPromptContent:message onView:self.view];
//            }
//                break;
//        }
//    }
//}
//
//- (void)receivepSafariOpenNotif:(NSNotification *)notif
//{
//    if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
//    {
//        [self.delegate payForBuyGoodsSuccess];
//    }
//    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"付款成功了，在个人中心里可查看您的活动记录!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//    [aler show];
//}
//
//
//#pragma mark - weixinPAy
//
//- (void)jumpToWeiXinPay:(NSDictionary *)resultDic {
//
//    NSDictionary *dict = [resultDic objectForKey:@"data"];
//    UInt32 timestamp = [[NSDate date] timeIntervalSince1970];
//
//    NSString *signStr = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%d&key=%@",WeiXinKey,[dict objectForKey:@"nonce_str"],WeiXinPiD,[dict objectForKey:@"prepay_id"],timestamp,WeiXinAppKey];
//    NSString *sign = [Tool encodeUsingMD5ByString:signStr letterCaseOption:UpperLetter];
//
//    //调起微信支付
//    PayReq* req    = [[PayReq alloc] init];
//    req.partnerId  = WeiXinPiD;
//    req.nonceStr   = [dict objectForKey:@"nonce_str"];
//    req.timeStamp  = timestamp;
//    req.prepayId   = [dict objectForKey:@"prepay_id"];
//    req.package    = @"Sign=WXPay";
//    req.sign       = sign;
//    [WXApi sendReq:req];
//
//}
//
//
////获取微信支付参数
//- (void)httpGetWeiXinPayInfo:(NSString *)orderNo
//{
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中...";
//
//    HttpHelper *helper = [HttpHelper helper];
//    __weak PayViewController *weakSelf = self;
//    [helper getWeiXinPayInfoWithOrderNo:orderNo
//                              total_fee:[NSString stringWithFormat:@"%.0f",_moneyNum*100]
//                       spbill_create_ip:@"127.0.0.1"
//                                   body:@"订单支付"
//                                 detail:@"订单支付"
//                                success:^(NSDictionary *resultDic){
//
//                                    [HUD hide:YES];
//                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0)
//                                    {
//                                        [weakSelf handleloadGetWeiXinPayInfoResult:resultDic];
//                                    }else{
//                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                    }
//
//                                }fail:^(NSString *decretion){
//                                    [HUD hide:YES];
//                                    [Tool showPromptContent:@"网络出错了" onView:self.view];
//                                }];
//}
//
//- (void)handleloadGetWeiXinPayInfoResult:(NSDictionary *)resultDic
//{
//    [self jumpToWeiXinPay:resultDic];
//}
//
////#pragma mark - Alipay
////
/////**
//// *  支付宝支付
//// *
//// *  @param orderId         支付宝订单信息
//// */
////- (void)payForAlipayWithOrderInfo:(NSString *)orderNo
////{
////    /*=============需要填写商户app申请的=============*/
////    NSString *partner = AliPayId;
////    NSString *seller = AliPayAccount;
////    NSString *privateKey = AliPayPrivateKey;
////    /*============================================*/
////    /*
////     *生成订单信息及签名
////     */
////
////    //将商品信息赋予AlixPayOrder的成员变量
////    Order *order = [[Order alloc] init];
////    order.partner = partner;
////    order.seller = seller;
////    order.tradeNO = orderNo; //订单ID（由商家自行制定）
////    order.productName = @"订单支付";
////    order.productDescription = @"订单支付"; //商品描述
////    order.amount = [NSString stringWithFormat:@"%.2f",_moneyNum]; //商品价格
////    order.notifyURL = [NSString stringWithFormat:@"%@%@",URL_Server,URL_AllipayNotify];//回调URL
////
////    order.service = @"mobile.securitypay.pay";
////    order.payCategory = @"1";
////    order.inputCharset = @"utf-8";
////    order.itBPay = @"30m";
////    order.showUrl = @"m.alipay.com";
////
////    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
////    NSString *appScheme = APPScheme;
////
////    //将商品信息拼接成字符串
////    NSString *orderSpec = [order description];
////    NSLog(@"orderSpec = %@",orderSpec);
////
////    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
////    id<DataSigner> signer = CreateRSADataSigner(privateKey);
////    NSString *signedString = [signer signString:orderSpec];
////
////    //将签名成功字符串格式化为订单字符串,请严格按照该格式
////    NSString *orderString = nil;
////    if (signedString != nil) {
////        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
////                       orderSpec, signedString, @"RSA"];
////        __weak PayViewController *weakSelf = self;
////        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
////            MLog(@"reslut = %@",resultDic);
////            NSString *resultStatue = (NSString *)[resultDic objectForKey:@"resultStatus"];
////
////            NSDictionary *resultInfo = [NSDictionary dictionaryWithObjectsAndKeys:resultStatue, @"resCode", nil];
////            [weakSelf handlePayResultNotification:resultInfo];
////
////            // 支付宝成功付款充值
////            double money = _moneyNum;
////            NSNumber *number = [NSNumber numberWithDouble:money];
////            if ([resultStatue isEqualToString:@"9000"]) {
////                [GA reportEventWithCategory:kGACategoryRecharge
////                                     action:[ShareManager userID]
////                                      label:kGALabel_recharge_goods
////                                      value:number];
////            }
////        }];
////    }
////}
//
///**
// *  处理支付结果
// */
//- (void)handlePayResultNotification:(NSDictionary *)userInfo
//{
//    NSString *message = nil;
//    NSString *resultCode = (NSString*)[userInfo objectForKey:@"resCode"];
//    if ([resultCode isEqualToString:@"00"] ||[resultCode isEqualToString:@"9000"]) {
//        if([self.delegate respondsToSelector:@selector(payForBuyGoodsSuccess)])
//        {
//            [self.delegate payForBuyGoodsSuccess];
//        }
//        [self httpDJBPay];
//    }
//    else if ([resultCode isEqualToString:@"01"] || [resultCode isEqualToString:@"4000"]){
//        message = @"很遗憾，您此次支付失败，请您重新支付！";
//        [Tool showPromptContent:message onView:self.view];
//
//    }else if([resultCode isEqualToString:@"02"] || [resultCode isEqualToString:@"6001"]){
//        message = @"您已取消了支付操作！";
//        [Tool showPromptContent:message onView:self.view];
//
//    }else if([resultCode isEqualToString:@"8000"]){
//        message =  @"正在处理中,请稍候查看！";
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alter show];
//
//    }else if([resultCode isEqualToString:@"6002"]){
//        message = @"网络连接出错，请您重新支付！";
//        [Tool showPromptContent:message onView:self.view];
//
//    }
//
//}

////获取订单号
//- (void)payMoney
//{
//     HttpHelper *helper = [HttpHelper helper];
//     __weak PayViewController *weakSelf = self;
//     [helper getOrderNoWithUserId:[ShareManager shareInstance].userinfo.id
//                        total_fee:[NSString stringWithFormat:@"%.0f",_moneyNum]
//                  goods_fight_ids:_goodsIds
//                   goods_buy_nums:_goods_buy_nums
//                       order_type:@"订单"
//                        all_price:[NSString stringWithFormat:@"%.0f",_moneyNum]
//                          success:^(NSDictionary *resultDic){
//                                  [HUD hide:YES];
//                                if ([[resultDic objectForKey:@"status"] integerValue] == 0)
//                                {
//                                    [weakSelf handleloadGetPayOrderInfoResult:resultDic];
//                                }else{
//                                    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                }
//
//                            }fail:^(NSString *decretion){
//                                  [HUD hide:YES];
//                                [Tool showPromptContent:@"网络出错了" onView:self.view];
//                            }];
//}


@end
