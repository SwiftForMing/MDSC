//
//  CouponViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "CouponViewController.h"
#import "HomeTopCell.h"
#import "CouponModel.h"
#import "HomeGoodModel.h"
#import "GoodDetailViewController.h"
#import "GetCouponViewController.h"
#import "EntBuyCouPonCell.h"
#import "SharaCouponViewController.h"
@interface CouponViewController ()<UITextViewDelegate>{
    NSMutableArray *dataArray;
    NSMutableArray *goodsArray;
    int page;
    NSString *searchKey;
}
@property (nonatomic, strong) UITextView *searchTextView;

@end

@implementation CouponViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.tableView.contentOffset = CGPointMake(0, -20);
}


- (void)viewDidLoad {
    [super viewDidLoad];
//     self.navigationController.navigationBarHidden = YES;
//    [self hidenLeftBarButton];
    self.title = @"优惠券";
    dataArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    page = 1;
    searchKey = @"";
    self.view.backgroundColor = [UIColor blueColor];
    [self setHeaderView];
    self.tableView.backgroundColor = [UIColor whiteColor];
     [self setTabelViewRefresh];
}

//优惠券码输入框
-(void)setHeaderView{
    UIView *headerView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, 39))];
    
    self.searchTextView = [[UITextView alloc]initWithFrame:(CGRectMake(18, 10, ScreenWidth-105, 28))];
    self.searchTextView.layer.masksToBounds = YES;
    self.searchTextView.layer.cornerRadius = 14;
    self.searchTextView.layer.borderWidth = 1;
    self.searchTextView.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.searchTextView.tintColor = [UIColor whiteColor];
    self.searchTextView.backgroundColor = [UIColor whiteColor];
    _searchTextView.delegate = self;
    self.searchTextView.font = [UIFont systemFontOfSize:14];
    self.searchTextView.textColor = [UIColor colorFromHexString:@"A0AABB"];
    self.searchTextView.text = @"请输入优惠券码";
    headerView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [headerView addSubview:_searchTextView];
    
    UIButton *getCouponBtn = [[UIButton alloc]initWithFrame:(CGRectMake(ScreenWidth-70, 10, 60, 28))];
//    getCouponBtn.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
    [getCouponBtn setBackgroundImage:[UIImage imageNamed:@"nav"] forState:0];
    [getCouponBtn setTitle:@"兑换" forState:0];
    getCouponBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [getCouponBtn setTintColor:[UIColor whiteColor]];
    
    [getCouponBtn addTarget:self action:@selector(getCoupon) forControlEvents:UIControlEventTouchUpInside];
    getCouponBtn.layer.masksToBounds = YES;
    getCouponBtn.layer.cornerRadius = 14;
    [headerView addSubview:getCouponBtn];
//    [self.view addSubview:headerView];
    self.tableView.tableHeaderView = headerView;
}
#pragma mark兑换优惠券
-(void)getCoupon{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    MLog(@"我就看看进来没有？");
    [self.searchTextView resignFirstResponder];
     __weak CouponViewController *weakSelf = self;
    [HttpHelper getAddCouponDataWithUserID:[ShareManager shareInstance].userinfo.id Coupons_secret:searchKey success:^(NSDictionary *resultDic) {
        
        MLog(@"resultDic%@",resultDic[@"desc"]);
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            
            [weakSelf setTabelViewRefresh];
        }else{
             [Tool showPromptContent:resultDic[@"desc"] onView:weakSelf.view];
        }
        
    } fail:^(NSString *description) {
         [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
        
    }];
}


- (void)textViewDidChange:(UITextView *)textView{
    
    searchKey = textView.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    self.searchTextView.text = @"";
    self.searchTextView.textColor = [UIColor blackColor];
    return YES;
}
#pragma mark 获取历表数据
-(void)getListData{
    __weak CouponViewController *weakSelf = self;
    
    if (![Tool islogin]) {
        [dataArray removeAllObjects];
        [goodsArray removeAllObjects];
        [self.tableView reloadData];
        [weakSelf hideRefresh];
        return;
    }
    
    [HttpHelper getCouponListDataWithUserID:[ShareManager shareInstance].userinfo.id PageNum:[NSString stringWithFormat:@"%d",page] limitNum:@"20" type:@"a" success:^(NSDictionary *resultDic) {
        [weakSelf hideRefresh];
        MLog(@"getCouponListDataWithUserID%@",resultDic);
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            
            [weakSelf handleloadListResult:resultDic];
        }
        
    } fail:^(NSString *description) {
        [weakSelf hideRefresh];
        MLog(@"getCouponListDataWithUserID%@",description);
        [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
    }];
}

- (void)handleloadListResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    NSArray *goodArray = [dic objectForKey:@"couponsList"];
    if (goodArray && goodArray.count > 0) {
        if (dataArray.count > 0&&page==1) {
            [dataArray removeAllObjects];
            [goodsArray removeAllObjects];
        }
        for (NSDictionary *dic in goodArray)
        {
            MLog(@"dic%@",dic[@"valid_date"]);
            CouponModel *info = [dic objectByClass:[CouponModel class]];
            [dataArray addObject:info];
//            MLog(@"dic%@",info.id);
            HomeGoodModel *model = [dic objectByClass:[HomeGoodModel class]];
            model.id = info.good_id;
//            model.valid_date = dic[@"valid_date"];
            [goodsArray addObject:model];
        }
    }
    
    if (goodArray.count < 20) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    page++;
    
    //刷新
    [self.tableView reloadData];
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return dataArray.count;
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeTopCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTopCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTopCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //设点点击选择的颜色(无)
    HomeGoodModel *model = [goodsArray objectAtIndex:indexPath.row];
    cell.couPonModel = model;
   
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextView resignFirstResponder];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    HomeGoodModel *model = goodsArray[indexPath.row];
    GoodDetailViewController *vc = [[GoodDetailViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = model;
//     
    [self.navigationController pushViewController:vc animated:YES];
    
//    SharaCouponViewController *vc = [[SharaCouponViewController alloc]initWithTableViewStyle:0];
//    vc.couponModel =[dataArray objectAtIndex:indexPath.row];
//     
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 135;
}

- (void)setTabelViewRefresh
{
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
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


@end
