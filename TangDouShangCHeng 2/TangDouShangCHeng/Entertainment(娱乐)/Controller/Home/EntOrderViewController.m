//
//  EntOrderViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/26.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "EntOrderViewController.h"
#import "ClassifyTableViewCell.h"
#import "AgreementCheckbox.h"
#import "FooterButtonView.h"
#import "EntBuyViewController.h"
#import "PaySuccessTableViewController.h"
static NSString *kPurchaseFailureInventoryNotEnought = @"库存不足，购买下一期失败，请重新购买";
static NSString *kPurchaseFailureOver = @"该期已结束，包尾购买失败！";
@interface EntOrderViewController ()
@property (nonatomic, strong) AgreementCheckbox *agreementCheckbox;
@property (nonatomic) BOOL footerButtonHasTapped;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic, strong) MBProgressHUD *loadingHUD;
@end

@implementation EntOrderViewController

+ (EntOrderViewController *)createWithData:(NSDictionary *)data
{
    EntOrderViewController *vc = [[EntOrderViewController alloc]initWithTableViewStyle:1];
    vc.data = data;
    return vc;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付订单";
    FooterButtonView *footerView = [[FooterButtonView alloc] initWithTitle:@"立即购买"];
    [footerView.button addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _footerButton = footerView.button;
    self.tableView.tableFooterView = footerView;
    
}
- (void)footerButtonAction
{
    MLog(@"购买");
    if (_footerButtonHasTapped) {
        return;
    }
    _footerButtonHasTapped = YES;
    NSDictionary *dict = _data;
    NSString *goods_fight_ids = [dict objectForKey:@"id"];
    NSString *goods_ids = [dict objectForKey:@"good_id"];
    NSString *buyType = @"now";
    NSString *price = [dict objectForKey:@"price"];
   
     MLog(@"我还有好多钱%f",[ShareManager shareInstance].userinfo.user_money);
   
     int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    MLog(@"要多钱%d", crowdfundingBettingCount*[price intValue]);
//    MLog(@"crowdfundingBettingCount:%d",crowdfundingBettingCount);
    if ([ShareManager shareInstance].userinfo.user_money<crowdfundingBettingCount*[price intValue]) {
         _footerButtonHasTapped = NO;
        
        [Tool showPromptContent:@"小米不足，请先获取小米哦～～" onView:[UIApplication sharedApplication].keyWindow];
        EntBuyViewController *vc = [[EntBuyViewController alloc]initWithTableViewStyle:1];
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
     [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        MLog(@"[dict objectForKey]%@",[dict objectForKey:@"good_name"]);
       
        [self purchaseGoodsFightID:goods_fight_ids count:crowdfundingBettingCount thricePurchase:@[] isShopCart:@"" coupon:@"" exchangedThriceCoin:0 goodsID:goods_ids buyType:buyType];
    }
}

// 直接购买 = 生成与订单 -> 夺宝币小米均足够可直接购买
- (void)purchaseGoodsFightID:(NSString *)goods_fight_ids
                       count:(int)crowdfundingBettingCount
              thricePurchase:(NSArray *)thriceArray
                  isShopCart:(NSString *)is_shop_cart
                      coupon:(NSString *)ticket_send_id
         exchangedThriceCoin:(int)exchangedThriceCoin
                     goodsID:(NSString *)goods_ids
                     buyType:(NSString *)buyType
{
    int loadingTime = 10;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    //    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [_loadingHUD hide:NO];
    _loadingHUD = HUD;
    [_loadingHUD hide:YES afterDelay:loadingTime];
    [ _loadingHUD setCompletionBlock:^(void) {
        _footerButtonHasTapped = NO;
    }];
    
    __weak typeof(self) wself = self;
    
    [HttpHelper purchaseGoodsFightID:goods_fight_ids
                           count:crowdfundingBettingCount
                goods_buy_nums:@""
                  thricePurchase:thriceArray
                      isShopCart:is_shop_cart
                          coupon:ticket_send_id
             exchangedThriceCoin:exchangedThriceCoin
                         goodsID:goods_ids
                         buyType:buyType
                         success:^(NSDictionary *data) {
                             MLog(@"purchaseGoodsFightIDdata%@",data);
//                             NSArray *arr = data[@"goods_fight_buy_List"];
//                             NSDictionary *dic = arr.firstObject;
//                             int price = [dic[@"good_single_price"] intValue];
//                              MLog(@"purchaseGoodsFightIDprice%d",price);
                             
//                             int crowdfundingBettingCount = [[_data objectForKey:@"Crowdfunding"] intValue];
                             
                             int inventory = [[data objectForKey:@"has_inventory"] intValue];
                             
                             BOOL result = NO;
                             NSDictionary *dict = nil;
                             NSArray *array = [data objectForKey:@"results"];
                             
                             if ([array isKindOfClass:[NSArray class]]) {
                                 
                                 NSDictionary *object = [array firstObject];
                                 
                                 if ([object isKindOfClass:[NSDictionary class]]) {
                                     dict = object;
                                     result = YES;
                                 }
                             }
                             
                             NSString *wording = [NSString stringWithFormat:@"库存不足，是否包尾"];
                             NSString *sureButtonStr = [NSString stringWithFormat:@"包尾"];
                             
                             if ([buyType isEqualToString:@"now"]) {
                                 
                                 // 该期已结束，是否参与下一期
                                 if (inventory == 0 && result == NO) {
                                     
                                     // 中断loading，显示alert
                                     [wself.loadingHUD hide:NO];
                                     
                                     wording = @"该期已结束，是否参与下一期";
                                     sureButtonStr = @"参与";
                                     
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         
                                         [wself purchaseGoodsFightID:goods_fight_ids
                                                               count:crowdfundingBettingCount
                                                      thricePurchase:thriceArray
                                                          isShopCart:is_shop_cart
                                                              coupon:ticket_send_id
                                                 exchangedThriceCoin:exchangedThriceCoin
                                                             goodsID:goods_ids
                                                             buyType:@"next"];
                                     }];
                                     
                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                     }];
                                     
                                     [alertController addAction:cancelAction];
                                     [alertController addAction:alertAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                     
                                     // 库存不足
                                 } else if (inventory < crowdfundingBettingCount && result == NO) {
                                     
                                     // 中断loading，显示alert
                                     [wself.loadingHUD hide:NO];
                                     
                                     wording = [NSString stringWithFormat:@"库存不足，是否包尾 ？"];
                                     sureButtonStr = @"包尾";
                                     
                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                     UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         //谷歌分析包尾和不包尾
                                         [wself purchaseGoodsFightID:goods_fight_ids
                                                               count:crowdfundingBettingCount
                                                      thricePurchase:thriceArray
                                                          isShopCart:is_shop_cart
                                                              coupon:ticket_send_id
                                                 exchangedThriceCoin:exchangedThriceCoin
                                                             goodsID:goods_ids
                                                             buyType:@"mantissa"];
                                         
                                     }];
                                     
                                     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                                     }];
                                     
                                     [alertController addAction:cancelAction];
                                     [alertController addAction:alertAction];
                                     [self presentViewController:alertController animated:YES completion:nil];
                                     
                                 }else if (result == YES) {
                                     
                                     [wself purchaseSuccess:data];
                                 }
                             }
                             
                             // 上一轮执行操作为包尾，存在两种情况，包尾成功／该期已结束
                             if ([buyType isEqualToString:@"mantissa"]) {
                                 
                                 
                                 // 包尾失败，该期已结束，操作终止
                                 if (inventory == 0  && result == NO) {
                                     
                                     [wself purchaseFailure:kPurchaseFailureOver];
                                     
                                 }else if (result == YES) {
                                     
                                     [wself purchaseSuccess:data];
                                 }
                             }
                             
                             // 上一轮操作为买入到下一期，存在两种结果，库存不足没买上终止交易／购买成功
                             if ([buyType isEqualToString:@"next"]) {
                                 
                                 // 购买失败，库存不足，操作终止
                                 if (inventory < crowdfundingBettingCount && result == NO) {
                                     
                                     [wself purchaseFailure:kPurchaseFailureInventoryNotEnought];
                                     
                                 }else if (result == YES) {
                                     
                                     [wself purchaseSuccess:data];
                                 }
                             }
                             
                             
                             MLog(@"%@", dict);
                             
                         } failure:^(NSString *description) {
                             MLog(@"description%@", description);
                             [Tool showPromptContent:description];
//                             [self purchaseFailure:description];
                         }];
}


// 购买支付成功
- (void)purchaseSuccess:(NSDictionary *)data
{
    _footerButtonHasTapped = NO;
    [_loadingHUD hide:YES];
     MLog(@"purchaseSuccess%@",data);
    NSMutableDictionary *dict = [self payResultsDictionray:data];
    [dict setObject:@"success" forKey:@"result"];
    [dict setObject:data[@"pay_score"] forKey:@"pay_score"];
    MLog(@"success%@",dict);

    PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:dict];
     [self.navigationController pushViewController:vc animated:YES];
}

// 购买失败
- (void)purchaseFailure:(NSString *)description
{
    _footerButtonHasTapped = NO;
    [_loadingHUD hide:YES];
    
    NSMutableDictionary *dict = [self payResultsDictionray:nil];
    [dict setObject:@"failure" forKey:@"result"];
   
    PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:dict];
//     
     [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableDictionary *)payResultsDictionray:(NSDictionary *)data
{
    NSDictionary *dict = _data;
    MLog(@"payResultsDictionray%@",dict);
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue] != 0 ?: [[dict objectForKey:@"good_single_price"] intValue];
    int price = [[dict objectForKey:@"good_single_price"] intValue];
    int crowdfundingBettingAmount = crowdfundingBettingCount * crowdfundingCardinalNumber;
    NSArray *thriceArray = [dict objectForKey:@"Thrice"];
    int thriceBettingCount = 1;
    int rebatedCoinFromCoupon = 1;
    int exchangedCrowdfundingCoin = 1;
    int exchangedThriceCoin = exchangedCrowdfundingCoin * BeanExchangeRate;
    int remainderCrowdfundingCoin = [ShareManager shareInstance].userinfo.user_money;

    int payCrowdfundingCoin = crowdfundingBettingAmount - exchangedCrowdfundingCoin - rebatedCoinFromCoupon;
    int payThriceCoin = thriceBettingCount + exchangedThriceCoin;

    NSString *good_name = [dict objectForKey:@"good_name"];
    NSString *good_period = [dict objectForKey:@"good_period"];

    
    // 夺宝币余额中支付的部分
    int costedCrowdfundingCoin = payCrowdfundingCoin <= remainderCrowdfundingCoin ? payCrowdfundingCoin : remainderCrowdfundingCoin;
    
    // 小米余额中支付的部分
    int costedThriceCoin = crowdfundingBettingCount*BeanExchangeRate;
    
    
    NSMutableDictionary *payResultsDictionary = [NSMutableDictionary dictionary];
    
    // RMB购买可能存在返币,
    int unusedCrowdfunding = 0;
    int unusedThriceCoint = 0;
    
    // 包尾和预计数额不一致
    int purchasedCrowdfundingCoin = crowdfundingBettingAmount;
    int purchasedThriceCoin = thriceBettingCount;
    
    
    if (data ) {
//        int inventory = [[data objectForKey:@"has_inventory"] intValue];
        NSString *orderID = [data objectForKey:@"order_id"];
        NSString *all_price = [data objectForKey:@"all_price"];             // 本次购买夺宝币总额
        NSString *all_sapei_beans = [data objectForKey:@"all_sapei_beans"]; // 本次购买小米总额
        NSArray *array = [data objectForKey:@"results"];
        
        // 服务器返回支付结果
        BOOL result = NO;
        NSDictionary *resultDict = nil;
        if ([array isKindOfClass:[NSArray class]]) {
            NSDictionary *object = [array firstObject];
            if ([object isKindOfClass:[NSDictionary class]]) {
                resultDict = object;
                result = YES;
            }
        }
        
        NSString *not_fight_num = [resultDict objectForKey:@"not_fight_num"];
        NSString *not_fight_counts = [resultDict objectForKey:@"not_fight_counts"];
        NSString *fight_num = [resultDict objectForKey:@"fight_num"];
        
        // orderID不等于空，数据是服务器push过来的，属于RMB参与购买
        if (result == YES) {
            
            unusedCrowdfunding = [not_fight_num intValue];
            unusedThriceCoint = [not_fight_counts intValue];
            purchasedCrowdfundingCoin = [fight_num intValue];
        } else if (orderID.length > 0) {
            
            unusedCrowdfunding = [all_price intValue];
            unusedThriceCoint = [all_sapei_beans intValue];
        }
        
        // 返回原因
        NSString *unusedCrowdfundingReason = @"剩余人次不足";
        [payResultsDictionary setObject:unusedCrowdfundingReason?:@"" forKey:@"unusedCrowdfundingReason"];
    }
    
    int purchasedTimes = purchasedCrowdfundingCoin / crowdfundingCardinalNumber;
    
    if (purchasedTimes > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", purchasedTimes] forKey:@"purchasedTimes"];
    }
    if (unusedCrowdfunding > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", unusedCrowdfunding] forKey:@"unusedCrowdfunding"];
    }
    if (unusedThriceCoint > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", unusedThriceCoint] forKey:@"unusedThriceCoint"];
    }
    
    
    if (price > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", price] forKey:@"price"];
    }
    
    
    if (purchasedCrowdfundingCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", purchasedCrowdfundingCoin] forKey:@"purchasedCrowdfundingCoin"];
    }
    if (purchasedThriceCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", purchasedThriceCoin] forKey:@"purchasedThriceCoin"];
    }

    if (payCrowdfundingCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", payCrowdfundingCoin] forKey:@"payCrowdfundingCoin"];
    }
    if (payThriceCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", payThriceCoin] forKey:@"payThriceCoin"];
    }
    if (costedCrowdfundingCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", costedCrowdfundingCoin] forKey:@"costedCrowdfundingCoin"];
    }
    if (costedThriceCoin > 0) {
        [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", costedThriceCoin] forKey:@"costedThriceCoin"];
    }
    if (crowdfundingCardinalNumber < 1) {
        crowdfundingCardinalNumber = 1;
    }
    
    [payResultsDictionary setObject: [NSString stringWithFormat:@"%d", crowdfundingCardinalNumber] forKey:@"crowdfundingCardinalNumber"];
    [payResultsDictionary setObject:good_name?:@"" forKey:@"good_name"];
    [payResultsDictionary setObject:good_period?:@"" forKey:@"good_period"];
    
    if (thriceArray) {
        [payResultsDictionary setObject:thriceArray forKey:@"thriceArray"];
    }
    
    return payResultsDictionary;
}


//tableViewDeteglate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier=@"cell";
    tableView.rowHeight = 60;
    ClassifyTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.rightImage.hidden = YES;
    if (cell == nil)
    {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"ClassifyTableViewCell" owner:self options:nil]  firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.rightImage.hidden = YES;
    if (indexPath.row == 0) {
        cell.desLabel.text = [NSString stringWithFormat:@"参与%@小米活动",_data[@"good_name"]];;
    } else if (indexPath.row == 1){
        cell.desLabel.text = @"参与方式:小米活动";
    }else{
        
        int bean = [_data[@"Crowdfunding"] intValue]*[_data[@"price"] intValue];
        int score = bean/10;
        if ([ShareManager shareInstance].userinfo.user_score > score) {
           cell.desLabel.text = [NSString stringWithFormat:@"消耗小米:%d 消耗欢乐豆:%d",score*9,score];
        }else{
            cell.desLabel.text = [NSString stringWithFormat:@"消耗小米:%d 欢乐豆不足",bean];
        }
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth-90, 15, 80,  30)];

        label.text = @"欢乐豆规则";
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 3;
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [label whenTapped:^{
            NewCouponRulerViewController *vc = [[NewCouponRulerViewController alloc]init];
            vc.titleStr = @"使用规则";
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        [cell addSubview:label];
        cell.desLabel.textColor = [UIColor redColor];
    }
    return cell;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   
{
    UIView *view = nil;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        // Tabel section separation line
        UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 0.5)];
        separationLine.backgroundColor = [UIColor defaultTableViewSeparationColor];
        [view addSubview:separationLine];
        
        // 服务协议
        if (_agreementCheckbox == nil) {
            _agreementCheckbox = [[AgreementCheckbox alloc] initWithController:self];
        }
        
        AgreementCheckbox *checkboxView = _agreementCheckbox;
        checkboxView.centerX = view.width / 2;
        checkboxView.top = 0;
        [view addSubview:_agreementCheckbox];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 50;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSString *str = [NSString stringWithFormat:@"订单详情   余额:%d小米 欢乐豆:%d",(int)[ShareManager shareInstance].userinfo.user_money,(int)[ShareManager shareInstance].userinfo.user_score];
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}
@end
