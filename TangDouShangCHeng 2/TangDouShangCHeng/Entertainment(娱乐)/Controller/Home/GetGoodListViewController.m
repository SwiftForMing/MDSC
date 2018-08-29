//
//  GetGoodListViewController.m
//  DuoBao
//
//  Created by 黎应明 on 2017/7/26.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "GetGoodListViewController.h"
#import "getGoodListCell.h"
#import "ZJRecordListInfo.h"
#import "GetGoodTableViewController.h"
#import "GetRMBGoodViewController.h"
#import "GoodsDetailInfoViewController.h"
//#import "ThriceViewController.h"
#import "CollectPrizeViewController.h"
#import "CollectGoodsPrizeViewController.h"
#import "UConstants.h"
#import "UIViewExt.h"
#import "TransferViewController.h"
@interface GetGoodListViewController()<UITableViewDelegate,UITableViewDataSource>{
    int pageNum;
    NSMutableArray *dataSourceArray;
}
@property(strong,nonatomic) UITableView *tableView;

@property (nonatomic,strong) UIButton *selectAllBtn;//全选按钮

@property (nonatomic,strong) UIButton *jieSuanBtn;//结算按钮
@property (nonatomic,strong) UILabel *totalMoneyLab;//总金额

@property(nonatomic,assign) float allPrice;
@property(nonatomic,copy) NSString *ids;

@end

@implementation GetGoodListViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
    [self setTabelViewRefresh];
    self.navigationController.navigationBar.hidden = NO;
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转让商品";
    pageNum =1;
    dataSourceArray = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 175;
    [self setTabelViewRefresh];
    
    
    CGFloat y = ScreenHeight == 812.0 ? 55:0;
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-48-y, ScreenWidth, 50)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    
//    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.selectAllBtn.frame = CGRectMake(10,15, 60, 20);
//    [self.selectAllBtn setImage:[UIImage imageNamed:@"check_n"] forState:UIControlStateNormal];
//    [self.selectAllBtn setImage:[UIImage imageNamed:@"check_p"] forState:UIControlStateSelected];
//    self.selectAllBtn.selected = YES;
//    [self.selectAllBtn addTarget:self action:@selector(selectAllaction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
//    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.selectAllBtn.titleLabel.font = SYSTEMFONT(12.0);
//    self.selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    [payView addSubview:self.selectAllBtn];
    
    
    
    self.totalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20+10, 15, kScreenWidth-20-30-GetWidth(184),20)];
    
    self.totalMoneyLab.textAlignment = NSTextAlignmentLeft;
    self.totalMoneyLab.font = SYSTEMFONT(13.0);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldRMB",(long)self.allPrice]];
    [str addAttribute:NSFontAttributeName value:SYSTEMFONT(16) range:NSMakeRange(0,str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,str.length-3)];
    self.totalMoneyLab.attributedText = str;
    
    
    [payView addSubview:self.totalMoneyLab];
    
    
    self.jieSuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jieSuanBtn.frame = CGRectMake(kScreenWidth-GetWidth(184)-10,(50-GetHeight(74))/2.0,GetWidth(184), GetHeight(74));
    [self.jieSuanBtn setBackgroundColor:RGBACOLOR(0, 189, 155, 1)];
    [self.jieSuanBtn setBackgroundImage:[UIImage imageNamed:@"nav"] forState:0];
    [self.jieSuanBtn addTarget:self action:@selector(jieSuanAction) forControlEvents:UIControlEventTouchUpInside];
    self.jieSuanBtn.layer.masksToBounds = YES;
    self.jieSuanBtn.layer.cornerRadius = GetHeight(74)/2.0;
    [self.jieSuanBtn setTitle:@"转让" forState:UIControlStateNormal];
    
    [self.jieSuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.jieSuanBtn.titleLabel.font = SYSTEMFONT(12.0);
    self.jieSuanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [payView addSubview:self.jieSuanBtn];
    
   
}
//结算
-(void)jieSuanAction{
   
        if (self.allPrice!=0) {
            NSString *goods_orderId = @"";
            ZJRecordListInfo *model = nil;
            for (ZJRecordListInfo *info in dataSourceArray){
                if (info.selectState) {
                    model = info;
                goods_orderId = [NSString stringWithFormat:@"%@%@,",goods_orderId,info.order_id];
                }
            }
            goods_orderId = [goods_orderId substringWithRange:NSMakeRange(0, goods_orderId.length-1)];
            TransferViewController *vc = [[TransferViewController alloc]init];
            vc.order_type = @"donor";
//            vc.goodInfo = model;
            vc.orders_id = goods_orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [Tool showPromptContent:@"亲 请先选择商品哦！微笑"];
        }
}


-(void)CalculationPrice
{
    self.allPrice = 0.0;
    self.ids = @"";
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格(单价 * 商品数量)
    for ( int i =0; i<dataSourceArray.count;i++)
    {
        ZJRecordListInfo *model = dataSourceArray[i];
        if (model.selectState)
        {
            self.allPrice = self.allPrice + [model.goodvalues intValue]/100;
//            self.ids = [NSString stringWithFormat:@"%@,%@",model.id,self.ids];
        }
    }
    
    //给总价赋值
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ldRMB",(long)self.allPrice]];
    [str addAttribute:NSFontAttributeName value:SYSTEMFONT(16) range:NSMakeRange(0,str.length-3)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,str.length-3)];
    self.totalMoneyLab.attributedText = str;

}




#pragma mark - http
- (void)httpGetRecordList
{
    __weak GetGoodListViewController *weakSelf = self;
   
    [HttpHelper getRecordWithUserid:[ShareManager shareInstance].userinfo.id
                          pageNum:[NSString stringWithFormat:@"%d",pageNum]
                         limitNum:@"10"
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
     MLog(@"resultDic%@",resultDic);
    if (resourceArray && resourceArray.count > 0 )
        
    {
        
        if (dataSourceArray.count > 0 && pageNum == 1) {
            [dataSourceArray removeAllObjects];
            
        }
        
        ZJRecordListInfo *previous = nil;
        for (NSDictionary *dic in resourceArray)
        {

            ZJRecordListInfo *current = [dic objectByClass:[ZJRecordListInfo class]];
            current.selectState = NO;
      
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
        
        if (resourceArray.count < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
        
        // 中了三赔，也中了一元购, thriceOrderID == nil, 还有数据没有下发自动获取
        if ([previous hasWinThrice] && previous.thriceOrderID.length == 0 && [previous hasWinCrowdfunding]) {
            [self httpGetRecordList];
        }
        
    }else{
        if (pageNum == 1) {
//            [Tool showPromptContent:@"暂无数据" onView:self.view];
            
            
        }
    }
    
    [self.tableView reloadData];
    [self CalculationPrice];
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

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableView;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    getGoodListCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"getGoodListCell"];
    
    if (cell==nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"getGoodListCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    ZJRecordListInfo *model = dataSourceArray[indexPath.row];
//    MLog(@"ZJRecordListInfo%@",model.get_type);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.good_header] placeholderImage:PublicImage(@"sixeightbg_3")];
    cell.goodNameLabel.text = model.good_name;
    cell.goodNumLabel.text = model.good_period;

    if ([model.create_time containsString:@"-"]) {
        cell.goodTimeLabel.text = model.create_time;
    }else{
        NSString *time = [Tool timeStringToDateSting:model.create_time format:@"yyyy-MM-dd hh:mm:ss"];
        cell.goodTimeLabel.text = [NSString stringWithFormat:@"%@",time];
    }
    
    cell.userLabelBtn.text = model.donor_user_id;
    cell.needNumLabel.text = [NSString stringWithFormat:@"%@人次",model.need_people];
    cell.dianjiBtn.hidden = YES;
    [cell.dianjiBtn setTitle:@"点击确认" forState:UIControlStateNormal];
    [cell.dianjiBtn addTarget:self action:@selector(affirmGood:) forControlEvents:UIControlEventTouchUpInside];
    [cell.addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.dianjiBtn.tag = indexPath.row;
    cell.addBtn.tag = indexPath.row;
    if ([model.receivor_confirm  isEqual: @"n"]) {
        cell.dianjiBtn.hidden = NO;
        cell.statueLabel.hidden = YES;
        cell.arrBtn.hidden = YES;
        cell.addBtn.hidden = YES;
        [cell.dianjiBtn setTitle:@"点击确认" forState:UIControlStateNormal];
    }else{
        if ([model.order_status  isEqual: @"待发货"]) {
            cell.dianjiBtn.hidden = YES;
            cell.statueLabel.hidden = NO;
            cell.arrBtn.hidden = NO;
            if ([model.goodsStatus isEqualToString:@"等待对方确认"]||![model.goods_type isEqualToString:@"虚拟商品"]) {
                cell.addBtn.hidden = YES;
            }else{
            cell.addBtn.hidden = NO;
            }
            if(model.selectState){
                [cell.addBtn setImage:[UIImage imageNamed:@"check_p"] forState:UIControlStateNormal];
            }else{
                [cell.addBtn setImage:[UIImage imageNamed:@"check_n"] forState:UIControlStateNormal];
            }
            cell.statueLabel.text = model.goodsStatus;
        }else if ([model.order_status  isEqual: @"已发货"]) {
            cell.statueLabel.hidden = NO;
            cell.arrBtn.hidden = NO;
            cell.statueLabel.text = @"已发货";
            cell.dianjiBtn.hidden = YES;
            cell.addBtn.hidden = YES;
        }else if([model.order_status  isEqual: @"已转赠"]){
            cell.addBtn.hidden = YES;
            cell.dianjiBtn.hidden = YES;
            cell.statueLabel.hidden = NO;
            cell.arrBtn.hidden = NO;
            cell.statueLabel.text = @"已转让";
        }
    }
   
    
    return cell;
}

-(void)addBtnClick:(UIButton *)btn{
    ZJRecordListInfo *model = dataSourceArray[btn.tag];
    model.selectState = !model.selectState;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self CalculationPrice];
    
}

-(void)affirmGood:(UIButton *)btn{
//    ZJRecordListInfo *model = dataSourceArray[btn.tag];
    NSString *ids = @"";
    for (ZJRecordListInfo *model in dataSourceArray) {
        if ([model.receivor_confirm isEqualToString:@"n"]) {
            
            ids = [NSString stringWithFormat:@"%@,%@",model.order_id,ids];
        }
    }
//    MLog(@"ZJRecordListInfo%@",ids);
    
    [HttpHelper affirmRecordWithUserid:[ShareManager shareInstance].userinfo.id order_id:ids success:^(NSDictionary *resultDic){
        
                    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                     [self setTabelViewRefresh];
       
        
                }fail:^(NSString *decretion){
                            
                [Tool showPromptContent:decretion onView:self.view];
                }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    getGoodListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.dianjiBtn.hidden) {
        [Tool showPromptContent:@"请先点击确认" onView:self.view];
        
        return;
    }
    
    ZJRecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
   
   // 点击一元购区域

        if ([info isVirtualGoods]) {
            GetRMBGoodViewController *vc = [[GetRMBGoodViewController alloc] initWithNibName:@"GetRMBGoodViewController" bundle:nil];
             vc.order_type = @"donor";
            vc.orderInfo = info;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            
            GetGoodTableViewController *vc = [[GetGoodTableViewController alloc] initWithNibName:@"GetGoodTableViewController" bundle:nil];
            vc.order_type = @"donor";
            vc.orderInfo = info;
             [self.navigationController pushViewController:vc animated:YES];
        }

    }


@end
