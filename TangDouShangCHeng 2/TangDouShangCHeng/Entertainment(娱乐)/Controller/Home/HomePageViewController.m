//
//  HomePageViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "HomePageViewController.h"
#import "BannerTableViewCell.h"
#import <objc/runtime.h>
#import "SafariViewController.h"
#import "SearchGoodsViewController.h"
#import "HomePageIconTableViewCell.h"
#import "HomePageJXListTableViewCell.h"

#import "GoodsDetailInfoViewController.h"
#import "ClassifyViewController.h"
#import "GoodsListViewController.h"
#import "ShaiDanViewController.h"
#import "SafariViewController.h"
#import "BannerInfo.h"
#import "radioInfo.h"
#import "JieXiaoInfo.h"
#import "GoodsListInfo.h"
#import "GoodsTypeInfo.h"
#import "SelectGoodsNumViewController.h"
#import "PayViewController.h"
#import "GoodsDetailInfo.h"
#import "InviteViewController.h"
//#import "FreeGoTableViewController.h"
//#import "InviteWebKitViewController.h"
//#import "WebActivityViewController.h"
//#import "ThriceViewController.h"
#import "PurchaseNumberViewController.h"
//#import "PayTableViewController.h"
#import "MallCollectionViewController.h"
#import "newGoodsCell.h"

//#import "FillingTwoViewController.h"
//#import "AllRebackViewController.h"
#import "EntOrderViewController.h"
#import "ProfileTableViewController.h"
#import "JieXiaoViewController.h"
//
#import "AdvertisementViewController.h"
#import "EntBuyViewController.h"
#import "FreeGoTableViewController.h"
#import "EntClassifyViewController.h"

static NSString *kPurchaseFailureInventoryNotEnought = @"库存不足，购买下一期失败，请重新购买";
static NSString *kPurchaseFailureOver = @"该期已结束，包尾购买失败！";

@interface HomePageViewController ()<UINavigationControllerDelegate,UISearchBarDelegate,HomePageJXListTableViewCellDelegate, SelectGoodsNumViewControllerDelegate, PayViewControllerDelegate, PurchaseNumberViewControllerDelegate,UIGestureRecognizerDelegate>
{
    UIControl *rqControl;
    UIControl *zxControl;
    UIControl *jdControl;
    UIControl *zxrcControl;
    UIControl *hjrcControl;
    
    UILabel *rqLine;
    UILabel *zxLine;
    UILabel *jdLine;
    UILabel *zxrcLine;
    UILabel *hjrcLine;
    
    UILabel *zxLabel;
    UILabel *zxscLabel;
    UILabel *jdLabel;
    UILabel *rqLabel;
    UILabel *hjLabel;
    
    UIButton *changeBtn;
    NSString *btnTitile;
    
    UIImageView *jdImage;
    UIImageView *zxrcImage;
    
    HomePageSelectOption slectType;
    
    int pageNum;
    int bagde;
    NSInteger tapNum;
    BOOL isBannerTwo;
    
    NSMutableArray *bannerArray;
    NSMutableArray *radioArray;
    NSMutableArray *jiexiaoArray;
    
    GoodsTypeInfo *typeInfo;
    
    NSMutableArray *goodsDataSourceArray;
    NSMutableArray *needLoadArr;
    NSTimer *timer;
    NSTimer *freshtimer;
    NSMutableArray *totalTimeArray;
    
    BOOL isClickButton;
    BOOL isCreated;
    
    BOOL isEnd;
    GoodsDetailInfo *_selectedGoodsInfo;
    GoodsListInfo *_selectedGoodsListInfo;
    
    UIActivityIndicatorView* activityIndicator;
    int uptime;
    
    UIView *topView;
    UIImageView *topImage;
    UILabel *topLabel;
    NSTimer *topTimer;
    
}
@property (nonatomic, copy) NSDate *updatedTime;     //点击首页tab，刷新间隔30秒，自动刷新
@property (nonatomic, strong) SearchGoodsViewController *searchViewController;
@property (nonatomic, strong) BannerTableViewCell *bannerCell;
@property (nonatomic, strong) HomePageIconTableViewCell *radioCell;


@property (nonatomic, copy) NSString *bannerListFlag;
@property (nonatomic, copy) NSString *lift;

@end

@implementation HomePageViewController

- (void)dealloc
{
    if (timer) {
        //关闭定时器
        MLog(@"关闭定时器");
        [timer invalidate];
        timer = nil;
    }
    
    if (freshtimer) {
        [freshtimer invalidate];
        freshtimer = nil;
    }
    if (topTimer) {
        //关闭定时器
        [topTimer invalidate];
        topTimer = nil;
    }
     MLog(@"关闭定时器");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateHomePageData object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    if (@available(iOS 11.0, *)) {
//        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        // Fallback on earlier versions
//    }
    bagde = 0;
//    请求购物车数据
    self.lift = @"0";
    [self setTabelViewRefresh];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(20, 180, 300, 40)];
    topView.backgroundColor = [UIColor colorFromHexString:@"F7EFEF"];
    topView.layer.cornerRadius = 20;
    topView.hidden = YES;
    
    topImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    topImage.layer.cornerRadius = 15;
    topImage.layer.masksToBounds = YES;
    [topView addSubview:topImage];
    topLabel = [[UILabel alloc]initWithFrame:CGRectMake(topImage.right+5, 0, 300-60, 40)];
    topLabel.numberOfLines = 10;
    topLabel.font = [UIFont systemFontOfSize:10];
    topLabel.textColor = [UIColor colorFromHexString:@"F5A623"];
    [topView addSubview:topLabel];
    [self.view addSubview:topView];

    [self.view addSubview:changeBtn];
    
    if ([ShareManager shareInstance].isEnterMK == YES) {

           self.title = @"秒开专区";
    }else{

        self.title =@"时时彩专区";
    }
    
    isEnd = NO;
    CGFloat y = ScreenHeight == 812.0 ? ScreenHeight-180-50-64:ScreenHeight-180-64;
    UIImageView *backView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-60, y, 40, 40)];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 20;
    [backView whenTapped:^{
        if (isEnd) {
            isEnd = NO;
        [self setTabelViewRefresh];
        }
       
    }];
    backView.image = [UIImage imageNamed:@"up"];
    [self.view addSubview:backView];
    
    uptime = 0;
    [self initParameter];
    [self registerNotif];
    isCreated = false;
    _updatedTime = [NSDate date];
    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.myTableView.scrollIndicatorInsets = self.myTableView.contentInset;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:activityIndicator];
    
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
    
}



-(void)addTopView{
    
    topView.hidden = NO;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 4;
    
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue =  [NSValue valueWithCGPoint: CGPointMake(topView.origin.x+150, topView.origin.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(topView.origin.x+150, topView.origin.y-150)];
    animation.duration = 4;
    [topView.layer addAnimation:opacityAnimation forKey:@"23456"];
    [topView.layer addAnimation:animation forKey:@"2asdfghj67"];
    
    int value = arc4random() % (radioArray.count);
    RadioInfo *info = radioArray[value];
    topImage.image = [UIImage imageNamed:@"win"];
    topLabel.text = [NSString stringWithFormat:@"恭喜%@中了%@",info.nick_name,info.good_name];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0];
    
}

-(void)delayMethod{
    topView.hidden = YES;
}


-(void)toTap{
    self.myTableView.contentOffset = CGPointMake(0, 0);
    [self setTabelViewRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchViewController = nil;
    [self.myTableView reloadData];
    
    if ([ShareManager shareInstance].isEnterMK) {
        self.navigationController.navigationBar.hidden = YES;
    }else{
        MLog(@"navigationController");
       
        self.navigationController.navigationBar.hidden = NO;
    }
   
    freshtimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateAuto) userInfo:nil repeats:YES];
    [self httpGetShopCartList];
    [self getLiftData];

    
}
-(void)updateAuto{
    uptime += 1;
    if (uptime == 10) {
        pageNum = 1;
        [self httpShowData];
        [self httpGetGoodsList];
        uptime = 0;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [freshtimer invalidate];
    freshtimer = nil;
    [timer invalidate];
    timer = nil;
    
    if (topTimer) {
        //关闭定时器
        [topTimer invalidate];
        topTimer = nil;
    }
    
    [topView.layer removeAnimationForKey:@"23456"];
    [topView.layer removeAnimationForKey:@"2asdfghj67"];
    
    if([ShareManager shareInstance].isEnterMK){
        
    }else{
//         [ShareManager shareInstance].isEnterMK = YES;
    }
    
    MLog(@"销毁定时器");
    // Search view controller is not need navigation bar
    if (self.searchViewController == nil) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
}




- (void)initParameter
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [leftItemControl addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    pageNum = 1;
    tapNum = 0;
    slectType = SelectOption_RQ;
    
    bannerArray = [NSMutableArray array];
    radioArray = [NSMutableArray array];
    jiexiaoArray = [NSMutableArray array];
    goodsDataSourceArray = [NSMutableArray array];
    needLoadArr = [NSMutableArray array];
}
-(void)leftBarButtonItemAction{
    [freshtimer invalidate];
    freshtimer = nil;
    if (!ShareManager.shareInstance.isEnterMK) {
        ShareManager.shareInstance.isEnterMK = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)setRightBarButtonItemSearch
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(leftBarButtonItemAction:)];
    button.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = button;
}

- (void)updateSelectStatue
{
    rqLine.hidden = YES;
    zxLine.hidden = YES;
    jdLine.hidden = YES;
    zxrcLine.hidden = YES;
    hjrcLine.hidden = YES;

    zxLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    zxscLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    jdLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    rqLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    hjLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];

    jdImage.image = [UIImage imageNamed:@"cont_updown"];
    zxrcImage.image = [UIImage imageNamed:@"cont_updown"];

    switch (slectType) {
        case SelectOption_RQ:
        {
            rqLine.hidden = NO;
            rqLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_ZX1:
        {
            zxLine.hidden = NO;
            zxLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
        }
            break;
        case SelectOption_JD:
        {
            jdLine.hidden = NO;
            jdLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
            jdImage.image = [UIImage imageNamed:@"cont_updown_2"];

        }
            break;
        case SelectOption_DuplicateJD:
        {
            jdLine.hidden = NO;
            jdLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
            jdImage.image = [UIImage imageNamed:@"cont_updown_1"];
        }
            break;
        case SelectOption_ZXRC:
        {
            hjrcLine.hidden = NO;
            hjLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
//            zxrcImage.image = [UIImage imageNamed:@"cont_updown_2"];

        }
            break;
        case SelectOption_DuplicateZXRC:
        {
            hjrcLine.hidden = NO;
            hjLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
//            zxrcImage.image = [UIImage imageNamed:@"cont_updown_1"];
        }
            break;
        case SelectOption_HJZQ:
        {
           
            zxrcLine.hidden = NO;
            zxscLabel.textColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
//            zxrcImage.image = [UIImage imageNamed:@"cont_updown_1"];
        }
            break;
        default:
            break;
    }

}

- (void)updateTableOffset
{
    CGFloat offset = 0;
    if (jiexiaoArray.count < 1) {
        offset = FullScreen.size.width*0.65+132;
    }else{
        offset = FullScreen.size.width*0.65+154+132;
    }
    if (offset + _myTableView.frame.size.height <= _myTableView.contentSize.height) {
        [_myTableView setMj_offsetY:offset];
    }else{
        [_myTableView setMj_offsetY:_myTableView.contentSize.height-_myTableView.frame.size.height];
    }
}


#pragma mark - notif Action
- (void)registerNotif
{
    /**
     *  监听网络状态变化
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachableNetworkStatusChange
                                               object:nil];
    
    //刷新首页数据
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateHomePageData)
                                                name:kUpdateHomePageData
                                              object:nil];
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        //是否屏蔽支付接口
        [Tool httpGetIsShowThridView];
        [_myTableView.mj_header beginRefreshing];
    }
}

- (void)updateHomePageData
{
    //是否屏蔽支付接口
    [Tool httpGetIsShowThridView];
    [self httpShowData];
    pageNum = 1;
    [self httpGetGoodsList];
    
}

#pragma mark - Action

- (void)leftBarButtonItemAction:(id)sender
{
    [self clickSearchButtonAction:nil];
}

- (IBAction)clickSearchButtonAction:(id)sender
{
    SearchGoodsViewController *vc = [[SearchGoodsViewController alloc] initWithNibName:@"SearchGoodsViewController" bundle:nil];
    self.searchViewController = vc;
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
     [self.navigationController pushViewController:vc animated:YES];
}

//响应单击方法－跳转广告页面
- (void)tapBanner:(UITapGestureRecognizer *) tap
{
    
    BannerTableViewCell *cell = objc_getAssociatedObject(tap, "cell");
    if (cell.pageController.currentPage >= bannerArray.count ) {
        return;
    }
    BannerInfo *info = [bannerArray objectAtIndex:cell.pageController.currentPage];
    
    NSLog(@"info.id: %@",info.id);


    // 跳转邀请好友
    if ([info.id isEqualToString:@"109"]) {

        InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
        // 邀请好友
         [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([info.id isEqualToString:@"105"]) {
        FreeGoTableViewController *vc = [[FreeGoTableViewController alloc]initWithNibName:@"FreeGoTableViewController" bundle:nil];
        //谷歌分析0元购点击进入
         [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
#if DEBUG
    // 跳乐购活动
    if ([info.id isEqualToString:@"113"]) {
        //#ifdef lgdb_prefix_pch
        //        NSURL *url = [NSURL URLWithString:@"zhimalegou://"];
        //        [[UIApplication sharedApplication] openURL:url];
        //        return;
        //#endif
        
#ifdef DuoBao_Prefix_pch
        NSURL *url = [NSURL URLWithString:@"legouduobao://"];
        //        if ([[UIApplication sharedApplication] canOpenURL:url]) {
        //            [[UIApplication sharedApplication] openURL:url];
        //            return;
        //        }
        if ([[UIApplication sharedApplication] openURL:url]) {
            return;
        }
#endif
        
    }
#endif
    
    
    // 跳转逢68
    if ([info.id isEqualToString:@"124"]) {
        if ([Tool islogin]){
            GetSixEightViewController *vc = [[GetSixEightViewController alloc]initWithNibName:@"GetSixEightViewController" bundle:nil];
            // 邀请好友
            [self.navigationController pushViewController:vc animated:YES];
        }
       
        
        return;
    }
    
    if ([info.id isEqualToString:@"125"]) {
        if ([Tool islogin]){
            EntBuyViewController *vc = [[EntBuyViewController alloc]initWithTableViewStyle:1];
            // 邀请好友
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        return;
    }
    
    // 三赔
    if ([info.id isEqualToString:@"115"] ) {
        

        
        return;
    }
    
    if ([info.id isEqualToString:@"120"] ) {

        
        return;
    }
    
    if ([info.id isEqualToString:@"122"] ) {
        

        return;
    }
    
    if ([info.id isEqualToString:@"121"] ) {
        

        return;
    }
    
    if ([info.id isEqualToString:@"123"] ) {

        return;
    }
    
    if([info.is_jump isEqualToString:@"y"])
    {
        if (!([info.image_url length]>0||[info.content_txt length]>0)) {
            SafariViewController *vc =[[SafariViewController alloc] initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = info.title;
            vc.urlStr = info.url;
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
             [self.navigationController pushViewController:vc animated:YES];
        }else{
            AdvertisementViewController *vc =[AdvertisementViewController alloc];
            vc.image_url = info.image_url;
            vc.content_txt = info.content_txt;
            vc.h5UrlStr = info.url;
            vc.myTitle = info.title;
            [self.navigationController pushViewController:vc animated:true];
        }
    }
    
    
    
    // 0元购
    if ([info.id isEqualToString:@"105"]) {
        
        if (![Tool islogin]) {
            [Tool loginWithAnimated:YES viewController:nil];
            return;
        }
        
//        FreeGoTableViewController *vc = [[FreeGoTableViewController alloc]initWithNibName:@"FreeGoTableViewController" bundle:nil];
//        //谷歌分析0元购点击进入
//
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
    }
}


- (void)clickRQButtonAction:(id)sender
{

    //谷歌分析人气点击

    isClickButton = YES;
    slectType = SelectOption_RQ;
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList];
//    [self updateTableOffset];

}
- (void)clickZXButtonAction:(id)sender
{

    isClickButton = YES;
    slectType = SelectOption_ZX1;
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList];
//    [self updateTableOffset];
}
- (void)clickJDButtonAction:(id)sender
{


    isClickButton = YES;
    if (slectType == SelectOption_JD) {
        slectType = SelectOption_DuplicateJD;

    }else{
        slectType = SelectOption_JD;
    }
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList];
//    [self updateTableOffset];

}
- (void)clickZXRCButtonAction:(id)sender
{

    isClickButton = YES;
    if (slectType == SelectOption_ZXRC) {
        slectType = SelectOption_DuplicateZXRC;
        
    }else{
        slectType = SelectOption_ZXRC;
        
    }
    
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList];
//    [self updateTableOffset];
}

- (void)clickHJZQButtonAction:(id)sender
{
    
    isClickButton = YES;
    slectType = SelectOption_HJZQ;
    
    [self updateSelectStatue];
    pageNum = 1;
    [self httpGetGoodsList];
//    [self updateTableOffset];
}

- (void)clickIconButtonAction:(id)sender
{
   
    UIControl *control = (UIControl *)sender;
    switch (control.tag) {
        case 100:
        {
            EntBuyViewController *vc = [[EntBuyViewController alloc]initWithTableViewStyle:1];
             [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 200:
        {
            if([ShareManager shareInstance].isEnterMK){
                EntClassifyViewController *vc = [[EntClassifyViewController alloc]initWithNibName:@"EntClassifyViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [ShareManager shareInstance].isEnterMK = YES;
                [self.navigationController popViewControllerAnimated:true];
            }
           
        }
            break;
        case 300:
        {
            [ShareManager shareInstance].isEnterMK = NO;
            HomePageViewController * entBarVC = [[HomePageViewController alloc] initWithNibName:@"HomePageViewController" bundle:nil];
            [self.navigationController pushViewController:entBarVC animated:YES];
//            MallCollectionViewController *vc = [[MallCollectionViewController alloc] initWithNibName:@"MallCollectionViewController" bundle:nil];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 400:
        {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }

            if ([[ShareManager shareInstance].userinfo.user_agency isEqualToString:@"1"]) {
                InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
                // 邀请好友
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                GetSixEightViewController *vc = [[GetSixEightViewController alloc]initWithNibName:@"GetSixEightViewController" bundle:nil];
                // 邀请好友
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
            
        }
        case 500:
        {
            RotaryViewController * vc = [[RotaryViewController alloc]initWithNibName:@"RotaryViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 600:
        {
              FireViewController * rotVC = [[FireViewController alloc]initWithNibName:@"FireViewController" bundle:nil];
            [self.navigationController pushViewController:rotVC animated:YES];
        }
            break;
            
        default: break;
    }
    
    
}

- (void)clickMoreButtonAction:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
}

#pragma mark - http

-(void)getLiftData{
    [HttpHelper getCurrentLiftInfoWithUserId:[ShareManager shareInstance].userinfo.id success:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
           NSDictionary *dic = [resultDic objectForKey:@"data"];
            NSString *lift = dic[@"CurrentLift"];
            self.lift = lift;
            [self.myTableView reloadData];
        }else{
            [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
        }
    } fail:^(NSString *description) {
        [Tool showPromptContent:description];
    }];
}

- (void)httpShowData
{
   
    __weak HomePageViewController *weakSelf = self;
    [HttpHelper getEntHttpWithUrlStr:URL_GetHomePageData
                      success:^(NSDictionary *resultDic){

                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                          }else{
                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                                  }
                      }fail:^(NSString *decretion){

                          [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                      }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    MLog(@"HomehandleloadResult%@",dic);
    //最新揭晓
//    NSArray *array2 = [dic objectForKey:@"willKnowFightList"];
//    if (array2 && array2.count > 0) {
//        if (jiexiaoArray.count > 0) {
//            [jiexiaoArray removeAllObjects];
//        }
//        for (NSDictionary *dic in array2)
//        {
//            JieXiaoInfo *info = [dic objectByClass:[JieXiaoInfo class]];
//            [jiexiaoArray addObject:info];
//        }
//        [self startCountDown];
//    }else{
//        if (timer) {
//            [timer setFireDate:[NSDate distantFuture]];
//        }
//    }
    
    NSArray *array = [dic objectForKey:@"advertisementList"];
    if (array && array.count > 0) {
        if (bannerArray.count > 0) {
            [bannerArray removeAllObjects];
        }
        for (NSDictionary *dic in array)
        {
            
            BannerInfo *info = [dic objectByClass:[BannerInfo class]];
            [bannerArray addObject:info];
        }
        
        if (bannerArray.count == 2) {
            isBannerTwo = YES;
            [bannerArray addObject:[bannerArray objectAtIndex:0]];
            [bannerArray addObject:[bannerArray objectAtIndex:1]];
        }
    }
    
    // banner有变化，更新界面
    [self bannerListDidChange:bannerArray];
    
    
    //广播
    NSArray *array1 = [dic objectForKey:@"radiolist"];
    if (array1 && array1.count > 0) {
        if (radioArray.count > 0) {
            [radioArray removeAllObjects];
        }
        for (NSDictionary *dic in array1)
        {
             MLog(@"NSDictionary%@",dic);
            RadioInfo *info = [dic objectByClass:[RadioInfo class]];
            [radioArray addObject:info];
        }
    }
    
    [self strtTopTimer];
    
    NSArray *array3 = [dic objectForKey:@"goodsTypeList"];
    if (array3 && array3.count > 0) {
        typeInfo = [[array3 objectAtIndex:0] objectByClass:[GoodsTypeInfo class]];
        
    }
    
    
    [_myTableView reloadData];
    
    
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        [_radioCell.bannerView reloadData];
//    });
}

- (void)httpGetGoodsList
{
    NSString *typeStr = @"now_people";
    NSString *descStr = @"desc";

    /*
     * order_by_name: 排序字段名称[now_people(人气),create_time(最新),progress(进度),need_people(总需人次)
     * order_by_rule: 排序规则[desc,asc]
     */
    switch (slectType) {
        case SelectOption_RQ:
        {
            typeStr = @"now_people";
            descStr = @"desc";
            [self getGoodsListWith:typeStr descStr:descStr];
        }
            break;
        case SelectOption_ZX1:
        {
//            十元专区100180
            typeStr = @"create_time";
            descStr = @"desc";
//            [self httpTenGoodsInfoListWith:@"100180"];
            [self getGoodsListWith:typeStr descStr:descStr];
        }
            break;
        case SelectOption_JD:
        {
            typeStr = @"progress";
            descStr = @"desc";
             [self getGoodsListWith:typeStr descStr:descStr];
//             [self httpTenGoodsInfoListWith:@"100185"];
        }
            break;
        case SelectOption_DuplicateJD:
        {
            typeStr = @"progress";
            descStr = @"asc";
             [self getGoodsListWith:typeStr descStr:descStr];
//             [self httpTenGoodsInfoListWith:@"100185"];
        }
            break;
        case SelectOption_ZXRC:
        {
//          百元专区  . 100193
            typeStr = @"need_people";
            descStr = @"desc";
            [self getGoodsListWith:typeStr descStr:descStr];
        }
            break;
        case SelectOption_DuplicateZXRC:
        {
            typeStr = @"need_people";
            descStr = @"asc";
             [self getGoodsListWith:typeStr descStr:descStr];
        }
            break;
        case SelectOption_HJZQ:
        {
            typeStr = @"now_people";
            descStr = @"desc";
            [self getGoodsListWith:typeStr descStr:descStr];
//           [self httpTenGoodsInfoListWith:@"100186"];
        }
            break;

        default:
            break;
    }

   
}
-(void)getGoodsListWith:(NSString *)typeStr descStr:(NSString *)descStr{
    __weak HomePageViewController *weakSelf = self;
    [HttpHelper getGoodsListWithOrder_by_name:typeStr
                                order_by_rule:descStr
                                      pageNum:[NSString stringWithFormat:@"%d",pageNum]
                                     limitNum:@"0"
                                      success:^(NSDictionary *resultDic){
                                          [weakSelf hideRefresh];
                                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                                [weakSelf handleGetGoodsListLoadResult:resultDic typeId:typeStr];
                                          }
                                          
                                      }fail:^(NSString *decretion){
                                          [weakSelf hideRefresh];
                                          [Tool showPromptContent:decretion onView:weakSelf.view];
                                      }];
    
}

-(void)httpTenGoodsInfoListWith:(NSString *)typeId{

    __weak HomePageViewController *weakSelf = self;
    [HttpHelper getGoodsListOfTypeWithGoodsTypeIde:typeId
                                           success:^(NSDictionary *resultDic){
                                               [self hideRefresh];
                                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                                   [weakSelf handleGetTenGoodsListLoadResult:resultDic];
                                               }else
                                               {
                                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                               }
                                           }fail:^(NSString *decretion){
                                               [self hideRefresh];
                                               [Tool showPromptContent:decretion onView:self.view];
                                           }];
}


- (void)handleGetTenGoodsListLoadResult:(NSDictionary *)resultDic
{
    if (goodsDataSourceArray.count > 0 && pageNum == 1) {
        [goodsDataSourceArray removeAllObjects];
        
    }
    //    goodsTypeList
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsTypeList"];
    MLog(@"handleGetGoodsListLoadResult%@",resultDic);
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            //            MLog(@"goodsList%@",dic);
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            if ([ShareManager shareInstance].isEnterMK) {
                if ([info.good_name containsString:@"秒开"]) {
                    [goodsDataSourceArray addObject:info];
                }
            }else{
                if ([info.good_name containsString:@"秒开"]) {
                   
                }else{
                    [goodsDataSourceArray addObject:info];
                }
            }
        }
        
        if (resourceArray.count < 100) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
//        pageNum++;
    }
    
    
    
    //刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    isEnd = YES;
    
    if (isClickButton) {
        //        [self updateTableOffset];
        isClickButton = NO;
    }
}

- (void)handleGetGoodsListLoadResult:(NSDictionary *)resultDic typeId:(NSString *)typeStr
{
    if (goodsDataSourceArray.count > 0 && pageNum == 1) {
        [goodsDataSourceArray removeAllObjects];
        
    }
//    goodsTypeList
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsList"];
    MLog(@"handleGetGoodsListLoadResult%@",resultDic);
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            if ( [typeStr isEqualToString:@"create_time" ]) {
                if ([info.good_single_price intValue] == 1000) {
                    [goodsDataSourceArray addObject:info];
                }
            }
            if ([typeStr isEqualToString:@"now_people" ]&&(slectType == SelectOption_HJZQ)) {
                if ([info.good_single_price intValue] == 10000) {
                    [goodsDataSourceArray addObject:info];
                }
            }else if([typeStr isEqualToString:@"now_people" ]){
                [goodsDataSourceArray addObject:info];
            }
            
            if ( [typeStr isEqualToString:@"need_people"]||[typeStr isEqualToString:@"progress"]) {
                    [goodsDataSourceArray addObject:info];
            }
        }
        
        if (resourceArray.count < 100) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
//        pageNum++;
    }
    
    
    
    //刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
//    [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
    [_myTableView reloadData];
    isEnd = YES;
    
    if (isClickButton) {
//        [self updateTableOffset];
        isClickButton = NO;
    }
}





- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
    __weak HomePageViewController *weakSelf = self;
    [HttpHelper addGoodsForShopCartWithUserId:[ShareManager shareInstance].userinfo.id
                                goods_ids:goodIds
                           goods_buy_nums:buyNum
                                  success:^(NSDictionary *resultDic){

                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                          [weakSelf handleloadAddGoodsToShopCartResult:resultDic buyNum:buyNum];
                                      }else
                                      {
                                          [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:weakSelf.view];
                                      }
                                  }fail:^(NSString *decretion){
                                      [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                                  }];
}

- (void)handleloadAddGoodsToShopCartResult:(NSDictionary *)resultDic buyNum:(NSString *)buyNum
{
//    [Tool getUserInfo];
//    NSString *status = resultDic[@"desc"];
//    if ([status isEqualToString:@"成功"]) {
//        self.tabBarController.tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%d",bagde+1];
//    }
//    bagde += 1;
//    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
}

- (void)httpGetShopCartList
{
    __weak HomePageViewController  *weakSelf = self;
    [HttpHelper getShopCartListWithUserId:[ShareManager shareInstance].userinfo.id
                                  success:^(NSDictionary *resultDic){
                                      [self hideRefresh];
                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                          [weakSelf handleloadCarResult:resultDic];
                                      }else
                                      {
                                          [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                      }
                                  }fail:^(NSString *decretion){
                                      [self hideRefresh];
                                      [Tool showPromptContent:decretion onView:self.view];
                                  }];
}

- (void)handleloadCarResult:(NSDictionary *)resultDic
{
    MLog(@"handleloadResult%@",resultDic);

//    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"shopCartList"];
//    bagde = (int)resourceArray.count;
//    if(bagde != 0){
//        self.tabBarController.tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%d",bagde];
//    }else{
//         self.tabBarController.tabBar.items[3].badgeValue = nil;
//    }
//   
   
}

#pragma mark - 倒计时

//倒计时
- (void)startCountDown
{
    if (timer) {
        [timer setFireDate:[NSDate distantFuture]];
    }

    if (totalTimeArray.count > 0 && totalTimeArray) {
        [totalTimeArray removeAllObjects];
        for (int i = 0; i < jiexiaoArray.count; i++) {
            [totalTimeArray addObject:@"n"];
        }
    }else{
        if (!totalTimeArray) {
            totalTimeArray = [NSMutableArray array];
            for (int i = 0; i < jiexiaoArray.count; i++) {
                [totalTimeArray addObject:@"n"];
            }
        }
    }
    BOOL isShow = NO;
    for (int i = 0; i < jiexiaoArray.count; i++) {
        JieXiaoInfo *info = [jiexiaoArray objectAtIndex:i];
        if ([info.status isEqualToString:@"倒计时"] && [info.is_show_daojishi isEqualToString:@"y"])
        {
            [totalTimeArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%lld",[info.daojishi_time longLongValue]]];
            isShow = YES;
        }
    }

    if (isShow) {
        if (timer) {
            [timer setFireDate:[NSDate distantPast]];
        }
        [self handleTimer];
    }

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

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    HomePageJXListTableViewCell *cell = (HomePageJXListTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath];

    for (int i = 0; i < totalTimeArray.count; i++) {

        NSString *timeStr = [totalTimeArray objectAtIndex:i];
        if ([timeStr isEqualToString:@"n"]) {
            continue;
        }
        long long timeValue = [timeStr longLongValue];
        timeValue = timeValue-10;
        if (timeValue < 0) {
            timeValue = 0;
            if (timer) {
                [timer setFireDate:[NSDate distantFuture]];
            }
            [cell updateTimeLabelUI:@"0" index:i];
            [totalTimeArray replaceObjectAtIndex:i withObject:@"0"];
            [self httpShowData];
            break;
        }else{
            [cell updateTimeLabelUI:timeStr index:i];
            [totalTimeArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%lld",timeValue]];
        }
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
    if (section == 2) {
        if (jiexiaoArray.count < 1) {
            return 0;
        }else{
            return 1;
        }
    }
    //我的添加
    if (section == 3){
        if (goodsDataSourceArray.count%2 == 0) {
             return goodsDataSourceArray.count/2;
        }else{
             return goodsDataSourceArray.count/2+1;
        }
    }
    
    return 1;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return FullScreen.size.width*0.65;
            break;
        case 1:
            if (ShareManager.shareInstance.isEnterMK) {
                return 145+62;
            }else{
                return 70+62;
            }
            break;
        case 2:
        {
            //只创建一个cell用作测量高度
            static HomePageJXListTableViewCell *cell = nil;
//            if (!cell)
//            {
//                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageJXListTableViewCell" owner:nil options:nil];
//                cell = [nib objectAtIndex:0];
//                [cell initImageCollectView];
//                cell.collectView.delegate = cell;
//                cell.collectView.dataSource = cell;
//            }
//
//            [self loadCellContent:cell indexPath:indexPath];
            return 0;
        }
            break;
        default:
        {
            
            //只创建一个cell用作测量高度
            /*
             static GoodsViewTableViewCell *cell = nil;
             if (!cell)
             {
             NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsViewTableViewCell" owner:nil options:nil];
             cell = [nib objectAtIndex:0];
             [cell initImageCollectView];
             cell.collectView.delegate = cell;
             cell.collectView.dataSource = cell;
             }
             
             [self loadGoodsCellContent:cell indexPath:indexPath];
             return [self getGoodsCellHeight:cell];
             */
            return 235;
        }
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section > 2)
    {
        return 40;

    }else{

        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section < 3) {

        return nil;
    }

    CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 40);
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor whiteColor];

    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 39, FullScreen.size.width, 1)];
    lineview.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    [bgView addSubview:lineview];

    //人气
    rqControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, FullScreen.size.width/5, frame.size.height)];
    [rqControl addTarget:self action:@selector(clickRQButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rqLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rqControl.width, 20)];
    rqLabel.text = @"人气推荐";
    rqLabel.center = rqControl.center;
    rqLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    rqLabel.textAlignment = NSTextAlignmentCenter;
    rqLabel.font = [UIFont systemFontOfSize:12];
    [rqControl addSubview:rqLabel];

    rqLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    rqLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [rqControl addSubview:rqLine];
    [bgView addSubview:rqControl];

    //最新
    zxControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/5, 0, FullScreen.size.width/5, frame.size.height)];
    [zxControl addTarget:self action:@selector(clickZXButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    zxLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, zxControl.width, 20)];
    zxLabel.text = @"十元专区";
    zxLabel.center = CGPointMake(zxControl.width/2, zxControl.height/2);
    zxLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    zxLabel.textAlignment = NSTextAlignmentCenter;
    zxLabel.font = [UIFont systemFontOfSize:12];
    [zxControl addSubview:zxLabel];
    zxLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    zxLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [zxControl addSubview:zxLine];
    [bgView addSubview:zxControl];

    //进度
    jdControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/5*2, 0, FullScreen.size.width/5, frame.size.height)];
    [jdControl addTarget:self action:@selector(clickJDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    jdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, jdControl.frame.size.width, 20)];
    jdLabel.text = @"开奖进度";
    jdLabel.center = CGPointMake(jdControl.width/2-2, jdControl.height/2);
    jdLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    jdLabel.textAlignment = NSTextAlignmentCenter;
    jdLabel.font = [UIFont systemFontOfSize:12];
    [jdControl addSubview:jdLabel];
    jdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cont_updown"]];
    jdImage.frame = CGRectMake(0, 0, 8, 12);
    jdImage.center = CGPointMake(rqControl.center.x + 20, rqControl.center.y);
//    [jdControl addSubview:jdImage];
    jdLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    jdLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [jdControl addSubview:jdLine];
    [bgView addSubview:jdControl];

    //总需人次
    zxrcControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/5*3, 0, FullScreen.size.width/5, frame.size.height)];
    [zxrcControl addTarget:self action:@selector(clickHJZQButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    zxscLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    zxscLabel.text = @"百元专区";
    zxscLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    zxscLabel.center = CGPointMake(zxrcControl.width/2-5, zxrcControl.height/2);
    zxscLabel.textAlignment = NSTextAlignmentCenter;
    zxscLabel.font = [UIFont systemFontOfSize:12];
    [zxrcControl addSubview:zxscLabel];
    zxrcImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cont_updown"]];
    zxrcImage.frame = CGRectMake(0, 0, 8, 12);
    zxrcImage.center = CGPointMake(zxrcControl.width/2+29, zxrcControl.height/2);
//    [zxrcControl addSubview:zxrcImage];
    zxrcLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    zxrcLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [zxrcControl addSubview:zxrcLine];
    [bgView addSubview:zxrcControl];
    
    
    //总需人次
    hjrcControl = [[UIControl alloc]initWithFrame:CGRectMake(FullScreen.size.width/5*4, 0, FullScreen.size.width/5, frame.size.height)];
    [hjrcControl addTarget:self action:@selector(clickZXRCButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    hjLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    hjLabel.text = @"总需人次";
    hjLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1];
    hjLabel.center = CGPointMake(hjrcControl.width/2-5, hjrcControl.height/2);
    hjLabel.textAlignment = NSTextAlignmentCenter;
    hjLabel.font = [UIFont systemFontOfSize:12];
    [hjrcControl addSubview:hjLabel];
    hjrcLine = [[UILabel alloc]initWithFrame:CGRectMake(8, rqControl.height-3, rqControl.width-16, 3)];
    hjrcLine.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:48.0/255.0 blue:48.0/255.0 alpha:1];
    [hjrcControl addSubview:hjrcLine];
    [bgView addSubview:hjrcControl];

    [self updateSelectStatue];

    return bgView;
}


//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MLog(@"count%lu",(unsigned long)goodsDataSourceArray.count);
    switch (indexPath.section) {
        case 0:
        {
            BannerTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"BannerTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BannerTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.bannerView.delegate = self;
                cell.bannerView.dataSource = self;
                cell.bannerView.autoScrollAble = YES;
                cell.bannerView.tag = 100;
                cell.bannerView.direction = CycleDirectionLandscape;
                
                objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
                tap.numberOfTapsRequired = 1;
                objc_setAssociatedObject(tap, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                [cell.bannerView addGestureRecognizer:tap];
                
                _bannerCell = cell;
            }
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
            break;
        case 1:
        {
            
            HomePageIconTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageIconTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageIconTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                
                cell.bannerView.delegate = self;
                cell.bannerView.dataSource = self;
                cell.bannerView.autoScrollAble = YES;
                cell.bannerView.tag = 200;
                cell.bannerView.direction = CycleDirectionPortait;
                objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                _radioCell = cell;
            }
            
            if (ShareManager.shareInstance.isEnterMK) {
                 cell.bottomView.hidden = NO;
            }else{
                cell.bottomView.hidden = YES;
            }
            cell.liftValueLabel.text = [NSString stringWithFormat:@"%0.2f",[self.lift doubleValue]];
            cell.liftLabel.text = [NSString stringWithFormat:@"%0.2f%@",[self.lift doubleValue]/10,@"%"];
            
            cell.iconWidth.constant = (FullScreen.size.width -24-24)/4;
            cell.flControl.tag = 100;
            
            [cell.flControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.syControl.tag = 200;
            [cell.syControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if([ShareManager shareInstance].isEnterMK){
                cell.flImageView.image = [UIImage imageNamed:@"cont_class"];
                cell.flLabel.text = @"分类";
            }else{
                cell.flImageView.image = [UIImage imageNamed:@"miao"];
                cell.flLabel.text = @"秒奖";
            }
          
            cell.typeIcon.layer.masksToBounds =YES;
            cell.typeIcon.layer.cornerRadius = cell.typeIcon.frame.size.height/2;
            cell.sdControl.tag = 300;
            [cell.sdControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.cjwtControl.tag = 400;
            
            if ([[ShareManager shareInstance].userinfo.user_agency isEqualToString:@"1"]) {
                cell.forthImageView.image = [UIImage imageNamed:@"cont_invite.png"];
                cell.forthTitleLabel.text = @"邀请好友";
            }else{
                cell.forthImageView.image = [UIImage imageNamed:@"68icon"];
                cell.forthTitleLabel.text = @"68专区";
            }
            
            [cell.cjwtControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.zpControl.tag = 500;
            [cell.zpControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.wcControl.tag = 600;
            [cell.wcControl addTarget:self action:@selector(clickIconButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            HomePageJXListTableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HomePageJXListTableViewCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomePageJXListTableViewCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];

                [cell initImageCollectView];
                cell.delegate = self;
                cell.collectView.delegate = cell;
                cell.collectView.dataSource = cell;

            }
            [cell.moreButton addTarget:self action:@selector(clickMoreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self loadCellContent:cell indexPath:indexPath];
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //            cell.collectView.scrollEnabled = NO;
            //            tableView.scrollEnabled = NO;
            return cell;
        }
            break;
        default:
        {
            
            newGoodsCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"newGoodsCell"];
            
            if (cell==nil){
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"newGoodsCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
            }
//            if (ShareManager.shareInstance.isEnterMK) {
//                cell.leftAddShopCarBtn.hidden = NO;
//                cell.rightAddShopCarBtn.hidden = NO;
//            }else{
                cell.leftAddShopCarBtn.hidden = YES;
                cell.rightAddShopCarBtn.hidden = YES;
//            }
            
            GoodsListInfo *leftInfo = [goodsDataSourceArray objectAtIndex:2*indexPath.row];
            // 单击的 Recognizer
            UITapGestureRecognizer* singleRecognizer;
            singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
            //点击的次数
            singleRecognizer.numberOfTapsRequired = 1; // 单击
            
            //给self.view添加一个手势监测；
            [cell.leftView addGestureRecognizer:singleRecognizer];
            cell.leftView.tag = 2*indexPath.row;
            cell.lefeNewProcess.progress = [leftInfo.progress doubleValue]/100.0;
            
            [cell.leftPhotoImage sd_setImageWithURL:[NSURL URLWithString:leftInfo.good_header] placeholderImage:PublicImage(@"defaultImage")];
            cell.leftTitleLabel.text = leftInfo.good_name;
            cell.leftProcessNumLabel.text = [NSString stringWithFormat:@"%@％",leftInfo.progress];
            cell.leftAddButton.tag = 2*indexPath.row;
            
            [cell.leftAddButton addTarget:self action:@selector(clickAddShopCarButtonWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.leftPriceButton.hidden = YES;
            cell.leftBuyLabel.text = [NSString stringWithFormat:@"%ld",(long)leftInfo.now_people];
            cell.leftNeedLabel.text = [NSString stringWithFormat:@"%ld",(long)leftInfo.need_people];
            cell.leftRemaLabel.text = [NSString stringWithFormat:@"%ld",(long)(leftInfo.need_people-leftInfo.now_people)];
            [cell.leftAddShopCarBtn whenTapped:^{
                [self httpAddGoodsToShopCartWithGoodsID:leftInfo.good_id buyNum:[NSString stringWithFormat:@"%d",[leftInfo covertToGoodsDetailInfo].defaultPurchaseCount]];
            }];
            
            if (leftInfo.good_single_price.intValue == 1000) {
                cell.leftPriceButton.hidden = NO;
                [cell.leftPriceButton setBackgroundImage:[UIImage imageNamed:@"new10Icon"] forState:UIControlStateNormal];
                [cell.leftPriceButton setBackgroundImage:[UIImage imageNamed:@"new10Icon"] forState:UIControlStateSelected];
                float rate = 0.8 * UIAdapteRate;
                cell.leftPriceButton.frame = CGRectMake(8 * UIAdapteRate, 0, 27 * rate, 33.5 * rate);
            }
            
            if (leftInfo.good_single_price.intValue == 10000) {
                cell.leftPriceButton.hidden = NO;
                [cell.leftPriceButton setBackgroundImage:[UIImage imageNamed:@"new100Icon"] forState:UIControlStateNormal];
                [cell.leftPriceButton setBackgroundImage:[UIImage imageNamed:@"new100Icon"] forState:UIControlStateSelected];
                float rate = 0.8 * UIAdapteRate;
                cell.leftPriceButton.frame = CGRectMake(8 * UIAdapteRate, 0, 27 * rate, 33.5 * rate);
            }
            
            
//            NSString *str = leftInfo.part_sanpei;
//            if ([str isEqualToString:@"y"]) {
//                cell.leftPriceButton.hidden = NO;
//                [cell.leftPriceButton setBackgroundImage:[UIImage imageNamed:@"icon_thrice"] forState:UIControlStateNormal];
//                [cell.leftPriceButton setBackgroundImage:[UIImage imageNamed:@"icon_thrice"] forState:UIControlStateSelected];
//                float rate = 0.8 * UIAdapteRate;
//                cell.leftPriceButton.frame = CGRectMake(8 * UIAdapteRate, 4 * UIAdapteRate, 61 * rate, 37 * rate);
//            }
            
            if (indexPath.row<goodsDataSourceArray.count/2) {
                cell.rightView.hidden = NO;
                cell.rightPhotoImage.hidden = NO;
            GoodsListInfo *rightInfo = [goodsDataSourceArray objectAtIndex:2*indexPath.row+1];
            // 单击的 Recognizer
            UITapGestureRecognizer* rightSingleRecognizer;
            
            rightSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
            //点击的次数
            rightSingleRecognizer.numberOfTapsRequired = 1; // 单击
            
            //给self.view添加一个手势监测；
            [cell.rightView addGestureRecognizer:rightSingleRecognizer];
            cell.rightView.tag = 2*indexPath.row+1;
            cell.rightNewProcess.progress = [rightInfo.progress doubleValue]/100.0;
            
            [cell.rightPhotoImage sd_setImageWithURL:[NSURL URLWithString:rightInfo.good_header] placeholderImage:PublicImage(@"defaultImage")];
            
            cell.rightTitleLabel.text = rightInfo.good_name;
            cell.rightProcessNumLabel.text = [NSString stringWithFormat:@"%@％",rightInfo.progress];
            
            cell.rightAddButton.tag = 2*indexPath.row+1;
            
            [cell.rightAddButton addTarget:self action:@selector(clickAddShopCarButtonWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.rightPriceButton.hidden = YES;
            
            cell.rightPriceButton.frame = CGRectMake(10 * UIAdapteRate+self.view.frame.size.width, 0, 28* UIAdapteRate, 31 * UIAdapteRate);
            
            cell.rightBuyLabel.text = [NSString stringWithFormat:@"%ld",(long)rightInfo.now_people];
            cell.rightNeedLabel.text = [NSString stringWithFormat:@"%ld",(long)rightInfo.need_people];
            cell.rightRemaLabel.text = [NSString stringWithFormat:@"%ld",(long)(rightInfo.need_people-rightInfo.now_people)];
            [cell.rightAddShopCarBtn whenTapped:^{
                    [self httpAddGoodsToShopCartWithGoodsID:rightInfo.good_id buyNum:[NSString stringWithFormat:@"%d",[leftInfo covertToGoodsDetailInfo].defaultPurchaseCount]];
                }];
                
                
            if (rightInfo.good_single_price.intValue == 1000) {
                cell.rightPriceButton.hidden = NO;
                [cell.rightPriceButton setBackgroundImage:[UIImage imageNamed:@"new10Icon"] forState:UIControlStateNormal];
                [cell.rightPriceButton setBackgroundImage:[UIImage imageNamed:@"new10Icon"] forState:UIControlStateSelected];
                float rate = 0.8 * UIAdapteRate;
                cell.rightPriceButton.frame = CGRectMake(8 * UIAdapteRate+self.view.frame.size.width/2, 0, 27 * rate, 33.5 * rate);
            }
                
                
            if (rightInfo.good_single_price.intValue == 10000) {
                    cell.rightPriceButton.hidden = NO;
                    [cell.rightPriceButton setBackgroundImage:[UIImage imageNamed:@"new100Icon"] forState:UIControlStateNormal];
                    [cell.rightPriceButton setBackgroundImage:[UIImage imageNamed:@"new100Icon"] forState:UIControlStateSelected];
                    float rate = 0.8 * UIAdapteRate;
                    cell.rightPriceButton.frame = CGRectMake(8 * UIAdapteRate+self.view.frame.size.width/2, 0, 27 * rate, 33.5 * rate);
                }
                
//            
//            
//            NSString *rightStr = rightInfo.part_sanpei;
//            if ([rightStr isEqualToString:@"y"]) {
//                cell.rightPriceButton.hidden = NO;
//                [cell.rightPriceButton setBackgroundImage:[UIImage imageNamed:@"icon_thrice"] forState:UIControlStateNormal];
//                [cell.rightPriceButton setBackgroundImage:[UIImage imageNamed:@"icon_thrice"] forState:UIControlStateSelected];
//                float rate = 0.8 * UIAdapteRate;
//                cell.rightPriceButton.frame = CGRectMake(8 * UIAdapteRate+self.view.frame.size.width/2, 4 * UIAdapteRate, 61 * rate, 37 * rate);
//            }
            }else{
                cell.rightView.hidden = YES;
                cell.rightView.hidden = YES;
                cell.rightPhotoImage.hidden = YES;
                cell.rightPriceButton.hidden = YES;
                
            }
            //设点点击选择的颜色(无)
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
        return cell;
            
    }
            break;
    }
    return nil;
}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    //处理单击操作
  
    GoodsListInfo *info = goodsDataSourceArray[recognizer.view.tag];
    if ([info isThriceGoods]) {
    } else {
        
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc] initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
         [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)loadCellContent:(HomePageJXListTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    cell.dataSourceArray = jiexiaoArray;
    [cell.collectView reloadData];

}

- (CGFloat)getCellHeight:(HomePageJXListTableViewCell*)cell
{

    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGFloat height = cell.collectView.contentSize.height;
    return height+26;

}


#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->pageNum = 1;
        [weakSelf httpShowData];
        [weakSelf httpGetGoodsList];
//        [weakSelf getLiftData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetGoodsList];
        
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
        [_myTableView.mj_header endRefreshing];
    }
}

#pragma mark - CycleScrollViewDataSource

- (UIView *)cycleScrollView:(CycleScrollView *)cycleScrollView viewAtPage:(NSInteger)page
{
    if (cycleScrollView.tag == 100) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        BannerInfo *bannerInfo = [bannerArray objectAtIndex:page];
        NSString *url = [NSString stringWithFormat:@"%@",bannerInfo.header];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        return imageView;
        
    }else{
        
        UILabel *warnLabel = [[UILabel alloc] init];
//        RadioInfo *info = [radioArray objectAtIndex:page];
        
//        NSString * reviewStr = [NSString stringWithFormat:@"恭喜<color1>“%@”</color1>获取第%@期，%@",info.nick_name,info.good_period,info.good_name];
        
//        warnLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
//
//        NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
//                                @"color1":[UIColor colorWithRed:0.0/255.0 green:64.0/255.0 blue:128.0/255.0 alpha:1]};
//
//        warnLabel.attributedText = [reviewStr attributedStringWithStyleBook:style];
//
//        warnLabel.font = [UIFont systemFontOfSize:13];
        return warnLabel;
    }
}

- (NSInteger)numberOfViewsInCycleScrollView:(CycleScrollView *)cycleScrollView
{
    if (cycleScrollView.tag == 100) {
        BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
        if (isBannerTwo) {
            cell.pageController.numberOfPages = 2;
        }else{
            cell.pageController.numberOfPages = bannerArray.count;
        }
        
        return  bannerArray.count;
        
    }else{
        return radioArray.count;
    }
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    if (cycleScrollView.tag == 100) {
        
        BannerTableViewCell *cell = objc_getAssociatedObject(cycleScrollView, "cell");
        if (isBannerTwo)
        {
            cell.pageController.currentPage = index%2;
            
        }else{
            cell.pageController.currentPage = index;
            
        }
    }
    
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    if (cycleScrollView.tag == 100) {
        return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.65);
    }else{
        return CGRectMake(0, 0, FullScreen.size.width-46,20);
    }
}

-(void)clickAddShopCarButtonWithBtn:(UIButton*)btn
{
    
    GoodsListInfo *info = [goodsDataSourceArray objectAtIndex:btn.tag];
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    _selectedGoodsInfo = [info covertToGoodsDetailInfo];
    _selectedGoodsListInfo = info;
    
    if ([info isThriceGoods]) {
        
        // 缓存红包
//        [[ShareManager shareInstance] refreshCoupons];
        
        PurchaseNumberViewController *vc = [[PurchaseNumberViewController alloc] initWithNibName:@"PurchaseNumberViewController" bundle:nil];
        vc.delegate = self;
        vc.data = [info dictionary] ;
//            [vc reloadWithData:_data];
        self.definesPresentationContext = YES; //self is presenting view controller
        vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        //        if ([self.navigationController.viewControllers.firstObject isKindOfClass:[self class]]) {
        //            [self.navigationController presentViewController:vc animated:YES completion:nil];
        //        } else {
        UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        [rootViewController presentViewController:vc animated:YES completion:nil];
        //        }
        
    } else {
        
        SelectGoodsNumViewController *vc = [[SelectGoodsNumViewController alloc] initWithNibName:@"SelectGoodsNumViewController" bundle:nil];
        
        //    vc.limitNum = [_goodsDetailInfo.good_single_price intValue];
        [vc reloadDetailInfoOnce: [info covertToGoodsDetailInfo]];
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
}

#pragma mark - SelectGoodsNumViewControllerDelegate

- (void)selectGoodsNum:(int)num goodsInfo:(GoodsDetailInfo *)goodsInfo
{
    if (_selectedGoodsListInfo) {
        [activityIndicator startAnimating];
        MLog(@"_selectedGoodsListInfo.good_single_price%@",_selectedGoodsListInfo.good_single_price);
        NSDictionary *data = [_selectedGoodsListInfo dictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
        [dict setObject:@(num) forKey:@"Crowdfunding"];
        [dict setObject:@([goodsInfo.good_single_price intValue])  forKey:@"price"];
        
        if (dict) {
            
            [self buyWithDict:dict];
//            EntOrderViewController *vc = [EntOrderViewController createWithData:dict];
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
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
    
//    if ([ShareManager shareInstance].userinfo.user_money<crowdfundingBettingCount*[price intValue]) {
//
//        [Tool showPromptContent:@"小米不足，请先获取小米哦～～" onView:[UIApplication sharedApplication].keyWindow];
        [activityIndicator stopAnimating];
        EntOrderViewController *vc = [EntOrderViewController createWithData:dict];
        
    [self.navigationController pushViewController:vc animated:YES];

        
//    }else{
//
//        [self purchaseGoodsFightID:goods_fight_ids count:crowdfundingBettingCount thricePurchase:@[] isShopCart:@"" coupon:@"" exchangedThriceCoin:0 goodsID:goods_ids buyType:buyType];
//    }
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
//     [self setTabelViewRefresh];
    [Tool showPromptContent:@"购买成功" onView: [UIApplication sharedApplication].keyWindow];
    
}

// 购买失败
- (void)purchaseFailure:(NSString *)description
{
    [activityIndicator stopAnimating];
    [Tool showPromptContent:description onView: [UIApplication sharedApplication].keyWindow];
    
}


#pragma mark - PurchaseNumberViewControllerDelegate

- (void)purchaseNumberDidSelected:(NSDictionary *)bettingData
{
    if (_selectedGoodsListInfo) {
        NSDictionary *data = [_selectedGoodsListInfo dictionary];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:data];
        
        if (bettingData) {
            [dict addEntriesFromDictionary:bettingData];
             [self buyWithDict:dict];

        }
    }
}

#pragma mark -  PayViewControllerDelegate
- (void)payForBuyGoodsSuccess
{
    
}

#pragma mark - HomePageJXListTableViewCellDelegate

- (void)selectJXGoodsInfo:(NSInteger)index
{
    JieXiaoInfo *info = [jiexiaoArray objectAtIndex:index];
    
   
    if ([info isThriceGoods]) {
        
//        ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
    } else {
        
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
//         
    [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Refresh

- (void)autorefresh
{
    NSDate *date = [NSDate date];
    NSDate *previousDate = _updatedTime;
    NSInteger seconds = [date secondsAfterDate:previousDate];
    MLog(@"seconds>>>>>%ld",(long)seconds);
    // 刷新间隔时间超过30秒，自动刷新
    if (seconds >= 30) {
        __unsafe_unretained UITableView *tableView = self.myTableView;
        [tableView setContentOffset:CGPointZero];
        [tableView.mj_header beginRefreshing];
        _updatedTime = date;
    }
}


#pragma mark - 

- (void)bannerListDidChange:(NSArray *)array
{
    NSString *str = @"";
    for (BannerInfo *object in array) {
        NSString *identify = object.id;
        if (identify.length > 0) {
            str = [str stringByAppendingString:identify];
        }
    }
    
    if (_bannerListFlag == nil || [_bannerListFlag isEqualToString:str] == NO) {
        _bannerListFlag = str;
        
        [_bannerCell.bannerView reloadData];
    }
    
    
    
    
}




@end
