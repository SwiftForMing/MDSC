//
//  DuoBaoRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "DuoBaoRecordViewController.h"
#import "DuoBaoRecordListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "DBNumViewController.h"
#import "SelfDuoBaoRecordInfo.h"
#import "PurchaseRecordTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "ThriceViewController.h"
#import "HomePageViewController.h"
#import "GoodsListViewController.h"

static NSString *kPurchaseFailureInventoryNotEnought = @"库存不足，购买下一期失败，请重新购买";
static NSString *kPurchaseFailureOver = @"该期已结束，包尾购买失败！";
@interface DuoBaoRecordViewController ()<SelectGoodsNumViewControllerDelegate>
{
//    int selectOptionType;//0全部 1 进行中 2 已揭晓
    int pageNum;
    int flageTag;
    NSMutableArray *dataSourceArray;
    UIActivityIndicatorView* activityIndicator;
}

@end

@implementation DuoBaoRecordViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _allLine.hidden = NO;
//    _jxzLine.hidden = YES;
//    _yjxLine.hidden = YES;
   
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}
//- (void)setFlag:(NSString *)flag{
//    flageTag = [flag intValue];
//    MLog(@"1234567890-%@",flag);
//    [self showLabelWith:flageTag];
//    [self setTabelViewRefresh];
//
//}

-(void)showLabelWith:(int)tag{
    if (tag == 0) {
        _allLine.hidden = NO;
        _jxzLine.hidden = YES;
        _yjxLine.hidden = YES;
    }
    if (tag == 1) {
        _allLine.hidden = YES;
        _jxzLine.hidden = NO;
        _yjxLine.hidden = YES;
    }
    if (tag == 2) {
        _allLine.hidden = YES;
        _jxzLine.hidden = YES;
        _yjxLine.hidden = NO;
    }
    
}
- (IBAction)allBtnClick:(id)sender {
     flageTag = 0;
    [self showLabelWith:flageTag];
    [self setTabelViewRefresh];
}
- (IBAction)ingBtnClick:(id)sender {
     flageTag = 1;
    [self showLabelWith:flageTag];
    [self setTabelViewRefresh];
}
- (IBAction)endBtnClick:(id)sender {
     flageTag = 2;
    [self showLabelWith:flageTag];
    [self setTabelViewRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVariable];
    [self leftNavigationItem];
    
//    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
//    topView.backgroundColor = UIColor.grayColor;
//    [self.view addSubview:topView];
    flageTag = [_flag intValue];
    [self showLabelWith:flageTag];
//    self.myTableView.estimatedRowHeight = 0;
//    self.myTableView.estimatedSectionHeaderHeight = 0;
//    self.myTableView.estimatedSectionFooterHeight = 0;
    
    [self setTabelViewRefresh];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:activityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"活动记录";
//    selectOptionType = 0;
//    [self updateHeadButtonView];
    pageNum = 1;
//    _headIconWidth.constant = FullScreen.size.width/3;
    dataSourceArray = [NSMutableArray array];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

-(void)back{
    if ([_type isEqualToString:@"myvc"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        MLog(@"controller%@",controller);
        
        if ([controller isKindOfClass:[HomePageViewController class]]) {
//            EntTabBarViewController *vc =(EntTabBarViewController *)controller;
//            [self.navigationController popToViewController:vc animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}



#pragma mark - http

- (void)httpGetRecordList
{
    __weak DuoBaoRecordViewController *weakSelf = self;
    
    [self removeBgimage];
    [HttpHelper getDuoBaoRecordWithUserid:[ShareManager shareInstance].userinfo.id
                               status:@"全部"
                              pageNum:[NSString stringWithFormat:@"%d",pageNum]
                             limitNum:@"20"
                              success:^(NSDictionary *resultDic){
                                  [weakSelf hideRefresh];
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      [weakSelf handleloadResult:resultDic];
                                  }else
                                  {
                                      
                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                      
                                  }
                              }fail:^(NSString *decretion){
                                  [weakSelf hideRefresh];
                                  [Tool showPromptContent:decretion onView:self.view];
                              }];
}

-(void)noDataUI
{
//    self.myTableView.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:(CGRectMake(FullScreen.size.width/2-100, 130, 200, 200))];
    bgImage.image = [UIImage imageNamed:@"bg_duob"];
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
    bgImage.tag = 100;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 162)];
    titlelabel.font = [UIFont systemFontOfSize:22];
    titlelabel.textColor = [UIColor lightGrayColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.tag = 300;
    
    UIView *goJoin = [[UIView alloc]initWithFrame:(CGRectMake(0, ScreenHeight-113, FullScreen.size.width, 49))];
    goJoin.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    goJoin.tag = 200;
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(10, 10, self.myTableView.frame.size.width-113, 26))];
    NSString *statusStr = nil;
//    switch (selectOptionType) {
//        case 0:
            statusStr = @"还没有参加活动？，万元大奖等你来";
            titlelabel.text =  @"你还没有开始活动哦～";
//            break;
//        case 1:
//            statusStr = @"活动正在火热进行，赶快加入吧！";
//            titlelabel.text =  @"抢得火热怎么可以少了你呢？";
//            break;
//        default:
//            statusStr = @"不要放弃下一个中奖的就是你！";
//            titlelabel.text =  @"幸运女神在对你微笑哦～";
//            break;
//    }
    
    label.text = statusStr;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    
    label.textColor = [UIColor colorFromHexString:@"474747"];
    
    [goJoin addSubview:label];
    
    UIButton *jionBtn = [[UIButton alloc]initWithFrame:(CGRectMake(label.frame.size.width+10, 10, 86, 30))];
    jionBtn.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"立即参与"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"e6332e"] range:NSMakeRange(0, [str length])];
    [jionBtn setAttributedTitle:str forState:UIControlStateNormal];
    jionBtn.layer.masksToBounds = YES;
    jionBtn.layer.cornerRadius = 5;
    
    jionBtn.layer.borderWidth = 2;
    jionBtn.layer.borderColor = [[UIColor colorFromHexString:@"e6332e"] CGColor];
    [jionBtn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    
    [goJoin addSubview:jionBtn];
    [self.myTableView addSubview:bgImage];
    [self.myTableView addSubview:titlelabel];
    [self.view addSubview:goJoin];
}

-(void)removeBgimage
{
    if ([self.myTableView viewWithTag:100]) {
        [[self.myTableView viewWithTag:100] removeFromSuperview];
        [[self.view viewWithTag:200] removeFromSuperview];
        [[self.myTableView viewWithTag:300] removeFromSuperview];
    }else{
        NSLog(@"没有东西");
    }
    
}
-(void)join
{
    GoodsListViewController *vc = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
    vc.typeId = @"";
    vc.typeName = @"商品列表";
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    if (resourceArray && resourceArray.count > 0 )
    {
        
        for (NSDictionary *dic in resourceArray)
        {
            SelfDuoBaoRecordInfo *info = [dic objectByClass:[SelfDuoBaoRecordInfo class]];
//            info.status
            MLog(@"SelfDuoBaoRecordInfo%@",info.status);
            if (flageTag == 0) {
              [dataSourceArray addObject:info];
            }
            if (flageTag == 2&&[info.status isEqualToString:@"已揭晓"]) {
                [dataSourceArray addObject:info];
            }
            if (flageTag == 1&&[info.status isEqualToString:@"进行中"]) {
                [dataSourceArray addObject:info];
            }
            
        }
        
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
        
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
            //在没有记录的情况下提升用户
            [self noDataUI];
        }
    }
    [_myTableView reloadData];
   
//    for (UIView *view in _myTableView.subviews){
//        MLog(@"view:%@ frame:%@",view,NSStringFromCGRect(view.frame));
//    }
//    MLog(@"_myTableView%@",NSStringFromCGRect(_myTableView.mj_header.frame));
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clickSeeNumButtonAction:(UIButton *)btn
{
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.userId = [ShareManager shareInstance].userinfo.id;
    vc.goodId = info.id;
    vc.userName = [ShareManager shareInstance].userinfo.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
//     
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDelegate

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 160;
    
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info hasBettingThrice]) {
        height += 112;
    }
    
    return height;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    PurchaseRecordTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseRecordTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PurchaseRecordTableViewCell" owner:nil options:nil];
        cell = [nib firstObject];
        MLog(@"nil cell");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell reloadWithData:info ofUser:[ShareManager shareInstance].userinfo.id];
    
    cell.purchaseNextButtonInRunLottery.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [self pushPurchaseAgain:info];
        
        return [RACSignal empty];
    }];
    cell.purchaseNextButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [self pushPurchaseAgain:info];
        
        return [RACSignal empty];
    }];
    cell.purchaseMoreButton.hidden = YES;
//    cell.purchaseMoreButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//
//        [self pushPurchaseAgain:info];
//
//        return [RACSignal empty];
//    }];
    cell.moreRecordButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
        [vc reloadWithData:info];
        vc.userId = [ShareManager shareInstance].userinfo.id;
        vc.goodId = info.id;
        vc.userName = [ShareManager shareInstance].userinfo.nick_name;
        vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
//         
    [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal empty];
    }];
    
    return cell;
}

- (void)pushPurchaseAgain:(SelfDuoBaoRecordInfo *)info
{
    if ([info isThriceGoods]) {
        
//        ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
    } else {
        
        [self httpGetGoodsDetailInfoId:info.id];
//        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
//        vc.goodId = info.id;
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
    }
}


#pragma mark - Http

- (void)httpGetGoodsDetailInfoId:(NSString *)goodId
{
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }
    
    __weak DuoBaoRecordViewController *weakSelf = self;
    [HttpHelper loadGoodsDetailInfoWithGoodsId:goodId
                                        userId:userIdStr
                                       success:^(NSDictionary *resultDic){
                                           if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                               [weakSelf handlenextloadResult:resultDic];
                                           }else
                                           {
                                               [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                           }
                                           
                                       }fail:^(NSString *decretion){
                                           [Tool showPromptContent:@"网络出错了" onView:self.view];
                                       }];
}

- (void)handlenextloadResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    //商品信息
   GoodsDetailInfo *goodsDetailInfo = [[dic objectForKey:@"goodsFightMap"] objectByClass:[GoodsDetailInfo class]];
    MLog(@"GoodsDetailInfo%@",goodsDetailInfo.status);
   
    if([goodsDetailInfo.status isEqualToString:@"已揭晓"])
    {
       
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = goodsDetailInfo.next_fight.id;
//         
    [self.navigationController pushViewController:vc animated:YES];
        
    }else if([goodsDetailInfo.status isEqualToString:@"倒计时"]){
        
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = goodsDetailInfo.next_fight.id;
//         
    [self.navigationController pushViewController:vc animated:YES];
        
    }else if([goodsDetailInfo.status isEqualToString:@"进行中"]){
        
        [self clickAddBuyWithGoodDetailinfo:goodsDetailInfo];
        
        
    }
    
}


-(void)clickAddBuyWithGoodDetailinfo:(GoodsDetailInfo *)info
{
        SelectGoodsNumViewController *vc = [[SelectGoodsNumViewController alloc] initWithNibName:@"SelectGoodsNumViewController" bundle:nil];
        
        //    vc.limitNum = [_goodsDetailInfo.good_single_price intValue];
        [vc reloadDetailInfoOnce:info];
        vc.delegate = self;
        //    vc.canBuyNum =  [_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue];
        self.definesPresentationContext = YES; //self is presenting view controller
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - SelectGoodsNumViewControllerDelegate

- (void)selectGoodsNum:(int)num goodsInfo:(GoodsDetailInfo *)goodsInfo
{
    if (goodsInfo) {
        [activityIndicator startAnimating];
        MLog(@"_selectedGoodsListInfo.good_single_price%@",goodsInfo.good_single_price);
        NSDictionary *data = [goodsInfo dictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
        [dict setObject:@(num) forKey:@"Crowdfunding"];
        [dict setObject:@([goodsInfo.good_single_price intValue])  forKey:@"price"];
        
        if (dict) {
            
            [self buyWithDict:dict];
           
        }
    }
}

-(void)buyWithDict:(NSDictionary *)dict{
    NSString *goods_fight_ids = [dict objectForKey:@"id"];
    NSString *goods_ids = [dict objectForKey:@"good_id"];
    NSString *buyType = @"now";
    NSString *price = [dict objectForKey:@"price"];
    
    MLog(@"我还有好多钱%f",[ShareManager shareInstance].userinfo.user_money);
    
    int crowdfundingBettingCount = [[dict objectForKey:@"Crowdfunding"] intValue];
    MLog(@"要多钱%d", crowdfundingBettingCount*[price intValue]);
    
    if ([ShareManager shareInstance].userinfo.user_money<crowdfundingBettingCount*[price intValue]) {
        
        [Tool showPromptContent:@"小米不足，请先获取小米哦～～" onView:[UIApplication sharedApplication].keyWindow];
        [activityIndicator stopAnimating];
        EntOrderViewController *vc = [EntOrderViewController createWithData:dict];
//         
    [self.navigationController pushViewController:vc animated:YES];
        //        EntBuyViewController *vc = [[EntBuyViewController alloc]initWithTableViewStyle:1];
        //         
   
        
    }else{
        
        MLog(@"[dict objectForKey]%@",[dict objectForKey:@"good_name"]);
        
//        if ([ShareManager shareInstance].isEnterMK) {
//            [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGAMkBuyGoods label:[dict objectForKey:@"good_name"] value:[NSNumber numberWithInt:(crowdfundingBettingCount*[price intValue])]];
//        }else{
//            [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGABuyGoods label:[dict objectForKey:@"good_name"] value:[NSNumber numberWithInt:(crowdfundingBettingCount*[price intValue])]];
//        }
        
        
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
                                 NSArray *arr = data[@"goods_fight_buy_List"];
                                 NSDictionary *dic = arr.firstObject;
                                 int price = [dic[@"good_single_price"] intValue];
                                 MLog(@"purchaseGoodsFightIDprice%d",price);
                                 
                                 //                                 int crowdfundingBettingCount = [[_data objectForKey:@"Crowdfunding"] intValue];
                                 
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
                                         //                                         [wself.loadingHUD hide:NO];
                                         
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
                                         //                                         [wself.loadingHUD hide:NO];
                                         
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
                                 
                                 [self purchaseFailure:description];
                             }];
}

// 购买支付成功
- (void)purchaseSuccess:(NSDictionary *)data
{
    [activityIndicator stopAnimating];
    [self setTabelViewRefresh];
    [Tool showPromptContent:@"购买成功" onView: [UIApplication sharedApplication].keyWindow];
    
}

// 购买失败
- (void)purchaseFailure:(NSString *)description
{
    [activityIndicator stopAnimating];
    [Tool showPromptContent:description onView: [UIApplication sharedApplication].keyWindow];
    
}


#pragma mark - PurchaseNumberViewControllerDelegate

//- (void)purchaseNumberDidSelected:(NSDictionary *)bettingData
//{
//    if (_selectedGoodsListInfo) {
//        NSDictionary *data = [_selectedGoodsListInfo dictionary];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
//
//        if (bettingData) {
//            [dict addEntriesFromDictionary:bettingData];
//            [self buyWithDict:dict];
//
//        }
//    }
//}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SelfDuoBaoRecordInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    //    if (info.isThriceGoods == YES) {
    //
    //        ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
   
    //
    //    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
    //    } else {
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    vc.goodId = info.id;
    if ([info.good_name containsString:@"PK"]) {
        vc.is_sixeight = @"Y";
    }
    //谷歌分析用户一般从哪里进入商品详情1
   
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            pageNum = 1;
            [weakSelf httpGetRecordList];
        });
    }];
   [tableView.mj_header beginRefreshing];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    tableView.mj_header.automaticallyChangeAlpha = YES;
//
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetRecordList];
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    if([_myTableView.mj_header isRefreshing])
    {
//        _myTableView.mj_header.frame = CGRectMake(0, 0, ScreenWidth, 54);
        [_myTableView.mj_header endRefreshing];
    }
}


@end
