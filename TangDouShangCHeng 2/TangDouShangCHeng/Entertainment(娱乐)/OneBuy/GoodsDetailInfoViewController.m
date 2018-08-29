//
//  GoodsDetailInfoViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsDetailInfoViewController.h"
#import "BannerTableViewCell.h"
#import "SafariViewController.h"
#import "GoodsInfoTableViewCell.h"
#import "ListTableViewCell.h"
#import "RecordTableViewCell.h"
#import "GoodsInfoJieXiaoTableViewCell.h"
#import "ShaiDanViewController.h"
#import "WQJXViewController.h"
#import "UserViewController.h"
#import "DBNumViewController.h"
#import "GoodsDetailInfo.h"
#import "DuoBaoRecordInfo.h"
#import "SelectGoodsNumViewController.h"
#import "PayViewController.h"
#import "QingDanViewController.h"
#import "IQKeyboardManager.h"
#import "PayResultViewController.h"
//#import "PayTableViewController.h"
#import "EntOrderViewController.h"
#import "GoodsFightModel.h"
#import "YYKitMacro.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SelectGoodsNumViewController.h"
#import "PaySuccessTableViewController.h"


static NSString *kPurchaseFailureInventoryNotEnought = @"库存不足，购买下一期失败，请重新购买";
static NSString *kPurchaseFailureOver = @"该期已结束，包尾购买失败！";
@interface GoodsDetailInfoViewController ()<SelectGoodsNumViewControllerDelegate,PayViewControllerDelegate>
{
    int pageNum;
    NSMutableArray *recordDataArray;
    GoodsDetailInfo *_goodsDetailInfo;
    NSString *duobaoBeginTime;
    NSMutableArray *myJoinNumArray;
    
    NSInteger _isJieXiao;//0 进行中 1 倒计时 2 已揭晓
    NSArray *bannerArray;
    UIView *topView;
    UIImageView *topImage;
    UILabel *topLabel;
    NSTimer *topTimer;
    
    NSTimer *timer;
    
    long long totalTime;
    int lookcount;
    
    int topNum;
    NSString *versionStr;
    UIActivityIndicatorView *activityIndicator;
    CALayer *logoLayer;
}
@property (nonatomic, strong) GoodsFightModel *model;


@end

@implementation GoodsDetailInfoViewController


- (void)dealloc {
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    if (topTimer) {
        //关闭定时器
        [topTimer invalidate];
        topTimer = nil;
    }
}

+ (void)load
{
    [super load];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
//    self.navigationController.navigationBar.hidden = NO;
    [_myTableView.mj_header beginRefreshing];

    topNum = 0;
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(20, 180, 200, 40)];
    topView.backgroundColor = [UIColor colorFromHexString:@"F7EFEF"];
    topView.layer.cornerRadius = 20;
    topView.hidden = YES;
    
    topImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    topImage.layer.cornerRadius = 15;
    topImage.layer.masksToBounds = YES;
    [topView addSubview:topImage];
    topLabel = [[UILabel alloc]initWithFrame:CGRectMake(topImage.right+5, 5, 200-40, 30)];
    topLabel.font = [UIFont systemFontOfSize:10];
    topLabel.textColor = [UIColor colorFromHexString:@"F5A623"];
    [topView addSubview:topLabel];
    [self.view addSubview:topView];
    
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
    
    self.title = @"商品详情";
    pageNum = 1;
    lookcount = 0;
    recordDataArray = [NSMutableArray array];
    

    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    
    _joinBotton.layer.masksToBounds =YES;
    _joinBotton.layer.cornerRadius = _joinBotton.frame.size.height * 0.07;
    _joinBotton.backgroundColor = [UIColor defaultRedButtonColor];
    
    _addButton.layer.masksToBounds =YES;
    _addButton.layer.cornerRadius = _addButton.frame.size.height/2;
    _addButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1] CGColor];
    _addButton.layer.borderWidth = 1.0f;
    
    _buttonWidth.constant = (FullScreen.size.width-80)/2;
    
    _isJieXiao = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [self updateGoodsNumLabel];
    
    
}



- (void)updateGoodsNumLabel
{
    if ([ShareManager shareInstance].userinfo.shoppCartNum <= 0 || ![ShareManager shareInstance].userinfo.islogin) {
        _shopCartNumLabel.hidden = YES;
    }else{
        _shopCartNumLabel.hidden = NO;
        _shopCartNumLabel.text = [NSString stringWithFormat:@"%ld",(long)[ShareManager shareInstance].userinfo.shoppCartNum];
        [Tool setFontSizeThatFits:_shopCartNumLabel];
        _shopCartNumLabel.layer.masksToBounds =YES;
        _shopCartNumLabel.layer.cornerRadius = _shopCartNumLabel.frame.size.height/2;
    }
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}


#pragma mark - Http

- (void)httpGetGoodsDetailInfo
{
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }

    __weak GoodsDetailInfoViewController *weakSelf = self;
    [HttpHelper loadGoodsDetailInfoWithGoodsId:_goodId
                                    userId:userIdStr
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleloadResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                       
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    //商品信息
    _goodsDetailInfo = [[dic objectForKey:@"goodsFightMap"] objectByClass:[GoodsDetailInfo class]];
    _model = [GoodsFightModel createWithDictionary:[dic objectForKey:@"goodsFightMap"]];
    
    if([_goodsDetailInfo.status isEqualToString:@"已揭晓"])
    {
        _isJieXiao = 2;
        
        
    }else if([_goodsDetailInfo.status isEqualToString:@"倒计时"]){
        
        
        if ([_goodsDetailInfo.is_show_daojishi isEqualToString:@"y"])
        {
            totalTime = [_goodsDetailInfo.daojishi_time longLongValue];
            if(totalTime == 0 && _isJieXiao == 1)
            {
                [self performSelector:@selector(httpGetGoodsDetailInfo) withObject:nil afterDelay:2];
            }else{
                [self startCountDown];
            }
            
        }else{
            [self performSelector:@selector(httpGetGoodsDetailInfo) withObject:nil afterDelay:5];
        }
        
        _isJieXiao = 1;
        
    }else{
        _isJieXiao = 0;
    }
    
    if (_isJieXiao == 2 || _isJieXiao == 1) {
        if ([_goodsDetailInfo.is_next isEqualToString:@"y"]) {
            _jiexiaoView.hidden = NO;
            _xjLabel.hidden = YES;;
//            _goButton.layer.masksToBounds =YES;
//            _goButton.layer.cornerRadius = _goButton.frame.size.height/2;
            _messageLabel.text = [NSString stringWithFormat:@"第%@期正在火热进行中...",_goodsDetailInfo.next_fight.good_period];
        }else{
            _jiexiaoView.hidden = YES;
            _xjLabel.hidden = NO;
        }
        
        
    }else{
        _jiexiaoView.hidden = YES;
        _xjLabel.hidden = YES;;
    }
    
    bannerArray = [_goodsDetailInfo.good_imgs componentsSeparatedByString:@","];
    
    //活动开始的时间
    NSArray *array1 = [dic objectForKey:@"firstFightList"];
    if (array1 && array1.count > 0) {
        duobaoBeginTime = [[array1 objectAtIndex:0] objectForKey:@"fight_time"];
    }
    
    versionStr = [dic objectForKey:@"version"];
    //我的活动好吗
    myJoinNumArray = [dic objectForKey:@"myFightList"];
    
    // 0元购不能参与活动
    if ([_goodsDetailInfo.is_free_good intValue] == 1) {
        _xjLabel.text = @"0元购活动商品不参与活动";
        _jiexiaoView.hidden = YES;
        _joinBotton.hidden = YES;
    }
    
    [_myTableView reloadData];
}


- (void)loadDuoBaoRecord
{
    
    __weak GoodsDetailInfoViewController *weakSelf = self;
    [HttpHelper loadDuoBaoRecordWithGoodsId:_goodId
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"20"
                                success:^(NSDictionary *resultDic){
                                    [self hideRefresh];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleLoadRecordResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [self hideRefresh];
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
}


- (void)handleLoadRecordResult:(NSDictionary *)resultDic
{
    if (recordDataArray.count > 0 && pageNum == 1) {
        [recordDataArray removeAllObjects];
        
    }
    MLog(@"[resultDic objectForKey]%@",[resultDic objectForKey:@"data"]);
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            DuoBaoRecordInfo *info = [dic objectByClass:[DuoBaoRecordInfo class]];
//            MLog(@"DuoBaoRecordInfo%@",info.user_ip_address);
            [recordDataArray addObject:info];
        }
        
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
        [self strtTopTimer];
    }else{
        if (pageNum == 1) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [_myTableView reloadData];
}

-(void)strtTopTimer{
    
    if (topTimer) {
        [topTimer setFireDate:[NSDate distantPast]];
    }
    [self tophandleTimer];
    
}

- (void)tophandleTimer
{
    if (!topTimer)
    {
        
        topTimer = [NSTimer scheduledTimerWithTimeInterval:6
                                                 target:self
                                               selector:@selector(addTopView)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:topTimer forMode:UITrackingRunLoopMode];
    }
    
//    totalTime = totalTime-10;
//
//    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
//    GoodsInfoTableViewCell *cell = (GoodsInfoTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath];
//
//    MZTimerLabel *timerLabel = cell.timerLabel;
//    [timerLabel setTimeFormat:@"mm:ss:SS"];
//    [timerLabel setCountDownTime:totalTime/1000.0];
//    timerLabel.timerType = MZTimerLabelTypeTimer;
//    [timerLabel reset];
    
//    if (totalTime <= 0) {
//        totalTime = 0;
//        if (timer) {
//            //关闭定时器
//            [timer setFireDate:[NSDate distantFuture]];
//        }
//        [self httpGetGoodsDetailInfo];
//    }
    
}

- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
//    HttpHelper *helper = [HttpHelper helper];
//    __weak GoodsDetailInfoViewController *weakSelf = self;
//    [helper addGoodsForShopCartWithUserId:[ShareManager shareInstance].userinfo.id
//                                goods_ids:goodIds
//                           goods_buy_nums:buyNum
//                                  success:^(NSDictionary *resultDic){
//                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
//                                          [weakSelf handleloadAddGoodsToShopCartResult:resultDic buyNum:buyNum];
//                                      }else
//                                      {
//                                          [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                      }
//                                  }fail:^(NSString *decretion){
//                                      [Tool showPromptContent:@"网络出错了" onView:self.view];
//                                  }];
}

- (void)handleloadAddGoodsToShopCartResult:(NSDictionary *)resultDic buyNum:(NSString *)buyNum
{
    [self getUserInfoOfShopCartNum];
    
    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
    
}


- (void)getUserInfoOfShopCartNum
{
    __weak GoodsDetailInfoViewController *weakSelf = self;
   
    [HttpHelper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                              {
                                  UserInfo *info = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  info.user_agency = [ShareManager shareInstance].userinfo.user_agency;
                                  [ShareManager shareInstance].userinfo = info;
                                  info.loginPassword = [ShareManager shareInstance].userinfo.loginPassword;
                                  [Tool saveUserInfoToDB:YES];
                                  [weakSelf updateGoodsNumLabel];
                              }
                          }fail:^(NSString *decretion){
                              
                          }];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickJoinButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    if ([_is_sixeight isEqualToString:@"Y"]||[_goodsDetailInfo.good_name containsString:@"PK"]) {
        bool iscan = NO;
        for (DuoBaoRecordInfo *info in recordDataArray) {
            if ([info.user_id isEqualToString:[ShareManager shareInstance].userinfo.id]) {
                iscan = YES;
                return;
            }
        }
        if (iscan) {
            [Tool showPromptContent:@"亲只能购买一次哦😊😊"];
        }else{
           [self selectGoodsNum:[_goodsDetailInfo.need_people intValue]/3 goodsInfo:_goodsDetailInfo];
        }
        
    } else {
        SelectGoodsNumViewController *vc = [[SelectGoodsNumViewController alloc] initWithNibName:@"SelectGoodsNumViewController" bundle:nil];
        [vc reloadDetailInfoOnce:_goodsDetailInfo];
        vc.delegate = self;
        self.definesPresentationContext = YES; //self is presenting view controller
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[PayResultViewController class]]) {
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        } else {
            UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:vc animated:YES completion:nil];
        }
    }
}


- (void)purchaseGoods:(GoodsFightModel *)model
{
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    int remainerThriceCoin = userInfo.happy_bean_num;
    int neededThriceCoin =  [model remainderCoin];
    if (neededThriceCoin > remainerThriceCoin) {
        NSString *message = [NSString stringWithFormat:@"小米余额不足，购买总需%d小米，玩三赔可获取更多小米～", neededThriceCoin];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
    
    
    SelectGoodsNumViewController *vc = [[SelectGoodsNumViewController alloc] initWithNibName:@"SelectGoodsNumViewController" bundle:nil];
    [vc reloadWithGoodsFightModel:model];
    vc.delegate = self;
    self.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)clickAddButtonButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    [self httpAddGoodsToShopCartWithGoodsID:_goodsDetailInfo.good_id buyNum:@"1"];
}

- (IBAction)clickJShopCartButtonAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    QingDanViewController *vc = [[QingDanViewController alloc]initWithNibName:@"QingDanViewController" bundle:nil];
    vc.isPush = YES;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickGoButtonAction:(id)sender
{
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.next_fight.id;
    vc.is_sixeight = _is_sixeight;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    lookcount += 1;
    
    
    UIImageView *imageview = (UIImageView *)tap.self.view;
    NSString *userIdStr = nil;
    if (imageview.tag == -1) {
        userIdStr = _goodsDetailInfo.win_user_id;
    }else{
        DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:imageview.tag];
        userIdStr = info.user_id;
    }
    
    if ([userIdStr isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        return;
    }
    
    UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    vc.userId = userIdStr;
//     
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)clickRewardSeeNumButtonAction:(id)sender
{
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = _goodsDetailInfo.win_user_id;
    vc.userName = _goodsDetailInfo.win_user.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSeeNumButtonAction:(UIButton *)btn
{
    DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:btn.tag];
    
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = info.user_id;
    vc.userName = info.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
//     
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)clickSeeMySelfNumButtonAction:(UIButton *)btn
{
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = [ShareManager shareInstance].userinfo.id;
    vc.userName = @"您";
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickJSJGButtonAction:(id)sender
{
    SafariViewController *vc =[[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"计算详情";
   
    NSString *serverPrefix = URL_EntOneServer;
    if ([ShareManager shareInstance].isInReview == YES) {
        serverPrefix = URL_EntOneServerTest;
    }
    if ([ShareManager shareInstance].isEnterMK == YES) {
        serverPrefix = URL_MKEntOneServer;
    }
      vc.urlStr = [NSString stringWithFormat:@"%@%@goods_fight_id=%@", serverPrefix, Wap_JSXQ,_goodsDetailInfo.id];
    MLog(@"url%@",[NSString stringWithFormat:@"%@%@goods_fight_id=%@", serverPrefix, Wap_JSXQ,_goodsDetailInfo.id]);
    
   
    
//     /
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 倒计时
//倒计时
- (void)startCountDown
{
    
    if (timer) {
        [timer setFireDate:[NSDate distantPast]];
    }
    [self handleTimer];
}

- (void)handleTimer
{
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                 target:self
                                               selector:@selector(handleTimer)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    }
    
    totalTime = totalTime-10;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    GoodsInfoTableViewCell *cell = (GoodsInfoTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath];
    if (cell.timerLabel != nil) {
        MZTimerLabel *timerLabel = cell.timerLabel;
        [timerLabel setTimeFormat:@"mm:ss:SS"];
        [timerLabel setCountDownTime:totalTime/1000.0];
        timerLabel.timerType = MZTimerLabelTypeTimer;
        [timerLabel reset];
    }
    
    
    
    
    //    long long timeValue = totalTime /1000;
    //    NSUInteger min  = (timeValue%(3600))/60;
    //    NSUInteger second = (NSUInteger)(timeValue%60);
    //    NSUInteger hsecond = (NSUInteger)(totalTime%1000)/10;
    //
    //
    //
    //    if (min>9) {
    //        cell.hourLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)min];
    //    }else{
    //        cell.hourLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)min];
    //    }
    //
    //    if (second>9) {
    //        cell.minuteLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)second];
    //    }else{
    //        cell.minuteLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)second];
    //    }
    //
    //    if (hsecond>9) {
    //        cell.sendsLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)hsecond];
    //    }else{
    //        cell.sendsLabel.text = [NSString stringWithFormat:@"0%lu",(unsigned long)hsecond];
    //    }
    
    if (totalTime <= 0) {
        totalTime = 0;
        if (timer) {
            //关闭定时器
            [timer setFireDate:[NSDate distantFuture]];
        }
        [self httpGetGoodsDetailInfo];
    }
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return 4;
            break;
        case 3:
            return recordDataArray.count;
            break;
        default:
            return 0;
            break;
    }
    
    
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return FullScreen.size.width*0.6;
            break;
        case 1:
        {
            if (_isJieXiao == 2) {
                return 250;
            }
            else{
                return 175;
            }
            
        }
            break;
        case 2:
            return 44;
            break;
        case 3:
            return 95;
            break;
        default:
            return 0;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return 8;
            break;
        case 3:
            return 47;
            break;
        default:
            return 0;
            break;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section < 3) {
        
        return nil;
    }
    
    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 50);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width , 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:contentView];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [contentView addSubview:lineview];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 97,40)];
    titleLabel.textColor = [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1];
    titleLabel.text = @"所有参与记录";
    titleLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:titleLabel];
    
    UILabel *detailText = [[UILabel alloc]initWithFrame:CGRectMake(8+titleLabel.width, 0, FullScreen.size.width-8-titleLabel.width, 40)];
    if (duobaoBeginTime.length > 0 && ![duobaoBeginTime isEqualToString:@"<null>"]) {
        detailText.text = [NSString stringWithFormat:@"(自%@开始)",duobaoBeginTime];
    }
    
    detailText.textColor = [UIColor lightGrayColor];
    detailText.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:detailText];
    
    return bgView;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BannerTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"BannerTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.bannerView.delegate = self;
            cell.bannerView.dataSource = self;
            cell.bannerView.autoScrollAble = YES;
            cell.bannerView.direction = CycleDirectionLandscape;
            objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
            
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.bannerView reloadData];
        return cell;
        
    }else if (indexPath.section == 1)
    {
        if (_isJieXiao == 2) {
            GoodsInfoJieXiaoTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsInfoJieXiaoTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsInfoJieXiaoTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.detailButton.layer.masksToBounds =YES;
            cell.detailButton.layer.cornerRadius = cell.detailButton.frame.size.height/2;
            cell.detailButton.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
            cell.detailButton.layer.borderWidth = 1.0f;
            [cell.detailButton addTarget:self action:@selector(clickJSJGButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.photoImage.tag = -1;
            cell.photoImage.layer.masksToBounds =YES;
            cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
            cell.photoImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
            [cell.photoImage addGestureRecognizer:tap];
            
            [cell.rewardControl addTarget:self action:@selector(clickRewardSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.statueImage.image = PublicImage(@"cont_yixiexiao");
            if (_goodsDetailInfo) {
                cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
                
                [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:_goodsDetailInfo.win_user.user_header] placeholderImage:PublicImage(@"default_head")];
                cell.nameLabel.text = _goodsDetailInfo.win_user.nick_name;
                CGSize size = [cell.nameLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
                cell.namelabelWidth.constant = size.width+2;
                
                if([_goodsDetailInfo.win_user.user_ip_address containsString:@"-"]){
                    NSArray *array = [_goodsDetailInfo.win_user.user_ip_address componentsSeparatedByString:@"-"];
                   cell.addressLabel.text = [NSString stringWithFormat:@"%@",array.firstObject];
                }else{
                   cell.addressLabel.text = [NSString stringWithFormat:@"%@",_goodsDetailInfo.win_user.user_ip_address];
                }
                
                cell.numIDLabel.text = [NSString stringWithFormat:@"%@(唯一不变标识)",_goodsDetailInfo.win_user_id];
                cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",_goodsDetailInfo.win_user.fight_time];
                cell.timeLabel.text =_goodsDetailInfo.lottery_time;
                cell.xyhmLabel.text = _goodsDetailInfo.win_num;
            }
            
            if (myJoinNumArray.count > 0) {
                cell.noJionLabel.hidden = YES;
                
//                if (myJoinNumArray.count > 1) {
                    cell.JoinNumMoreView.hidden = NO;
                    cell.joinNumLessView.hidden = YES;
                    cell.selfJoinNumLabel.text = [NSString stringWithFormat:@"本次参与%lu人次",(unsigned long)myJoinNumArray.count];
                    CGSize size = [cell.selfJoinNumLabel sizeThatFits:CGSizeMake(MAXFLOAT, 45)];
                    cell.selfJoinWidth.constant = size.width;
                    [cell.JoinNumMoreView addTarget:self action:@selector(clickSeeMySelfNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//                }else{
//                    cell.JoinNumMoreView.hidden = YES;
//                    cell.joinNumLessView.hidden = NO;
//                    NSDictionary *dic = [myJoinNumArray objectAtIndex:0];
//                    cell.duobaoNumLabel.text = [dic objectForKey:@"fight_num"];
//                }
                
            }else{
                cell.noJionLabel.hidden = NO;
                cell.JoinNumMoreView.hidden = YES;
                cell.joinNumLessView.hidden = YES;
            }
            return cell;
            
        }else{
            GoodsInfoTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsInfoTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsInfoTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.processView.layer.masksToBounds =YES;
            cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
            
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_goodsDetailInfo) {
                cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
                cell.unitLabel.text = [NSString stringWithFormat:@"1人次＝%@小米",_goodsDetailInfo.good_single_price];
                if ([_model goodsType] == GoodsTypeThrice) {
                    int cardinalNumber = [_model cardinalNumber];
                    NSString *unit = [_model unitCurrency];
                    cell.unitLabel.text = [NSString stringWithFormat:@"1人次＝%d%@", cardinalNumber, unit];
                }
                
                //进行中
                if (_isJieXiao == 0) {
                    cell.processLabel.constant = (FullScreen.size.width-16)*([_goodsDetailInfo.progress doubleValue]/100.0);
                    cell.statueImage.image = PublicImage(@"cont_ing");
                    cell.daojishiViw.hidden = YES;
                    cell.allNumLabel.text = [NSString stringWithFormat:@"总需 %@人次",_goodsDetailInfo.need_people];
                    NSString *numStr = [NSString stringWithFormat:@"%d",[_goodsDetailInfo.need_people intValue]-[_goodsDetailInfo.now_people intValue]];
                    cell.needNumLabel.text = [NSString stringWithFormat:@"还需 %@",numStr];
                    
                }else{
                    //倒计时
                    cell.processLabel.constant = FullScreen.size.width-16;
                    cell.statueImage.image = PublicImage(@"cont_count");
                    cell.daojishiViw.hidden = NO;
                    if ([_goodsDetailInfo.is_show_daojishi isEqualToString:@"n"]) {
                        cell.daojieshiWarnLabel.hidden = NO;
                        cell.daojieshiWarnLabel.text = _goodsDetailInfo.daojishi_message;
                    }else{
                        cell.daojieshiWarnLabel.hidden = YES;
                    }
                    
                    //是否看是计算详情
                    if ([versionStr isEqualToString:@"cheat"]) {
                        cell.jsxqButton.hidden = YES;
                    }else{
                        cell.jsxqButton.hidden = NO;
                        cell.jsxqButton.layer.masksToBounds =YES;
                        cell.jsxqButton.layer.cornerRadius = cell.jsxqButton.frame.size.height/2;
                        cell.jsxqButton.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
                        cell.jsxqButton.layer.borderWidth = 1.0f;
                        [cell.jsxqButton addTarget:self action:@selector(clickJSJGButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
                
                if (myJoinNumArray.count > 0) {
                    cell.noJionLabel.hidden = YES;
                    
//                    if (myJoinNumArray.count > 1) {
                        cell.JoinNumMoreView.hidden = NO;
                        cell.joinNumLessView.hidden = YES;
                        cell.selfJoinNumLabel.text = [NSString stringWithFormat:@"本次参与%lu人次",(unsigned long)myJoinNumArray.count];
                        CGSize size = [cell.selfJoinNumLabel sizeThatFits:CGSizeMake(MAXFLOAT, 45)];
                        cell.selfJoinWidth.constant = size.width;
                        [cell.JoinNumMoreView addTarget:self action:@selector(clickSeeMySelfNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//                    }else{
//                        cell.JoinNumMoreView.hidden = YES;
//                        cell.joinNumLessView.hidden = NO;
//                        NSDictionary *dic = [myJoinNumArray objectAtIndex:0];
//                        cell.duobaoNumLabel.text = [dic objectForKey:@"fight_num"];
//                    }
                    
                }else{
                    cell.noJionLabel.hidden = NO;
                    cell.JoinNumMoreView.hidden = YES;
                    cell.joinNumLessView.hidden = YES;
                }
            }
            
            return cell;
        }
        
    }
    else if (indexPath.section == 2)
    {
        ListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (indexPath.row == 0) {
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabelWidth.constant = 0;
            cell.titleLabel.hidden = YES;
            cell.rightImage.hidden = YES;
            cell.detailLabel.hidden = NO;
            cell.detailLabel.text = @"声明：所有商品活动活动与苹果公司（apple inc.）无关";
            cell.detailLabel.textColor = [UIColor colorWithRed:240.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
            cell.detailLabel.font = [UIFont systemFontOfSize:13];
            cell.detailLabel.textAlignment = NSTextAlignmentCenter;
            [Tool setFontSizeThatFits:cell.detailLabel];
            return cell;
            
        }else{
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.titleLabelWidth.constant = 90;
            cell.titleLabel.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.detailLabel.hidden = YES;
            if(indexPath.row == 1)
            {
                cell.titleLabel.text = @"中奖位次走势";
                
//                cell.detailLabel.hidden = NO;
//                cell.detailLabel.text = @"建议Wi-Fi下查看";
//                cell.detailLabel.textColor = [UIColor lightGrayColor];
//                cell.detailLabel.font = [UIFont systemFontOfSize:12];
//                cell.detailLabel.textAlignment = NSTextAlignmentRight;
            }
            else
                if(indexPath.row == 2)
            {
                cell.titleLabel.text = @"幸运号码走势";
            }else{
                cell.titleLabel.text = @"往期中奖揭晓";
            }
            
            return cell;
        }
        
    }else{
        
        RecordTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.photoImage.tag = indexPath.row;
        cell.photoImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
        [cell.photoImage addGestureRecognizer:tap];
        cell.seeNumButton.tag = indexPath.row;
        [cell.seeNumButton addTarget:self action:@selector(clickSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:indexPath.row];
        
        cell.photoImage.layer.masksToBounds =YES;
        cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",info.nick_name];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",info.fight_time_all];
        cell.joinTimeLabel.text = [NSString stringWithFormat:@"参与%@人次",info.count_num];
        cell.joinNameLabel.text = [NSString stringWithFormat:@"%@",@""];
          MLog(@"DuoBaoRecordInfo%@",info.user_ip_address);
        if([info.user_ip_address containsString:@"-"]){
            NSArray *array = [info.user_ip_address componentsSeparatedByString:@"-"];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@ ip:%@)",info.nick_name,array.firstObject,info.user_ip];
        }else{
             cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@ ip:%@)",info.nick_name,info.user_ip_address,info.user_ip];
        }
        
        cell.joinNameLabel.text = [NSString stringWithFormat:@"参与%@人次",info.count_num];
      
        if ([info.count_num intValue] >= 1) {
            cell.seeNumButton.hidden = NO;
            cell.luckNumLabel.hidden = YES;
        }else{
            cell.seeNumButton.hidden = YES;
            cell.luckNumLabel.hidden = NO;
            cell.luckNumLabel.text = [NSString stringWithFormat:@"幸运号码：%@",info.fight_num];
        }
        
        
        return cell;
        
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 1:
            {
                ChartViewController *vc = [[ChartViewController alloc]init];
                vc.goodModel = _goodsDetailInfo;
                vc.good_fight_id = _goodId;
                vc.isBuyNum = NO;
                vc.isSixEight = _is_sixeight;
                vc.title = @"开奖位次走势图";
                if (_goodsDetailInfo.good_header&&[_goodsDetailInfo.good_header length] > 5) {
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
            case 3:
            {
                WQJXViewController *vc =[[WQJXViewController alloc]initWithNibName:@"WQJXViewController" bundle:nil];
                vc.goodId = _goodsDetailInfo.good_id;
                
              [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                ChartViewController *vc = [[ChartViewController alloc]init];
                vc.goodModel = _goodsDetailInfo;
                vc.good_fight_id = _goodId;
                vc.isBuyNum = YES;
                vc.isSixEight = _is_sixeight;
                vc.title = @"幸运号码走势图";
                if (_goodsDetailInfo.good_header&&[_goodsDetailInfo.good_header length] > 5) {
                    //
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)addTopView{
    
    topView.hidden = NO;
    
    if (recordDataArray.count == 0) {
        
    }else{
    
        if (topNum == recordDataArray.count) {
            topNum = 0;
        }
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 4;
    
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint: CGPointMake(topView.origin.x+100, topView.origin.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(topView.origin.x+100, topView.origin.y-150)];
    animation.duration = 4;
    [topView.layer addAnimation:opacityAnimation forKey:@"23456"];
    [topView.layer addAnimation:animation forKey:@"2asdfghj67"];
    
   
    DuoBaoRecordInfo *info = recordDataArray[topNum];
    topNum += 1;
    [topImage sd_setImageWithURL:[[NSURL alloc]initWithString:info.user_header] placeholderImage:nil];
    topLabel.text = [NSString stringWithFormat:@"%@购买了%@次",info.nick_name,info.count_num];

    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0];
    }

}

-(void)delayMethod{
    topView.hidden = YES;
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetGoodsDetailInfo];
        [weakSelf loadDuoBaoRecord];
       
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    //    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDuoBaoRecord];
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    
}



#pragma mark - CycleScrollViewDataSource

- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewAtPage:(NSInteger)page
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    NSString *url = nil;
    if (bannerArray.count == 2) {
        url = [bannerArray objectAtIndex:page%2];
    }else{
        url = [bannerArray objectAtIndex:page];
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    cycleScrollView.backgroundColor = [UIColor whiteColor];
    
    return imageView;
}

- (NSInteger)numberOfViewsInCycleScrollView:(CycleScrollView *)cycleScrollView
{
    BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
    cell.pageController.numberOfPages = bannerArray.count;
    
    if (bannerArray.count == 2) {
        return  4;
    }else{
        return bannerArray.count;
    }
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
    
    if (bannerArray.count == 2) {
        cell.pageController.currentPage = index%2;
    }else{
        cell.pageController.currentPage = index;
    }
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.6);
}

#pragma mark - SelectGoodsNumViewControllerDelegate

- (void)selectGoodsNum:(int)num goodsInfo:(GoodsDetailInfo *)goodsInfo
{
    if (goodsInfo) {
        NSDictionary *data = [goodsInfo dictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
        [dict setObject:@(num)  forKey:@"Crowdfunding"];
         [dict setObject:@([goodsInfo.good_single_price intValue])  forKey:@"price"];
        
        if (dict) {
            
            EntOrderViewController *vc = [EntOrderViewController createWithData:dict];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



- (void)selectGoodsNum:(int)num goodsFightModel:(GoodsFightModel *)model
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.removeFromSuperViewOnHide = YES;
    HUD.graceTime = 0.75;
    [HUD show:YES];
    
    
    NSMutableDictionary *payResultsDictionary = [NSMutableDictionary dictionary];
    
    NSString *goodsFightID = model.id;
    NSString *good_period = model.good_period;
    NSString *goodsID = model.goodsModel.good_id;
    NSString *good_name = model.goodsModel.good_name;
    int purchasedThriceCoin = [model.good_single_price intValue] * num;
    int costedThriceCoin = purchasedThriceCoin;
    int purchasedTimes = 1;
    
    
    
    if (purchasedThriceCoin > 0) {
        [payResultsDictionary setObject:[NSString stringWithFormat:@"%d", purchasedThriceCoin] forKey:@"purchasedThriceCoin"];
    }
    if (costedThriceCoin > 0) {
        [payResultsDictionary setObject:[NSString stringWithFormat:@"%d", costedThriceCoin] forKey:@"costedThriceCoin"];
    }
    if (purchasedTimes > 0) {
        [payResultsDictionary setObject:[NSString stringWithFormat:@"%d", purchasedTimes] forKey:@"purchasedTimes"];
    }
    if (good_period) {
        [payResultsDictionary setObject:good_period forKey:@"good_period"];
    }
    
    [payResultsDictionary setObject:good_name?:@"" forKey:@"good_name"];
    
    
    @weakify(self);
    [HttpHelper purchaseWithThriceCoin:goodsFightID
                           goodsID:goodsID
                        thriceCoin:costedThriceCoin
                           success:^(NSDictionary *data) {
                               @strongify(self);
                              
                               HUD.taskInProgress = YES;
                               [HUD hide:YES];
                               
                               NSArray *results = [data objectForKey:@"results"];
                               if ([results isKindOfClass:[NSArray class]] && results.count > 0 && [results.firstObject isKindOfClass:[NSDictionary class]]) {
                                   
                                   [payResultsDictionary setObject:@"success" forKey:@"result"];
                                   PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:payResultsDictionary];
//                                    
                                   [self.navigationController pushViewController:vc animated:YES];
                               } else {
                                   
                                   [payResultsDictionary setObject:@"failure" forKey:@"result"];
                                   PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:payResultsDictionary];
//                                    
                                   [self.navigationController pushViewController:vc animated:YES];
                               }
                               
                           } failure:^(NSString *description) {
                               
                               HUD.taskInProgress = YES;
                               [HUD hide:YES];
                               
                               [payResultsDictionary setObject:@"failure" forKey:@"result"];
                               if (description) {
                                   [payResultsDictionary setObject:description forKey:@"description"];
                               }
                               PaySuccessTableViewController *vc = [PaySuccessTableViewController createWithData:payResultsDictionary];
//                                
                               [self.navigationController pushViewController:vc animated:YES ];
                               
                           }];
}

#pragma mark -  PayViewControllerDelegate
- (void)payForBuyGoodsSuccess
{
    [self httpGetGoodsDetailInfo];
    [self loadDuoBaoRecord];
}

@end
