//
//  ClassifyTableViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/6.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "ClassifyTableViewController.h"
#import "GoodTypeModel.h"
#import "HomeTopCell.h"
#import "GoodDetailViewController.h"
#import "GetCouponViewController.h"
@interface ClassifyTableViewController ()
{
    NSMutableArray *_dataArray;
    int page;
    
}
@end

@implementation ClassifyTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    self.title = self.goodTitle;
    page = 0;
    [self setTabelViewRefresh];
    self.numOfSection = 2;
    self.hightForFooter = 20;
}

-(void)getData{
    __weak ClassifyTableViewController *weakSelf = self;
    [HttpHelper getSearchIDDataWithID:self.goodID
                              pageNum:[NSString stringWithFormat:@"%d",page]
                            limitNum:@"20"
                             success:^(NSDictionary *resultDic){
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
    //推荐
    NSArray *tabArr = [dic objectForKey:@"goodsTypeList"];
    
    if (tabArr && tabArr.count > 0) {
        
        if (_dataArray.count > 0) {
            [_dataArray removeAllObjects];
        }
        
        for (NSDictionary *dict in tabArr)
        {
            HomeGoodModel* model = [dict objectByClass:[HomeGoodModel class]];
            
            [_dataArray addObject:model];
        }
    }
    [self.tableView reloadData];
    
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return _dataArray.count;
   
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
        HomeGoodModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.goodModel = model;
        [cell.getBtn setTitle:@"立即买劵" forState:0];
        cell.getBtn.tag = indexPath.row;
        [cell.getBtn addTarget:self action:@selector(getCoupon:) forControlEvents:   UIControlEventTouchUpInside];
    
            return cell;
    
    }
//点击立即领券的操作
-(void)getCoupon:(UIButton *)btn{

    MLog(@"btnTag%ld",(long)btn.tag);
    GetCouponViewController *vc = [[GetCouponViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = [_dataArray objectAtIndex:btn.tag];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GoodDetailViewController *vc = [[GoodDetailViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = [_dataArray objectAtIndex:indexPath.row];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
            return 135;
}
#pragma mark - tableview 上下拉刷新

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
