//
//  FreeGoTableViewController.m
//  DuoBao
//
//  Created by clove on 12/27/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "FreeGoTableViewController.h"
#import "TimeCountDownView.h"
#import "LDProgressView.h"
#import "GoodsDetailInfo.h"
#import "ShaiDanViewController.h"
#import "AllGoodsOfFreePurchaseTableViewContrller.h"
#import "FreeRuleTableViewController.h"
//#import "DiscoverTableViewController.h"
#import "HomePageViewController.h"
#import "UIImage+Crop.h"
#import "FreePurchaseHistoryViewController.h"
#import "MZTimerLabel.h"

@interface FreeGoTableViewController ()<VouchTimeCountDownDelegate>
@property (nonatomic, strong) GoodsDetailInfo *nextGoods;           // 下期商品
@property (nonatomic, strong) GoodsDetailInfo *currentGoods;        // 当前活动商品
@property (nonatomic, strong) GoodsDetailInfo *previousGoods;       // 上期商品
@property (nonatomic, strong) NSString *leftStatus;
@property (nonatomic, strong) NSString *rightStatus;
@property (nonatomic) int joinTimes;


@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *headerContainerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLeft;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleRight;

@property (weak, nonatomic) IBOutlet UIButton *ruleButton;

@property (weak, nonatomic) IBOutlet UIView *countdownContainerView;
@property (weak, nonatomic) IBOutlet UILabel *countdownStillLabel;
@property (weak, nonatomic) IBOutlet UILabel *countdownTitleLabel;
@property (weak, nonatomic) IBOutlet MZTimerLabel *countDownLabel;

@property (weak, nonatomic) IBOutlet UIView *startedTitleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *startedTitleLabel;


@property (weak, nonatomic) IBOutlet UIView *goodsContainverView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet LDProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLabel;             // 总需1788人次
@property (weak, nonatomic) IBOutlet UILabel *goodsRemainderCountLabel;     // 还需234人次

@property (weak, nonatomic) IBOutlet UIView *propertyActivityContainverView;
@property (weak, nonatomic) IBOutlet UIImageView *nextGoodsImageView;
@property (weak, nonatomic) IBOutlet UIView *nextGoodsContainerView;
@property (weak, nonatomic) IBOutlet UILabel *nextGoodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextGoodsNameLabel;            // 商品名称
@property (weak, nonatomic) IBOutlet UILabel *nextGoodsNumberLabel;          // 商品数量
@property (weak, nonatomic) IBOutlet UILabel *nextGoodsAmountCountLabel;     // 总需人次
@property (weak, nonatomic) IBOutlet UIButton *moreGoodsButton;

@property (weak, nonatomic) IBOutlet UIView *historyContainverView;
@property (weak, nonatomic) IBOutlet UIButton *allHistoryButton;
@property (weak, nonatomic) IBOutlet UIImageView *historyImageView;
@property (weak, nonatomic) IBOutlet UILabel *historyPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyGoodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyLotteryNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyWinerLabel;

@property (weak, nonatomic) IBOutlet UIButton *reviewButton;

@property (nonatomic, strong) TimeCountDownView *timeCountdownView;

@end

@implementation FreeGoTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.title = @"0元购";
    
    _tableHeaderView.width *= UIAdapteRate;
    _tableHeaderView.height *= UIAdapteRate;
    self.tableView.tableHeaderView = _tableHeaderView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    self.tableView.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    UILabel  *label = _countdownTitleLabel;
    UIFont *font =  [UIFont fontWithName:@"FZShangKuS-R-GB" size:22];
    label.font = font;
    label.text = @"";
    
    UIButton *button = _joinButton;
    [button setTitleColor:[UIColor colorFromHexString:@"a879bc"] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorFromHexString:@"a879bc"] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor colorFromHexString:@"a879bc"] forState:UIControlStateHighlighted];
    
    
    MZTimerLabel *timerLabel = _countDownLabel;
    [timerLabel setTimeFormat:@"HH:mm:ss"];
    timerLabel.timerType = MZTimerLabelTypeTimer;
    timerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25 * UIAdapteRate];
    
    _progressView.background = [UIColor colorFromHexString:@"25002e"];
    _progressView.color = [UIColor colorFromHexString:@"f8bf00"];
    [LDProgressView appearance].showBackgroundInnerShadow = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].showStroke = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].flat = @NO;
    [LDProgressView appearance].showText = @NO;
    _progressView.type = LDProgressSolid;
    _progressView.animate = @NO;
    
    _startedTitleContainerView.hidden = YES;
    
    [self request];
    
    [self UIAdapte];
    
    [self setLeftBarButtonItemArrow];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    
}

- (void)updateInterface
{
    _joinButton.enabled = NO;
    
    UIColor *pinkColor = [UIColor colorFromHexString:@"fdb9f4"];
    UIColor *pinkColorDisabled = [UIColor colorFromHexString:@"691972"];
    UIImage *defaultImage = PublicImage(@"defaultImage");
    
    GoodsDetailInfo *model = _currentGoods;
    NSInteger countdown = [model countdownSeconds];
    NSInteger serverTimeDifference =  [ShareManager shareInstance].serverTimeDifference;
    
    // 倒计时
    NSInteger countdownSeconds = countdown + serverTimeDifference;
    
    // 上午场和下午场都已结束，补上一天时间差
    if ([self isAllComplete]) {
        countdownSeconds += 60*60*24;
    }
    
//    __weak typeof(self) wself = self;
    MZTimerLabel *timerLabel = _countDownLabel;
    [timerLabel setCountDownTime:countdownSeconds];
    [timerLabel reset];
    [timerLabel startWithEndingBlock:^(NSTimeInterval countTime) {
        
        if (countTime == 0) {
//            [wself request];
        }
    }];
    
    _headerTitleLeft.text = [_leftStatus stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    _headerTitleRight.text =  [_rightStatus stringByReplacingOccurrencesOfString:@"  " withString:@" "];;
    if ([_leftStatus containsString:@"进行"] || [_leftStatus containsString:@"即将开始"]) {
        _headerTitleLeft.textColor = pinkColor;
    } else {
        _headerTitleLeft.textColor = pinkColorDisabled;
    }
    if ([_rightStatus containsString:@"进行"] || [_rightStatus containsString:@"即将开始"]) {
        _headerTitleRight.textColor = pinkColor;
    } else {
        _headerTitleRight.textColor = pinkColorDisabled;
    }
    
    // 活动开始了
    if ([_leftStatus containsString:@"进行"] || [_rightStatus containsString:@"进行"]) {
        _joinButton.enabled = YES;
        _startedTitleContainerView.hidden = NO;
        _countdownContainerView.hidden = !_startedTitleContainerView.hidden;
    } else {
        _startedTitleContainerView.hidden = YES;
        _countdownContainerView.hidden = !_startedTitleContainerView.hidden;
    }
    
    _startedTitleLabel.text = model.current_desc;
    _countdownTitleLabel.text = model.current_desc;
    
    NSURL *url = [NSURL URLWithString:[model firstImage]];
    _goodsTitleLabel.text = model.good_name;
    [_goodsImageView sd_setImageWithURL:url placeholderImage:defaultImage];
    _progressView.progress = [model.progress intValue] * 0.01;
    _goodsAmountLabel.text = [NSString stringWithFormat:@"总需%@人次", model.need_people];
    _goodsRemainderCountLabel.text = [NSString stringWithFormat:@"还需%d", [model remainderCount]];
    
    model = _nextGoods;
    url = [NSURL URLWithString:[model firstImage]];
    [_nextGoodsImageView sd_setImageWithURL:url placeholderImage:defaultImage];
    _nextGoodsNameLabel.text = [self goodsNameWithoutFreePurchase:model.good_name];
    _nextGoodsAmountCountLabel.text = [NSString stringWithFormat:@"总需人次: %@", model.need_people];
    _nextGoodsNumberLabel.text = [NSString stringWithFormat:@"数量: %@", model.one_time_num];
    
    model = _previousGoods;
    url = [NSURL URLWithString:[model firstImage]];
    [_historyImageView sd_setImageWithURL:url placeholderImage:defaultImage];
    _historyGoodsNameLabel.text = [self goodsNameWithoutFreePurchase:model.good_name];
    _historyPeriodLabel.text = [NSString stringWithFormat:@"[零元购第%@期]", model.good_period];
    _historyLotteryNumberLabel.text = [NSString stringWithFormat:@"幸运号码: %@", model.win_num];
    _historyWinerLabel.text = [NSString stringWithFormat:@"获奖者: %@", model.win_user.nick_name];
    
    int joinTimes = _joinTimes;
    if (joinTimes >= 2) {
        _joinButton.enabled = NO;
    }
}

- (NSString *)goodsNameWithoutFreePurchase:(NSString *)originalGoodName
{
    NSString *goodsName = [originalGoodName stringByReplacingOccurrencesOfString:@"[零元购]" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"【零元购】" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"(零元购)" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"[0元购]" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"【0元购】" withString:@""];
    goodsName = [goodsName stringByReplacingOccurrencesOfString:@"(0元购)" withString:@""];
    
    return goodsName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isAllComplete
{
    BOOL result = NO;
    if ([_leftStatus containsString:@"结束"] && [_rightStatus containsString:@"结束"]) {
        result = YES;
    }
    
    return result;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Action

- (IBAction)joinButtonAction:(id)sender {
    //谷歌分析0元购点击参加
//    [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_CY value:nil];
    [self requestJoinFreePurchase];
}

- (IBAction)shareAction:(id)sender {
    //谷歌分析0元购点击分享
//    [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_FX value:nil];
    
    NSString *link = ShareDownloadLink;
    
    GoodsDetailInfo *model = _currentGoods;
    NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"我已参与%@超级0元购 注册就能免费抢!", bundleDisplayName];
    
    NSString *title = [NSString stringWithFormat:@"%@ 免费领啦 很多小伙伴都拿到了！", model.good_name];
    NSString *subtitle = str;
    UIImage *image = _goodsImageView.image;
    
    
    [Tool showShareActionSheet:self.view
                          text:subtitle
                        images:image
                           url:[NSURL URLWithString:link]
                         title:title
                          type:0
                    completion:^(SSDKResponseState state) {
                        if (SSDKResponseStateSuccess == state) {
                            [self requestShare];
                        }
                    }];
}

- (IBAction)moreGoodsAction:(id)sender {
    
    //谷歌分析0元购查看本周商品
//    [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_CKBZSP value:nil];
    AllGoodsOfFreePurchaseTableViewContrller *vc =[[AllGoodsOfFreePurchaseTableViewContrller alloc] initWithNibName:@"AllGoodsOfFreePurchaseTableViewContrller" bundle:nil];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)moreHistoryAction:(id)sender {
    GoodsDetailInfo *model = _previousGoods;
    
    //谷歌分析0元购查看往期揭晓
//    [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_WQHG value:nil];
    
    FreePurchaseHistoryViewController *vc =[[FreePurchaseHistoryViewController alloc] initWithNibName:@"FreePurchaseHistoryViewController" bundle:nil];
    vc.goodId = model.good_id;
    vc.title = @"零元购揭晓";
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reviewAction:(id)sender {
    GoodsDetailInfo *model = _previousGoods;
    //谷歌分析0元购晒单
//    [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_CKPJ value:nil];
    
    
    ShaiDanViewController *vc = [[ShaiDanViewController alloc] initWithNibName:@"ShaiDanViewController" bundle:nil];
    vc.goodId = model.id;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ruleButtonAction:(id)sender {
    //谷歌分析0元购活动规则
//    [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_HDGZ value:nil];
    FreeRuleTableViewController *vc = [[FreeRuleTableViewController alloc] initWithNibName:@"FreeRuleTableViewController" bundle:nil];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refresh
{
    if (self.refreshControl.isRefreshing) {
        [self request];
    }
}

- (void)timeFireMethod
{
    [self request];
}

#pragma mark - UIApplicationWillEnterForegroundNotification

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self request];
}

//#pragma mark - VouchTimeCountDownDelegate
//
//- (void)vouchTimeCountDownFinish
//{
//    [self request];
//}

#pragma mark -

- (void)request
{
    __weak typeof(self) weakself = self;
//    HttpHelper *helper = [HttpHelper helper];
    [HttpHelper getIndexFreeGoodsList:^(NSDictionary *resultDic) {
        
        NSString *status = [resultDic objectForKey:@"status"];
        NSString *description = [resultDic objectForKey:@"desc"];
        NSDictionary *dict = [resultDic objectForKey:@"data"];
        
        if ([status isEqualToString:@"0"]) {
            
            NSDictionary *next_good = [dict objectForKey:@"next_good"];
            NSDictionary *now_good = [dict objectForKey:@"now_good"];
            NSDictionary *past_good = [dict objectForKey:@"past_good"];
            
            weakself.nextGoods = [next_good objectByClass:[GoodsDetailInfo class]];
            weakself.currentGoods = [now_good objectByClass:[GoodsDetailInfo class]];
            weakself.previousGoods = [past_good objectByClass:[GoodsDetailInfo class]];
            weakself.leftStatus = [dict objectForKey:@"leftStatus"];
            weakself.rightStatus = [dict objectForKey:@"rightStatus"];
            weakself.joinTimes = [[dict objectForKey:@"partTimes"] intValue];
            
            [weakself updateInterface];
        } else {
            [Tool showPromptContent:description];
        }
        
        [weakself.tableView.refreshControl endRefreshing];
        
    } fail:^(NSString *description) {
        
        [weakself.tableView.refreshControl endRefreshing];
        [Tool showPromptContent:description];
    }];
}

- (void)requestJoinFreePurchase
{
    NSString *goodsID = _currentGoods.id;
    
    __weak typeof(self) weakself = self;
//    HttpHelper *helper = [HttpHelper helper];
    [HttpHelper paymentFreeGoods:goodsID success:^(NSDictionary *resultDic) {
        
//        NSString *status = [resultDic objectForKey:@"status"];
        NSString *description = [resultDic objectForKey:@"desc"];
//        NSDictionary *dict = [resultDic objectForKey:@"data"];
        [Tool showPromptContent:description];
        
        weakself.joinTimes++;
        [weakself updateInterface];
        
    } fail:^(NSString *description) {
        [Tool showPromptContent:description];
    }];
}

- (void)requestShare
{

    [HttpHelper shareFreeGoodsSucceed:^(NSDictionary *resultDic) {
        
//        NSString *status = [resultDic objectForKey:@"status"];
        NSString *description = [resultDic objectForKey:@"desc"];
//        NSDictionary *dict = [resultDic objectForKey:@"data"];
        [Tool showPromptContent:description];
        //分享成功
//        [GA reportEventWithCategory:[ShareManager shareInstance].userinfo.id action:kGA0YuanGouCZ label:kGA0YuanGouCZ_FXCG value:nil];
        
    } fail:^(NSString *description) {
        
        [Tool showPromptContent:description];
    }];
}

#pragma mark -

- (void)UIAdapte
{
    float rate = UIAdapteRate;
    
    for (UIView *view in _tableHeaderView.subviews) {
        view.width *= rate;
        view.height *= rate;
        view.left *= rate;
        view.top *= rate;
        
        UIView *containerView = view;
        for (UIView *view in containerView.subviews) {
            view.width *= rate;
            view.height *= rate;
            view.left *= rate;
            view.top *= rate;
            
            UIView *containerView = view;
            for (UIView *view in containerView.subviews) {
                
                view.width *= rate;
                view.height *= rate;
                view.left *= rate;
                view.top *= rate;
            }
        }
    }
    
    _nextGoodsTitleLabel.font = [UIFont systemFontOfSize:14 * rate];
    
    _goodsAmountLabel.top = _progressView.bottom + 6*rate;
    _goodsRemainderCountLabel.top = _goodsAmountLabel.top;
    
    //    if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
    //        _countdownStillLabel.font = [UIFont fontWithName:@"FZShangKuS-R-GB" size:18*UIAdapteRate];
    //        _countdownTitleLabel.font = _countdownStillLabel.font;
    //    }
    
    _countdownStillLabel.font = [UIFont fontWithName:@"FZShangKuS-R-GB" size:18*UIAdapteRate];
    _countdownTitleLabel.font = _countdownStillLabel.font;
    _startedTitleLabel.font = [UIFont fontWithName:@"FZShangKuS-R-GB" size:24*UIAdapteRate];
}

- (void)leftBarItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setLeftBarButtonItemArrow
{
    if (self.navigationController == nil) {
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(leftBarItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)rightBarButtonItemAction
{
    for (int i=0; i<10; i++) {
        [self joinButtonAction:nil];
    }
}


@end
