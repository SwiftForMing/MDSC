//
//  ZJRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZJRecordViewController.h"
#import "WinningRecordTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "WantToSDViewController.h"
#import "ZJRecordListInfo.h"
#import "EditAddressViewController.h"
#import "CollectPrizeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "ThriceViewController.h"
#import "CollectGoodsPrizeViewController.h"
//#import "AcceptWinningThriceCoinTableViewController.h"

#import "GoodsListViewController.h"
#import "GetGoodTableViewController.h"
#import "GetRMBGoodViewController.h"
@interface ZJRecordViewController ()<EditAddressViewControllerDelegate,WantToSDViewControllerDelegate>
//,RefreshListViewControllerDelegate,RefreshRMBListViewControllerDelegate
{
    int pageNum;
    NSMutableArray *dataSourceArray;
}
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation ZJRecordViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_myTableView reloadData];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

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
//    self.title = @"中奖记录";
    pageNum =1;
    dataSourceArray = [NSMutableArray array];
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

-(void)Refresh{
    
    [self setTabelViewRefresh];
}
-(void)RefreshRMB{
    
    [self setTabelViewRefresh];
}

#pragma mark - http

- (void)httpGetRecordList
{
   
    __weak ZJRecordViewController *weakSelf = self;
    
    [HttpHelper getZJRecordWithUserid:[ShareManager shareInstance].userinfo.id
                          pageNum:[NSString stringWithFormat:@"%d",pageNum]
                         limitNum:@"20"
                   is_happybean_goods:_is_happybean_goods
                          success:^(NSDictionary *resultDic){
                              
                              [self hideRefresh];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  [weakSelf handleloadResult:resultDic];
                              }else {
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              
                              [self hideRefresh];
                              [Tool showPromptContent:decretion onView:self.view];
                          }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightWinRecordList"];
    if (resourceArray && resourceArray.count > 0 )
        
    {
        
        if (dataSourceArray.count > 0 && pageNum == 1) {
            [dataSourceArray removeAllObjects];
            
        }
        
        ZJRecordListInfo *previous = nil;
        for (NSDictionary *dic in resourceArray)
        {
            MLog(@"dic%@",dic);
            ZJRecordListInfo *current = [dic objectByClass:[ZJRecordListInfo class]];
            
            // 同一场一元购可能产生两个订单，一元购中奖订单，三赔中奖订单
            BOOL isSameOrder = NO;
            if (previous) {
                NSString *good_fight_id = previous.id;
                NSString *current_fight_id = current.id;
                if ([good_fight_id isEqualToString:current_fight_id?:@""]) {
                    isSameOrder = YES;
                }
            }
            
            // 当前订单是三赔订单，预处理
            if ([current isThriceGoods]) {
                current.thriceOrderID = current.order_id;
                current.thriceOrderStatus = current.order_status;
                current.sanpeiRecordList = current.sanpeiRecordList;
            }
            
            if (isSameOrder) {
                
                // 合并两个中奖订单，即既中了一元购，也中了三赔
                NSString *thriceOrderID = current.order_id;
                NSString *orderStatus = current.order_status;
                previous.thriceOrderID = thriceOrderID;
                previous.thriceOrderStatus = orderStatus;
                previous.sanpeiRecordList = current.sanpeiRecordList;
                previous.get_beans = current.get_beans;
                
            } else {
                
                [dataSourceArray addObject:current];
                previous = current;
            }
        }
        
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
        
        // 中了三赔，也中了一元购, thriceOrderID == nil, 还有数据没有下发自动获取
        if ([previous hasWinThrice] && previous.thriceOrderID.length == 0 && [previous hasWinCrowdfunding]) {
            [self httpGetRecordList];
        }
        
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
            [self noDataUI];
            
        }
    }
    
    [_myTableView reloadData];
}



-(void)noDataUI
{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:(CGRectMake(FullScreen.size.width/2-100, 130, 200, 200))];
    bgImage.image = [UIImage imageNamed:@"bg_zjjl"];
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
    bgImage.tag = 100;
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 162)];
    titlelabel.font = [UIFont systemFontOfSize:22];
    titlelabel.textColor = [UIColor lightGrayColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.tag = 300;
    titlelabel.text =  @"啊呜～宝箱空空";
    
    UIView *goJoin = [[UIView alloc]initWithFrame:(CGRectMake(0, FullScreen.size.height-113, FullScreen.size.width, 49))];
    goJoin.backgroundColor = [UIColor colorFromHexString:@"EFEFF4"];
    goJoin.tag = 200;
    UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(60, 10, self.myTableView.frame.size.width-100, 26))];
    NSString *statusStr = @"你与中奖就差再来一次！";
    
    label.text = statusStr;
    
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    
    [goJoin addSubview:label];
    UIButton *jionBtn = [[UIButton alloc]initWithFrame:(CGRectMake(label.frame.size.width+10, 10, 86, 30))];
    jionBtn.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"立即参与"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [str length])];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"e6332e"] range:NSMakeRange(0, [str length])];
    [jionBtn setAttributedTitle:str forState:UIControlStateNormal];
    jionBtn.layer.masksToBounds = YES;
    jionBtn.layer.cornerRadius = 5;
    
    jionBtn.layer.borderWidth = 2;
    jionBtn.layer.borderColor = [[UIColor colorFromHexString:@"e6332e"] CGColor];
    
    [jionBtn addTarget:self action:@selector(join) forControlEvents:UIControlEventTouchUpInside];
    
    [goJoin addSubview:jionBtn];
    
    [self.myTableView addSubview:bgImage];
    [self.myTableView addSubview:titlelabel];
//    [self.view addSubview:goJoin];
}

-(void)removeBgimage
{
    if ([self.myTableView viewWithTag:100]) {
        [[self.myTableView viewWithTag:100] removeFromSuperview];
        [[self.view viewWithTag:200] removeFromSuperview];
        [[self.myTableView viewWithTag:300] removeFromSuperview];
    }else{
        NSLog(@"没有东西");
    }
    
}
-(void)join
{
    GoodsListViewController *vc = [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
    vc.typeId = @"";
    vc.typeName = @"商品列表";
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}






#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSDButtonAction:(UIButton *)btn
{
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:btn.tag];
    
    if ([info isVirtualGoods]) {
        
        CollectPrizeViewController *vc = [[CollectPrizeViewController alloc] initWithNibName:@"CollectPrizeViewController" bundle:nil];
        vc.orderInfo = info;
//         
    [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if ([info.order_status isEqualToString:@"待发货"])
        {
            
            EditAddressViewController *vc = [[EditAddressViewController alloc]initWithNibName:@"EditAddressViewController" bundle:nil];
            vc.orderInfo = info;
            vc.delegate = self;
            vc.oeder_type = @"oeder";
//             /
    [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            if ([info.is_bask isEqualToString:@"y"]) {
                return;
            }else{
                
                WantToSDViewController *vc = [[WantToSDViewController alloc]initWithNibName:@"WantToSDViewController" bundle:nil];
                vc.detailInfo = info;
                vc.delegate = self;
//                 
    [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}

#pragma mark - UITableViewDelegate

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 160;
    
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    if ([info hasBettingThrice]) {
        height += 112;
    }
    
    return height;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    WinningRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WinningRecordTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WinningRecordTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell reloadWithData:info ofUser:[ShareManager shareInstance].userinfo.id];
    
    cell.winningButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        NSDictionary *data = @{@"status": @"待发货",
                               @"good_period": info.good_period?:@"",
                               @"good_name": info.good_name?:@"", @"win_time": info.lottery_time?:@"",@"user_id": info.win_user_id?:@"",@"AddAward_money": @"0"};
        
        [Tool showWinLottery:data];
        
        return [RACSignal empty];
    }];
    cell.bettingButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if ([info isThriceGoods]) {
            
//            ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
        } else {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
//             
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return [RACSignal empty];
    }];
    
    if ([info hasWinThrice]) {
        [cell.thriceResultView whenTapped:^{
            
//            AcceptWinningThriceCoinTableViewController *vc = [[AcceptWinningThriceCoinTableViewController alloc] initWithNibName:@"AcceptWinningThriceCoinTableViewController" bundle:nil];
//            vc.data = info;
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
        }];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    //谷歌分析用户一般从哪里进入商品详情1

    // 点击一元购区域
    if ([info hasWinCrowdfunding]) {
        
        if ([info isVirtualGoods]) {
            
            GetRMBGoodViewController *vc = [[GetRMBGoodViewController alloc] initWithNibName:@"GetRMBGoodViewController" bundle:nil];
            vc.order_type = @"order";
            vc.orderInfo = info;
//            vc.delegate = self;
//             
    [self.navigationController pushViewController:vc animated:YES];
        } else {
//
            GetGoodTableViewController *vc = [[GetGoodTableViewController alloc] initWithNibName:@"GetGoodTableViewController" bundle:nil];
            vc.order_type = @"order";
            vc.orderInfo = info;
//            vc.delegate = self;
//             
    [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        
        if ([info isThriceGoods]) {
            
//            ThriceViewController *vc = [[ThriceViewController alloc] initWithTableViewStyleGrouped];
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
        } else {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
//             
    [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetRecordList];
        
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf httpGetRecordList];
        
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

#pragma mark -  EditAddressViewControllerDelegate

- (void)editAddressSuccess
{
    [_myTableView.mj_header beginRefreshing];
}

#pragma mark -  WantToSDViewControllerDelegate

- (void)shaidanSuccess
{
    [_myTableView.mj_header beginRefreshing];
}

@end
