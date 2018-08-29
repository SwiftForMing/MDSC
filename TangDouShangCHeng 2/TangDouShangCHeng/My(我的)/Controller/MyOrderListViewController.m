//
//  MyOrderListViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/19.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "MyOrderListViewController.h"
#import "OrderModel.h"
#import "OrderCell.h"
#import "OrderDetialViewController.h"

#import "NewHomeViewController.h"
@interface MyOrderListViewController (){

    int page;
    NSMutableArray *goodsArray;
}

@end

@implementation MyOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    goodsArray = [NSMutableArray array];
    self.title = @"我的订单";
    [self setRightBarButtonItem:@"客服"];
//    [self setLeftBarButtonItemArrow];
    [self setTabelViewRefresh];
}

- (void)rightBarButtonItemAction:(id)sender
{
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    userID = userID ? userID : @"";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"iOS %@", version];
    NSString *alias = [ShareManager shareInstance].userinfo.nick_name;
    NSString *telephone = userInfo.user_tel ?:@"";
    //                NSString *mqID = [userID stringByAppendingFormat:@"_%@", alias];
    MQChatViewConfig *chatViewConfig = [MQChatViewConfig sharedConfig];
    
    MQChatViewController *chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    [chatViewConfig setEnableOutgoingAvatar:false];
    [chatViewConfig setEnableRoundAvatar:YES];
    chatViewConfig.navTitleColor = [UIColor whiteColor];
    chatViewConfig.navBarTintColor = [UIColor whiteColor];
    [chatViewConfig setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
//    chatViewController.title = @"客服";
//    [chatViewConfig setNavTitleText:@"客服"];
    [chatViewConfig setCustomizedId:userID];
    [chatViewConfig setEnableEvaluationButton:NO];
//    [chatViewConfig setAgentName:@"客服"];
    [chatViewConfig setClientInfo:@{@"name":alias, @"version": versionString, @"identify": userID, @"telephone": telephone}];
    [chatViewConfig setUpdateClientInfoUseOverride:YES];
    [chatViewConfig setRecordMode:MQRecordModeDuckOther];
    [chatViewConfig setPlayMode:MQPlayModeMixWithOther];
    [self.navigationController pushViewController:chatViewController animated:YES];
//    
//    [self.navigationController pushViewController:chatViewController animated:YES transition:magicMove];

    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    chatViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)clickLeftControlAction:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setLeftBarButtonItemArrow
{
    MLog(@"回来回来");
    self.navigationItem.hidesBackButton = YES;
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(leftBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}
- (void)leftBarButtonItemAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)getData{
    
    __weak MyOrderListViewController *weakSelf = self;
    [HttpHelper getMyorderLisetWithUserID:[ShareManager shareInstance].userinfo.id type:@"全部" pageNum:[NSString stringWithFormat:@"%d",page] limitNum:@"20"
                          success:^(NSDictionary *resultDic){
                              MLog(@"resultDic%@",resultDic);
                              [weakSelf hideRefresh];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  
                                  [weakSelf handleloadResult:resultDic];
                              }
                          }fail:^(NSString *decretion){
                              [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                          }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    
    NSArray *goodArray = [dic objectForKey:@"orderList"];
    if (goodArray && goodArray.count > 0) {
        if (goodsArray.count > 0&&page == 1) {
            [goodsArray removeAllObjects];
        }
        for (NSDictionary *dic in goodArray)
        {
            MLog(@"dic%@",dic);
            
            OrderModel *info = [dic objectByClass:[OrderModel class]];
            [goodsArray addObject:info];
        }
    }
    
    if (goodArray.count < 100) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    page++;
        [self.tableView reloadData];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return goodsArray.count;
   
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
            OrderCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            //设点点击选择的颜色(无)
            OrderModel *model = [goodsArray objectAtIndex:indexPath.row];
            cell.orderModel = model;
            return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 150;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetialViewController *vc = [[OrderDetialViewController alloc]initWithTableViewStyle:1];
    vc.orderModel = [goodsArray objectAtIndex:indexPath.row];
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
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
        
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
