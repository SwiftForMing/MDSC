//
//  MallCollectionViewController.m
//  DuoBao
//
//  Created by clove on 5/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "MallCollectionViewController.h"
#import "MallCollectionViewCell.h"
#import "GoodsFightModel.h"
#import "YYKitMacro.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "SelectGoodsNumViewController.h"
#import "PaySuccessTableViewController.h"
#import "GoodsDetailInfoViewController.h"
#import "MallCollectionViewFlowLayout.h"
#import "ReciverAddressViewController.h"
#import "MyOrderListViewController.h"
#import "ZJRecordViewController.h"
@interface MallCollectionViewController ()<SelectGoodsNumViewControllerDelegate>
@property (nonatomic, strong) NSArray *modelList;

@end

@implementation MallCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self setTabelViewRefresh];
     self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"米豆商城";
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MallCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
//    MallCollectionViewFlowLayout *layout = [[MallCollectionViewFlowLayout alloc] init];
//    layout.invalidateFlowLayoutDelegateMetrics = YES;
//    
//    //设置大小
//    layout.itemSize = CGSizeMake(ScreenWidth/2-0.5, 206*UIAdapteRate);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;    
//    layout.minimumInteritemSpacing = ScreenWidth - (ScreenWidth/2*2 -1);
//    layout.minimumLineSpacing = 1;
//    layout.sectionInset = UIEdgeInsetsZero;
//    
//    self.collectionView.collectionViewLayout = layout;
    
    [self rightNavigationItem];
    [self leftNavigationItem];

    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)rightNavigationItem
{
    UIControl *rightItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightItemControl addTarget:self action:@selector(clickrightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 80, 18)];
    title.text = @"兑换记录";
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentRight;
    [rightItemControl addSubview:title];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemControl];
}

- (void)clickrightItemAction:(id)sender
{
    ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
    vc.is_happybean_goods = @"1";
    vc.title = @"兑换记录";
//     
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UICollectionView *tableView = self.collectionView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 1;
        [weakSelf request];
//        [weakSelf getListData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf getListData];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([self.collectionView.mj_footer isRefreshing])
    {
        [self.collectionView.mj_footer endRefreshing];
    }
    if([self.collectionView.mj_header isRefreshing])
    {
        [self.collectionView.mj_header endRefreshing];
    }
}



- (void)request
{

    @weakify(self);
    [HttpHelper getQuanBeanDateWithPageNum:@"1" limitNum:@"100" success:^(NSDictionary *resultDic) {
         @strongify(self);
        NSLog(@"resultDic %@",resultDic);
        [self hideRefresh];
        NSDictionary *data = [resultDic objectForKey:@"data"];
        NSArray *array = [data objectForKey:@"beanGoodsList"];
        
        NSMutableArray *multArray = [NSMutableArray array];
        for (NSDictionary *dictionary in array) {
            GoodsFightModel *model = [GoodsFightModel createWithDictionary:dictionary];
            [multArray addObject:model];
        }
        self.modelList = multArray;
        [self.collectionView reloadData];
    } fail:^(NSString *description) {
        [self hideRefresh];
        [Tool showPromptContent:@"网络请求失败"];
    }];
   
}

- (void)purchaseGoods:(GoodsFightModel *)model
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    int remainerThriceCoin = userInfo.user_money;
    int neededThriceCoin =  [model remainderCoin];
    MLog(@"remainerThriceCoin%d,neededThriceCoin%d",remainerThriceCoin,neededThriceCoin);
    if (neededThriceCoin > remainerThriceCoin) {
        NSString *message = [NSString stringWithFormat:@"小米余额不足，购买总需%d小米～", neededThriceCoin];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        return;
    }


    [HttpHelper purchaseWithThriceCoin:model.id goodsID:model.good_id thriceCoin:[model.good_single_price intValue] success:^(NSDictionary *data) {
        MLog(@"NSDictionary>>>>>%@",data);
        if ([data[@"status"] isEqualToString:@"0"]) {
            
            [Tool showPromptContent: @"兑换成功" onView:self.view];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
//
        }else{
            
            [Tool showPromptContent: data[@"status"] onView:self.view];
            
        }
        
    } failure:^(NSString *description) {
         MLog(@"failure>>>>>%@",description);
        [Tool showPromptContent:@"兑换失败" onView:self.view];
    }];
}

-(void)delayMethod{
    ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
    vc.is_happybean_goods = @"1";
    vc.title = @"兑换记录";
//     
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - SelectGoodsNumViewControllerDelegate

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
                               [self.navigationController pushViewController:vc animated:YES];

                           }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MLog(@"_modelList.count%lu",(unsigned long)_modelList.count);
    return _modelList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    GoodsFightModel *model = [_modelList objectAtIndex:indexPath.row];
    
    cell.joinButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [self purchaseGoods:model];
        return [RACSignal empty];
    }];
    
    [cell reloadWithObject:model];
    
    
    for (UIView *view in cell.contentView.subviews) {
        if (view.width < 1 || view.height < 1) {
            [view removeFromSuperview];
        }
    }
    
    [cell.contentView addSingleBorder:UIViewBorderDirectBottom color:[UIColor defaultTableViewSeparationColor] width:0.5];
    if ((indexPath.row+1) %2 == 1) {
        [cell.contentView addSingleBorder:UIViewBorderDirectRight color:[UIColor defaultTableViewSeparationColor] width:0.5];
    }
    
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width/2, 206*UIAdapteRate);
}

//定义每个UICollectionView 的 margin
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0f;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    GoodsFightModel *model = [_modelList objectAtIndex:indexPath.row];
//    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc] initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
//    vc.goodId = model.goodsModel.good_id;
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
}


@end
