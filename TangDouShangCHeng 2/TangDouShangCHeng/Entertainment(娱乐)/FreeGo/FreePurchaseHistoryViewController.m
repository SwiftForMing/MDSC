//
//  WQJXViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "FreePurchaseHistoryViewController.h"
#import "WQJXListTableViewCell.h"
#import "UserViewController.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsDetailInfo.h"
#import "WQJXDJSTableViewCell.h"
#import "FreePurchaseHistoryTableViewCell.h"

@interface FreePurchaseHistoryViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNum;
}

@end

@implementation FreePurchaseHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
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
    self.title = @"零元购往期揭晓";
    
    self.myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 0.01f)];
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.myTableView.bounds.size.width, 8)];
    
    _seeButton.layer.masksToBounds =YES;
    _seeButton.layer.cornerRadius = _seeButton.frame.size.height/2;
    dataSourceArray = [NSMutableArray array];
    pageNum = 1;
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


#pragma mark - http

- (void)httpGetSourceData
{
//    HttpHelper *helper = [HttpHelper helper];
    __weak typeof(self) weakSelf = self;
    [HttpHelper getOldDuoBaoDataWithGoodsId:_goodId
                                pageNum:[NSString stringWithFormat:@"%d",pageNum]
                               limitNum:@"30"
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
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsFightHistoryList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            GoodsDetailInfo *info = [dic objectByClass:[GoodsDetailInfo class]];
            [dataSourceArray addObject:info];
        }
        
        if (resourceArray.count < 30) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    [_myTableView reloadData];
}


- (void)httpQueryPeriod
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"查询中...";
//    HttpHelper *helper = [HttpHelper helper];
    __weak typeof(self) weakSelf = self;
    [HttpHelper queryPeriodWithGoodsId:_goodId
                       good_period:_textFiled.text
                           success:^(NSDictionary *resultDic){
                               [HUD hide:YES];
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                   [weakSelf handleLoadQueryResult:resultDic];
                               }else
                               {
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:decretion onView:self.view];
                           }];
}


- (void)handleLoadQueryResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    if (dic) {
        NSString *goodId = [dic objectForKey:@"goods_fight_id"];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = goodId;
//         
    [self.navigationController pushViewController:vc animated:YES];
    }else{
        [Tool showPromptContent:@"查无此期夺宝" onView:self.view];
    }
    
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    UIImageView *imageview = (UIImageView *)tap.self.view;
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:imageview.tag];
    NSString *userIdStr = info.win_user_id;
    
    if ([userIdStr isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        return;
    }
    
    UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    vc.userId = userIdStr;
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)clicSeeButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    if (_textFiled.text.length < 1) {
        [Tool showPromptContent:@"请输入要查询的期数" onView:self.view];
        return;
    }
    [self httpQueryPeriod];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSourceArray.count;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
    
    if([info.status isEqualToString:@"倒计时"])
    {
        return 44;
    }else{
        return 123;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 12;
    }
    return 8;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
    
    if([info.status isEqualToString:@"倒计时"])
    {
        WQJXDJSTableViewCell  *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"WQJXDJSTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WQJXDJSTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numLabel.text = [NSString stringWithFormat:@"第%@期",info.good_period];
        CGSize size = [cell.numLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        cell.numLabelWidth.constant = size.width;
        return cell;
    }else{
        FreePurchaseHistoryTableViewCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"FreePurchaseHistoryTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FreePurchaseHistoryTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell reloadWithData:info];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
    
    if(![info.status isEqualToString:@"倒计时"])
    {
        GoodsDetailInfo *info = [dataSourceArray objectAtIndex:indexPath.section];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
//         
    [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetSourceData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpGetSourceData];
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


@end
