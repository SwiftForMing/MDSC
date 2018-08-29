//
//  CZRecordListViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CZRecordListViewController.h"
#import "ReordListTableViewCell.h"
#import "RecordListInfo.h"

@interface CZRecordListViewController ()
{
    NSMutableArray *dataSourceArray;
    int pageNum;
}

@end

@implementation CZRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    dataSourceArray = [NSMutableArray array];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

#pragma mark -http
- (void)httpGetRecord
{
    __weak CZRecordListViewController *weakSelf = self;
    
    NSString *type = @"a";
    if (_isThrice) {
        type = @"b";
    }
    
    [HttpHelper getCZRecordWithUserId:[ShareManager shareInstance].userinfo.id
                          pageNum:[NSString stringWithFormat:@"%d",pageNum]
                         limitNum:@"30"
                             type:type
                          success:^(NSDictionary *resultDic){
                            [self hideRefresh];
                            if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                [weakSelf handleloadFriendsListResult:resultDic];
                            }else
                            {
                                [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                            }
                        }fail:^(NSString *decretion){
                            [self hideRefresh];
                            [Tool showPromptContent:decretion onView:self.view];
                        }];
}

- (void)handleloadFriendsListResult:(NSDictionary *)resultDic
{
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"alreadyPayList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            RecordListInfo *info = [dic objectByClass:[RecordListInfo class]];
            [dataSourceArray addObject:info];
            
            if (_isThrice) {
                info.get_money /= 1;
            }
        }
        
        if (resourceArray.count < 30) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }
    
    [_myTableView reloadData];
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReordListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ReordListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReordListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RecordListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.typeStr.text = info.type;
    cell.timeLabel.text = info.create_time;
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",info.get_money];
    CGSize size = [cell.moneyLabel sizeThatFits:CGSizeMake(MAXFLOAT, 35)];
    cell.moneyLabelWidth.constant = size.width;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - 上下刷新
- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpGetRecord];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         [weakSelf httpGetRecord];
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
