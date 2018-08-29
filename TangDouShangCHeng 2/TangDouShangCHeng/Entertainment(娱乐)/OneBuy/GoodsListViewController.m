//
//  GoodsListViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsListInfo.h"
#import "SelectGoodsNumViewController.h"
#import "QingDanViewController.h"

@interface GoodsListViewController ()
{
    NSMutableArray *dataSourceArray;
    UIButton *rightButton;
}

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.accessibilityElementsHidden = YES;
    [self initVariable];
    [self leftNavigationItem];
//    [self rightItemView];
//    [self setRightBarButtonItem:@"购物车"];
    [self setTabelViewRefresh];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    
    if (_typeName) {
        self.title = _typeName;
    }else{
        self.title = @"商品列表";
    }
    dataSourceArray = [NSMutableArray array];
}
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
    
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

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,100, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, rightItemView.frame.size.height)];
    rightButton.contentMode = UIViewContentModeRight;
    [rightButton setTitle:@"购物车" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,0)];
    [rightButton addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:rightButton];
    
    rightButton.hidden = YES;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)rightBarButtonItemAction
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

#pragma mark - http

- (void)httpGoodsInfoList
{
   
    __weak GoodsListViewController *weakSelf = self;
    [HttpHelper getGoodsListOfTypeWithGoodsTypeIde:_typeId
                                  success:^(NSDictionary *resultDic){
                                      [self hideRefresh];
                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                          [weakSelf handleloadResult:resultDic];
                                      }else
                                      {
                                          [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                      }
                                  }fail:^(NSString *decretion){
                                      [self hideRefresh];
                                      [Tool showPromptContent:decretion onView:self.view];
                                  }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsTypeList"];
    
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            [dataSourceArray addObject:info];
        }
        rightButton.hidden = NO;
    }
    else
    {
//        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    
    self.title = [NSString stringWithFormat:@"%@ (%lu)",_typeName,(unsigned long)dataSourceArray.count];
    
    [_myTableView reloadData];
    
}

- (void)httpSearchInfoList
{
   
    __weak GoodsListViewController *weakSelf = self;
    [HttpHelper searchGoodsWithSearchKey:_typeName
                             success:^(NSDictionary *resultDic){
                                 [self hideRefresh];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadSearchResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                             }fail:^(NSString *decretion){
                                 [self hideRefresh];
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}

- (void)handleloadSearchResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsSearchList"];
    
    if (dataSourceArray.count > 0) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            [dataSourceArray addObject:info];
        }
    }
    else
    {
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    
    
    [_myTableView reloadData];
    
}



//- (void)handleloadAddGoodsToShopCartResult:(NSDictionary *)resultDic buyNum:(NSString *)buyNum
//{
//    [Tool getUserInfo];
//    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//
//}


#pragma mark - action

- (void)clickRightItemAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    NSString *goodIds = nil;
    NSString *buyNums = nil;
    for (GoodsListInfo *info in dataSourceArray) {
        if (goodIds) {
            goodIds = [NSString stringWithFormat:@"%@,%@",goodIds,info.good_id];
        }else{
            goodIds = info.good_id;
        }
        if (buyNums) {
            buyNums = [NSString stringWithFormat:@"%@,%@",buyNums,@"1"];
        }else{
            buyNums = @"1";
        }
    }
//    [self httpAddGoodsToShopCartWithGoodsID:goodIds buyNum:buyNums];
}

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickAddShopCart:(UIButton *)btn
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    GoodsListInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    [self httpAddGoodsToShopCartWithGoodsID:info.good_id buyNum:@"1"];
}

- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
    __weak GoodsListViewController *weakSelf = self;
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
//    NSString *status = resultDic[@"desc"];
//    if ([status isEqualToString:@"成功"]) {
//        self.tabBarController.tabBar.items[2].badgeValue = [NSString stringWithFormat:@"%d",bagde+1];
//    }
//    bagde += 1;
    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
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
    return 102;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.processView.layer.masksToBounds =YES;
    cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
    
//    cell.addButton.layer.masksToBounds =YES;
//    cell.addButton.layer.cornerRadius = 3;
//    cell.addButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
//    cell.addButton.layer.borderWidth = 1.0f;
    cell.addButton.tag = indexPath.row;
    [cell.addButton addTarget:self action:@selector(clickAddShopCart:) forControlEvents:UIControlEventTouchUpInside];
    
    GoodsListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = info.good_name;
    cell.allNum.text = [NSString stringWithFormat:@"总需 %ld",(long)info.need_people];
    CGSize size = [cell.allNum sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
    cell.allNeedWidth.constant = size.width;
    cell.needNum.text = [NSString stringWithFormat:@"剩余 %ld",(long)(info.need_people - info.now_people)];
    
    cell.processLabelWidth.constant = (FullScreen.size.width - 146)*([info.progress doubleValue]/100.0);
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
    cell.titleLabel.text = info.good_name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GoodsListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
    vc.goodId = info.id;
//     
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.isSearch) {
            [weakSelf httpSearchInfoList];
        }else{
            [weakSelf httpGoodsInfoList];
        }
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
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



@end
