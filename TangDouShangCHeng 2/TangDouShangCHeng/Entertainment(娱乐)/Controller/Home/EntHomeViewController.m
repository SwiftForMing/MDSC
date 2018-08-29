//
//  EntHomeViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "EntHomeViewController.h"
#import "GoodsListCollectionViewCell.h"
#import "EntBuyViewController.h"
#import "CollectionHeaderView.h"

#import "BannerTableViewCell.h"
#import "HomeOddsCell.h"
#import "HomeTopCell.h"
#import "BannerInfo.h"
#import "HomeGoodModel.h"
#import "GetCouponViewController.h"
#import "GoodDetailViewController.h"

#import "CycleScrollView.h"
#import "GoodsListInfo.h"
#import "SelectGoodsNumViewController.h"
#import "EntHomeCell.h"
#import "InviteViewController.h"
#import "HomePageViewController.h"
#import "SafariViewController.h"
#import "AdvertisementViewController.h"
#import "MallCollectionViewController.h"
//#import "LuckyViewController.h"
#import "FreeGoTableViewController.h"
@interface EntHomeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,SelectGoodsNumViewControllerDelegate>{
    int page;
    NSMutableArray *collGoodsArray;
    
    NSMutableArray *bannerArray;
    BOOL isBannerTwo;
    NSMutableArray *goodsArray;
    NSMutableArray *discountArray;
    NSMutableArray *goodsDataSourceArray;
    int pageNum;
    
    GoodsDetailInfo *_selectedGoodsInfo;
    GoodsListInfo *_selectedGoodsListInfo;
}

@property (nonatomic, copy) NSString *bannerListFlag;
@property (nonatomic, strong) CollectionHeaderView *collectHeader;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;
@property(nonatomic,strong)UICollectionView *collectionview;
@end

@implementation EntHomeViewController

-(UICollectionView *)collectionview{
    if (!_collectionview) {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
        _flowlayout.minimumLineSpacing = 10;
        _flowlayout.minimumInteritemSpacing = 10;
        _flowlayout.headerReferenceSize=CGSizeMake(ScreenWidth, 170*UIAdapteRate); //设置collectionView头视图的大小
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, FullScreen.size.width, FullScreen.size.height-64) collectionViewLayout:_flowlayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        
        _collectionview.backgroundColor = [UIColor whiteColor];
    }
    return _collectionview;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ShareManager shareInstance].isEnterMK = NO;
//  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    MLog(@"[ShareManager shareInstance].isEnterMK%id",[ShareManager shareInstance].isEnterMK);
}


#pragma mark - UINavigationControllerDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    collGoodsArray = [NSMutableArray array];
    bannerArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    discountArray = [NSMutableArray array];
    goodsDataSourceArray = [NSMutableArray array];

    pageNum = 1;
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionview];
    
     [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"firstHeader"];
    [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //注册Cell
    [self.collectionview registerNib:[UINib nibWithNibName:@"EntHomeCell" bundle:nil]  forCellWithReuseIdentifier:@"EntHomeCell"];

    self.title = @"娱乐城";

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(notificationFunction)
                                                name:kUpdateUserNotification
                                              object:nil];
    [self setTabelViewRefresh];
   
}

-(void)notificationFunction{
     [self setTabelViewRefresh];
}


- (void)httpShowData
{
    __weak EntHomeViewController *weakSelf = self;
    [HttpHelper getEntHttpWithUrlStr:URL_GetHomePageData
                             success:^(NSDictionary *resultDic){
                                 [weakSelf hideRefresh];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadResult:resultDic];
//                                     MLog(@"resultDic%@",resultDic);
                                 }
                             }fail:^(NSString *decretion){
                                 [weakSelf hideRefresh];
                                 [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                             }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
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
    
    [_collectionview reloadData];
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [_radioCell.bannerView reloadData];
//    });
}

#pragma mark 获取历表数据
- (void)httpGetGoodsList
{
    NSString *typeStr = @"now_people";
    NSString *descStr = @"desc";
    __weak EntHomeViewController *weakSelf = self;
    [HttpHelper getGoodsListWithOrder_by_name:typeStr
                            order_by_rule:descStr
                                  pageNum:[NSString stringWithFormat:@"%d",pageNum]
                                 limitNum:@"100"
                                  success:^(NSDictionary *resultDic){
                                      [weakSelf hideRefresh];
                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                          [weakSelf handleGetGoodsListLoadResult:resultDic];
                                      }
                                      //                                    else
                                      //                                    {
                                      //                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                      //                                    }
                                  }fail:^(NSString *decretion){
                                      [weakSelf hideRefresh];
                                      [Tool showPromptContent:decretion onView:weakSelf.view];
                                  }];

}

- (void)handleGetGoodsListLoadResult:(NSDictionary *)resultDic
{
    if (goodsDataSourceArray.count > 0 && pageNum == 1) {
        [goodsDataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
//            MLog(@"一元购%@",dic);
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            [goodsDataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 100) {
            [self.collectionview.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.collectionview.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }
    
    [self.collectionview reloadData];
   
}

- (void)setTabelViewRefresh
{
    __unsafe_unretained UICollectionView *collectionView = self.collectionview;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpShowData];
//        [weakSelf httpGetGoodsList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    collectionView.mj_header.automaticallyChangeAlpha = YES;
    [collectionView.mj_header beginRefreshing];
    // 上拉刷新
//    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
////        [weakSelf httpGetGoodsList];
//
//    }];
//    collectionView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
//    
    if([self.collectionview.mj_footer isRefreshing])
    {
        [self.collectionview.mj_footer endRefreshing];
    }
    if([self.collectionview.mj_header isRefreshing])
    {
        [self.collectionview.mj_header endRefreshing];
    }
}


#pragma mark -

- (void)bannerListDidChange:(NSArray *)array
{
    NSString *str = @"";
    for (BannerInfo *object in array) {
        NSString *identify = object.id;
//        MLog(@"identify：%@",identify);
        if (identify.length > 0) {
            str = [str stringByAppendingString:identify];
        }
    }
    
    if (_bannerListFlag == nil || [_bannerListFlag isEqualToString:str] == NO) {
        _bannerListFlag = str;
//        MLog(@"str：%@",str);
        [_collectHeader.bannerView reloadData];
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
        CollectionHeaderView *headerView = objc_getAssociatedObject(cycleScrollView, "headerView");
        if (isBannerTwo) {
            headerView.pageControler.numberOfPages = 2;
        }else{
            headerView.pageControler.numberOfPages = bannerArray.count;
        }
        
        return  bannerArray.count;
        
    }else{
        return 1;
    }
}

- (void)cycleScrollView:(CycleScrollView *)cycleScrollView didScrollView:(int)index
{
    if (cycleScrollView.tag == 100) {
        
        CollectionHeaderView *headerView = objc_getAssociatedObject(cycleScrollView, "headerView");
        if (isBannerTwo)
        {
            headerView.pageControler.currentPage = index%2;
            
        }else{
            headerView.pageControler.currentPage = index;
            
        }
    }
    
}

- (CGRect)frameOfCycleScrollView:(CycleScrollView *)cycleScrollView
{
    if (cycleScrollView.tag == 100) {
        return CGRectMake(0, 0, FullScreen.size.width,FullScreen.size.width*0.45);
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
     CollectionHeaderView *headerView = objc_getAssociatedObject(tap, "headerView");
    
    if (headerView.pageControler.currentPage >= bannerArray.count ) {
        return;
    }
    BannerInfo *info = [bannerArray objectAtIndex:headerView.pageControler.currentPage];
    
    MLog(@"info.id: %@",info.url);
    // 跳转邀请好友
    if ([info.id isEqualToString:@"109"]) {
        InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
        // 邀请好友
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([info.id isEqualToString:@"105"]) {
        FreeGoTableViewController *vc = [[FreeGoTableViewController alloc]initWithNibName:@"FreeGoTableViewController" bundle:nil];
        //谷歌分析0元购点击进入
        
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
         [self.navigationController pushViewController:vc animated:YES];
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
//           
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
             [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}


#pragma mark - collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *showArr = [[ShareManager shareInstance].userinfo.am_show componentsSeparatedByString:@","];
    return showArr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}

#pragma mark 返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"firstHeader" forIndexPath:indexPath];
        //添加头视图的内容
        CollectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"CollectionHeaderView" owner:nil options:nil] firstObject];
        headerView.width = ScreenWidth;
        headerView.height = 170 * UIAdapteRate;
        headerView.bannerView.delegate = self;
        headerView.bannerView.dataSource = self;
        headerView.bannerView.autoScrollAble = YES;
        headerView.bannerView.tag = 100;
        headerView.bannerView.direction = CycleDirectionLandscape;
        objc_setAssociatedObject(headerView.bannerView, "headerView", headerView, OBJC_ASSOCIATION_ASSIGN);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
        tap.numberOfTapsRequired = 1;
        objc_setAssociatedObject(tap, "headerView", headerView, OBJC_ASSOCIATION_ASSIGN);
        [headerView.bannerView addGestureRecognizer:tap];

        //头视图添加view
        [header addSubview:headerView];
        _collectHeader = headerView;
        return header;
            
    }
        return nil;
        
}




- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EntHomeCell";
    
    EntHomeCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"EntHomeCell" owner:self options:nil]  firstObject];
    }
    cell.backgroundColor = [UIColor whiteColor];
    NSArray *showArr = [[ShareManager shareInstance].userinfo.am_show componentsSeparatedByString:@","];
    
    int tag = [showArr[indexPath.row] intValue];
    cell.iconImageView.image = [self getImageWithTag:tag];
  
    return cell;
    
}

-(UIImage *)getImageWithTag:(int)tag{
    UIImage *img = [UIImage imageNamed:@""];
    if (tag == 1) {
        img = [UIImage imageNamed:@"mk"];
    }
    if (tag == 2) {
        img = [UIImage imageNamed:@"qdb"];
    }
    if (tag == 3) {
        img = [UIImage imageNamed:@"ylc_icon"];
    }
    if (tag == 4) {
        img = [UIImage imageNamed:@"qdsc"];
    }
    return img;
}

#pragma mark - 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/2,170);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(void)getpushWithTag:(int)tag{
    if (tag == 1) {
        [self.tabBarController.tabBar setHidden:YES];
        [ShareManager shareInstance].isEnterMK = YES;
        EntTabBarViewController * vc = [[EntTabBarViewController alloc] init];
//        
//        [self.navigationController pushViewController:entBarVC animated:YES transition:magicMove];
         [self.navigationController pushViewController:vc animated:YES];
    }
    if (tag == 2) {
        [self.tabBarController.tabBar setHidden:YES];
        [ShareManager shareInstance].isEnterMK = NO;
        EntTabBarViewController * vc = [[EntTabBarViewController alloc] init];
//        
//        [self.navigationController pushViewController:entBarVC animated:YES transition:magicMove];
         [self.navigationController pushViewController:vc animated:YES];
    }
    if (tag == 3) {
        [self.tabBarController.tabBar setHidden:YES];
        RotaryViewController * vc = [[RotaryViewController alloc]initWithNibName:@"RotaryViewController" bundle:nil];
//        
//        [self.navigationController pushViewController:rotVC animated:YES transition:magicMove];
         [self.navigationController pushViewController:vc animated:YES];
    }
    if (tag == 4) {
        MallCollectionViewController *vc = [[MallCollectionViewController alloc] initWithNibName:@"MallCollectionViewController" bundle:nil];
//         
//         [self.navigationController pushViewController:vc animated:YES transition:magicMove];
         [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *showArr = [[ShareManager shareInstance].userinfo.am_show componentsSeparatedByString:@","];
    int tag = [showArr[indexPath.row] intValue];
    [self getpushWithTag:tag];
    
}





@end
