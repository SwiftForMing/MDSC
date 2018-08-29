//
//  NewHomeViewController.m
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/4/20.
//  Copyright © 2018年 黎应明. All rights reserved.
//

#import "NewHomeViewController.h"
#import "BannerTableViewCell.h"
#import "HomeOddsCell.h"
#import "HomeTopCell.h"
#import "BannerInfo.h"
#import "HomeGoodModel.h"
#import "GetCouponViewController.h"
#import "GoodDetailViewController.h"
#import "GoodTypeModel.h"
#import "SafariViewController.h"
#import "AdvertisementViewController.h"
#import "MallCollectionViewController.h"
#import "HomePageViewController.h"
#import "HomeOneCell.h"
#import "FreeGoTableViewController.h"
#import "CouponViewController.h"



//#import "MagicMoveTransition.h"
//#import "UINavigationController+JXNavigationController.h"
//#import "UIViewController+JXViewController.h"
@interface NewHomeViewController ()<ChangeDelegate>{
    
    NSMutableArray *bannerArray;
    BOOL isBannerTwo;
    NSMutableArray *goodsArray;
    int page;
}
@property (nonatomic, strong) BannerTableViewCell *bannerCell;
@property (nonatomic, copy) NSString *bannerListFlag;

@end

@implementation NewHomeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    CGFloat y = ScreenHeight == 812.0 ? -44:-20;
    self.tableView.frame = CGRectMake(0, y, ScreenWidth, ScreenHeight);
    
    [ShareManager shareInstance].isInYlc = NO;
    page = 0;
    self.title = @"首页";
    [self hidenLeftBarButton];
    bannerArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(notificationFunction)
                                                name:kLoginSuccess
                                              object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(notificationFunction)
                                                name:kUpdateUserNotification
                                              object:nil];
    
    [self getData];
    [self setTabelViewRefresh];
    
}

-(void)showLogin
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:true viewController:nil];
    }
    
    
}


-(void)notificationFunction{
    [self getData];
    [self setTabelViewRefresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

     self.navigationController.navigationBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showLogin)
                                                name:appIsNotInReview
                                              object:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [ShareManager shareInstance].isEnterMK = NO;
//    MLog(@"[ShareManager shareInstance].isEnterMK%id",[ShareManager shareInstance].isEnterMK);
    [self.tableView reloadData];
    
}

-(void)getData{
    
    __weak NewHomeViewController *weakSelf = self;
    [HttpHelper getHttpWithUrlStr:URL_HomeBasics
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  
                                  [self handleloadResult:resultDic];
                              }
                          }fail:^(NSString *decretion){
                              [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                          }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
        MLog(@"handleloadResult%@",dic);
    NSArray *goodsTypeArrar = [dic objectForKey:@"goodsTypeList"];
    NSMutableArray *typeArray = [NSMutableArray array];
    if (goodsTypeArrar && goodsTypeArrar.count > 0) {
        for (NSDictionary *dic in goodsTypeArrar)
        {
            GoodTypeModel *model =  [dic objectByClass:[GoodTypeModel class]];
            [typeArray addObject:model];
        }
        [ShareManager shareInstance].ClassifyData = typeArray;
        
    }else{
        [ShareManager shareInstance].ClassifyData = @[];
    }
    NSArray *banArray = [dic objectForKey:@"advertisementList"];
    
    if (banArray && banArray.count > 0) {
        if (bannerArray.count > 0) {
            [bannerArray removeAllObjects];
        }
        for (NSDictionary *dic in banArray)
        {
            //             MLog(@"banArray:%@",dic);
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
    [self.tableView reloadData];
}
#pragma mark 获取历表数据
-(void)getListData{
    __weak NewHomeViewController *weakSelf = self;
    [HttpHelper getHomeListDataWithPageNum:[NSString stringWithFormat:@"%d",page] limitNum:@"20" success:^(NSDictionary *resultDic) {
        [weakSelf hideRefresh];
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            
            [self handleloadListResult:resultDic];
        }
        
    } fail:^(NSString *description) {
        [weakSelf hideRefresh];
        [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
    }];
    
}

- (void)handleloadListResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    MLog(@"handleloadListResult%@",dic);
    NSArray *goodArray = [dic objectForKey:@"goodsList"];
    if (goodArray && goodArray.count > 0) {
        if (goodsArray.count > 0&&page == 1) {
            [goodsArray removeAllObjects];
        }
        for (NSDictionary *dic in goodArray)
        {
            
            HomeGoodModel *info = [dic objectByClass:[HomeGoodModel class]];
            [goodsArray addObject:info];
        }
    }
    
    if (goodArray.count < 20) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    page++;
    
    //刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section!=2) {
        return 1;
    }else{
        if (goodsArray.count%2 == 0){
            return goodsArray.count/2;
        }else{
            return (goodsArray.count/2)+1;
        }
//        return goodsArray.count;
    }
}


-(UIImage *)getImageWithTag:(int)tag{
    UIImage *img = [UIImage imageNamed:@""];
    if (tag == 1) {
        img = [UIImage imageNamed:@"miao"];
    }
    if (tag == 2) {
        img = [UIImage imageNamed:@"shicai"];
    }
    if (tag == 3) {
        img = [UIImage imageNamed:@"long"];
    }
    if (tag == 4) {
        img = [UIImage imageNamed:@"wuxin"];
    }
    return img;
}

-(NSString *)getTitleWithTag:(int)tag{
    NSString *title = @"";
    if (tag == 1) {
        title = @"秒开";
    }
    if (tag == 2) {
        title = @"十分奖";
    }
    if (tag == 3) {
        title = @"百倍金龙";
    }
    if (tag == 4) {
        title = @"五行";
    }
    return title;
}

-(NSString *)getDesTitleWithTag:(int)tag{
    NSString *title = @"";
    if (tag == 1) {
        title = @"极速秒开 无需等待";
    }
    if (tag == 2) {
        title = @"用时时彩 公平公正";
    }
    if (tag == 3) {
        title = @"疯狂转盘。刺激尽兴";
    }
    if (tag == 4) {
        title = @"购物福利。免费兑换";
    }
    return title;
}

-(void)changeVCWithIsMK:(BOOL)isMK{
   
//    if (isMK) {
//        [self getpushWithTag:2];
//    }else{
//        [self getpushWithTag:1];
//    }
}

-(void)getpushWithTag:(int)tag{
    if (tag == 1) {
        if([Tool islogin]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMK"];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
            [self.tabBarController.tabBar setHidden:YES];
            [ShareManager shareInstance].isEnterMK = YES;
            EntTabBarViewController * entBarVC = [[EntTabBarViewController alloc] init];
            entBarVC.vcdelegate = self;
            [self.navigationController pushViewController:entBarVC animated:YES];
        }else{
            [Tool loginWithAnimated:YES viewController:nil];
        }
        

    }
    if (tag == 2) {
         if([Tool islogin]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        [self.tabBarController.tabBar setHidden:YES];
        [ShareManager shareInstance].isEnterMK = NO;
        EntTabBarViewController * entBarVC = [[EntTabBarViewController alloc] init];
        entBarVC.vcdelegate = self;
        [self.navigationController pushViewController:entBarVC animated:YES];
         
         }else{
                [Tool loginWithAnimated:YES viewController:nil];
              }
    }
    if (tag == 3) {
         if([Tool islogin]){
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMK"];
        [self.tabBarController.tabBar setHidden:YES];
        RotaryViewController * rotVC = [[RotaryViewController alloc]initWithNibName:@"RotaryViewController" bundle:nil];
//         [self.navigationController pushViewController:rotVC animated:YES];
      [self.navigationController hh_pushViewController:rotVC style:AnimationStyleRippleEffect];
         }else{
              [Tool loginWithAnimated:YES viewController:nil];
         }
    }
    if (tag == 4) {
        MallCollectionViewController *vc = [[MallCollectionViewController alloc] initWithNibName:@"MallCollectionViewController" bundle:nil];

    [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
        
    }
    if(tag == 5){
         if([Tool islogin]){
         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isMK"];
        [self.tabBarController.tabBar setHidden:YES];
        FireViewController * rotVC = [[FireViewController alloc]initWithNibName:@"FireViewController" bundle:nil];
        [self.navigationController hh_pushViewController:rotVC style:AnimationStyleRippleEffect];
         }else{
               [Tool loginWithAnimated:YES viewController:nil];
         }
    }
    
}
//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            if ([[ShareManager shareInstance] isInReview]||![ShareManager shareInstance].isNotNet) {
                SelectCell *cell = nil;
            
                cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCell"];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectCell" owner:nil options:nil];
                    cell = [nib objectAtIndex:0];
                }
                //设点点击选择的颜色(无)
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.leftTitle.text = @"天天兑换";
                cell.leftDesTitle.text = @"天天领豆来兑换";
                cell.rightTitle.text = @"我的券";
                cell.rightDesTitle.text = @"开开心心来用券";
                cell.leftImageView.image = [UIImage imageNamed:@"mj"];
                cell.rightImageView.image = [UIImage imageNamed:@"ssj"];
                [cell.leftView whenTapped:^{
                    [self getpushWithTag:4];
                }];

                [cell.rightView whenTapped:^{
                    CouponViewController *couponVC = [[CouponViewController alloc]initWithTableViewStyle:1];
                    [self.navigationController pushViewController:couponVC animated:YES];

                }];
               
                return cell;
                
            }else{
                NSArray *showArr = [[ShareManager shareInstance].userinfo.home_show componentsSeparatedByString:@","];
                MLog(@"showArr%@",showArr);
//                if ([ShareManager shareInstance].userinfo.home_show == NULL&&Tool.islogin){
//                    MLog(@"ShareManagershowArr");
//                    [Tool autoLoginSuccess:^(NSDictionary *dict) {
//                         MLog(@"ShareManagershowArrdict%@",dict);
//                        NSDictionary *resultDic = [dict objectForKey:@"data"];
//                        UserInfo *info = [resultDic objectByClass:[UserInfo class]];
//                        [ShareManager shareInstance].userinfo = info;
//                        [Tool saveUserInfoToDB:YES];
//                        [self.tableView reloadData];
//                        return;
//                    } fail:^(NSString *error) {
//                        MLog(@"ShareManagershowArrerror%@",error);
//                        return;
//                    }];
//                }
                
                if (showArr.count == 1) {
                    
                    HomeOneCell *cell = nil;
                    cell = [tableView dequeueReusableCellWithIdentifier:@"HomeOneCell"];
                    if (cell == nil)
                    {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeOneCell" owner:nil options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    //设点点击选择的颜色(无)
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    int tag = [showArr.firstObject intValue];
                    cell.leftImage.image = [self getImageWithTag:tag];
                    [cell.leftImage whenTapped:^{
                        [self getpushWithTag:tag];
                    }];
                    return cell;
                }else{
                    HomeOddsCell *cell = nil;
                    cell = [tableView dequeueReusableCellWithIdentifier:@"HomeOddsCell"];
                    if (cell == nil)
                    {
                        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeOddsCell" owner:nil options:nil];
                        cell = [nib objectAtIndex:0];
                    }
                    //设点点击选择的颜色(无)
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    int a = [showArr[0] intValue];
                    
                    cell.leftImage.image = [self getImageWithTag:1];
                    cell.leftLabel.text = [self getTitleWithTag:1];
                    
                    [cell.leftView whenTapped:^{
                        [self getpushWithTag:a];
                    }];
                    cell.centerImage.image = [self getImageWithTag:2];
                    cell.centerLabel.text = [self getTitleWithTag:2];
                    
                    [cell.centerView whenTapped:^{
                        [self getpushWithTag:2];
                    }];
                    
                    cell.fireImage.image = [self getImageWithTag:4];
                    cell.fireLabel.text = [self getTitleWithTag:4];
                    
                    [cell.fireView whenTapped:^{
                        [self getpushWithTag:5];
                    }];
                    
                    cell.rightImage.image = [self getImageWithTag:3];
                    cell.rightLabel.text = [self getTitleWithTag:3];
                    //测试金木水火土
                  
                    [cell.rightView whenTapped:^{
                        [self getpushWithTag:3];
                    }];
                    return cell;
                }
            }
            
        }
            break;
        default:
        {

            NewShopHomeListCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewShopHomeListCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewShopHomeListCell" owner:nil options:nil];
                        cell = [nib objectAtIndex:0];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapFuction:)];
            tap.numberOfTapsRequired = 1;
            cell.leftView.tag = indexPath.row*2;
            cell.leftModel = [goodsArray objectAtIndex:indexPath.row*2];
            [cell.leftView addGestureRecognizer:tap];
        
            //当数据为单数是隐藏右边View
            if ((indexPath.row*2 == goodsArray.count-1) && !(goodsArray.count%2 == 0)) {
                cell.rightView.hidden = YES;
            }else{
                cell.rightView.hidden = NO;
                UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapFuction:)];
                tap.numberOfTapsRequired = 1;
                cell.rightView.tag = indexPath.row*2+1;
                cell.rightModel = [goodsArray objectAtIndex:indexPath.row*2+1];
                [cell.rightView addGestureRecognizer:tap1];
            }
            
            return cell;
     
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return FullScreen.size.width*0.6;
            break;
        case 1:{
//            NSArray *showArr = [[ShareManager shareInstance].userinfo.home_show componentsSeparatedByString:@","];
//            if (showArr.count == 0||[ShareManager shareInstance].isInReview){
//                return 0;
//            }else{
//                if ([ShareManager shareInstance].isInReview) {
//                    return 0;
//                }else{
                    return 90;
//                }
//                
//            }
        }
            break;
        default:{

            return 265;
            
        }
            break;
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.001;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        return 30;
    }else{
        return 0;
    }
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HeaderView *header =  [NSBundle.mainBundle loadNibNamed:@"HeaderView" owner:nil options:nil].firstObject;
    if (section == 2) {
        header.frame = CGRectMake(0, 0, ScreenWidth, 30);
        header.leftLabel.text = @"精选好货";
    }
   
    return header;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (indexPath.section == 2) {
//        GoodDetailViewController *vc = [[GoodDetailViewController alloc]initWithTableViewStyle:0];
//        vc.goodModel = [goodsArray objectAtIndex:indexPath.row];
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
//    }
//}

- (void)cellTapFuction:(UITapGestureRecognizer *) tap{
    HomeGoodModel *model = goodsArray[tap.view.tag];
    GoodDetailViewController *vc = [[GoodDetailViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = model;
    self.hidesBottomBarWhenPushed = NO;
    [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
//    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - 领取操作
-(void)lqBtnClick:(UIButton *)btn{
    GetCouponViewController *vc = [[GetCouponViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = [goodsArray objectAtIndex:btn.tag];
//     
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf getData];
        [weakSelf getListData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getListData];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([self.tableView.mj_footer isRefreshing])
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if([self.tableView.mj_header isRefreshing])
    {
        [self.tableView.mj_header endRefreshing];
    }
}


#pragma mark -

- (void)bannerListDidChange:(NSArray *)array
{
    NSString *str = @"";
    for (BannerInfo *object in array) {
        NSString *identify = object.id;
        MLog(@"identify：%@",identify);
        if (identify.length > 0) {
            str = [str stringByAppendingString:identify];
        }
    }
    
    if (_bannerListFlag == nil || [_bannerListFlag isEqualToString:str] == NO) {
        _bannerListFlag = str;
        MLog(@"str：%@",str);
        [_bannerCell.bannerView reloadData];
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
        UIImageView *imageView = [[UIImageView alloc] init];
        return imageView;
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
        return 1;
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
        return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.6);
    }else{
        return CGRectMake(0, 0, FullScreen.size.width-46,20);
    }
}

-(void)clickAddShopCarButtonWithBtn:(UIButton*)btn
{
    
    
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
    if ([info.id isEqualToString:@"105"]) {
        FreeGoTableViewController *vc = [[FreeGoTableViewController alloc]initWithNibName:@"FreeGoTableViewController" bundle:nil];
        //谷歌分析0元购点击进入
        
//         
    [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
    
    //    NSLog(@"info.id: %@",info.id);
    if ([info.id isEqualToString:@"1"]) {
        
        
        return;
    }
    if([info.is_jump isEqualToString:@"y"])
    {
        if (!([info.image_url length]>0||[info.content_txt length]>0)) {
            SafariViewController *vc =[[SafariViewController alloc] initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = info.title;
            vc.urlStr = info.url;
//             
    [self.navigationController pushViewController:vc animated:YES];
        }else{
            AdvertisementViewController *vc =[AdvertisementViewController alloc];
            vc.image_url = info.image_url;
            vc.content_txt = info.content_txt;
            vc.h5UrlStr = info.url;
            vc.myTitle = info.title;
//            [self.navigationController pushViewController:vc animated:true];
//            
    [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

@end
