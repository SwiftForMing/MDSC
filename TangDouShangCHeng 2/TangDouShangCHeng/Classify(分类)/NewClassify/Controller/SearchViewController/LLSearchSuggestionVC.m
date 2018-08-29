//
//  LLSearchSuggestionVC.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchSuggestionVC.h"

@interface LLSearchSuggestionVC ()<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *_searchArray;
    NSInteger _page;
    BOOL _first;
    NSString *searchKey;
}

@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, copy)   NSString *searchTest;

@end

@implementation LLSearchSuggestionVC

- (UITableView *)contentView
{
    if (!_contentView) {
        self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.tableFooterView = [UIView new];
        [_contentView registerNib:[UINib nibWithNibName:@"RecommendedCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _contentView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
    _page = 0;
    _first = true;
    _searchArray = [NSMutableArray array];
}

- (void)searchTestChangeWithTest:(NSString *)test
{
    searchKey = test;
//    [self getSearchDataWithKey:test];
    [self setTabelViewRefresh];
//    [_contentView reloadData];
}

-(void)getSearchDataWithKey:(NSString *)key{
    
    __weak LLSearchSuggestionVC *weakSelf = self;
    [HttpHelper getSearchKeyDataWithKeyWord:key success:^(NSDictionary *resultDic) {
        [weakSelf hideRefresh];
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            MLog(@"resultDic:%@",resultDic);
            [weakSelf handleloadSearchResult:resultDic];
        }
    } fail:^(NSString *description) {
        [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
    }];
    
}
- (void)handleloadSearchResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    NSArray *goodArray = [dic objectForKey:@"goodsSearchList"];
    if (goodArray) {
        if (_searchArray.count > 0) {
            [_searchArray removeAllObjects];
        }
        for (NSDictionary *dic in goodArray)
        {
            MLog(@"goodsSearchList:%@",dic);
            HomeGoodModel *info = [dic objectByClass:[HomeGoodModel class]];
            [_searchArray addObject:info];
        }
    }
    [_contentView reloadData];
    
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.contentView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    tableView.contentOffset = CGPointMake(0, 0);
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        pageNum = 1;
        [weakSelf getSearchDataWithKey:searchKey];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getSearchDataWithKey:searchKey];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([_contentView.mj_footer isRefreshing])
    {
        [_contentView.mj_footer endRefreshing];
    }
    if([_contentView.mj_header isRefreshing])
    {
        [_contentView.mj_header endRefreshing];
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    HomeGoodModel *model = _searchArray[indexPath.row];
    cell.goodModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 158;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchBlock) {
        self.searchBlock(_searchArray[indexPath.row]);
    }
    MLog(@"didSelectRowAtIndexPath");

   
//    let model = _searchArray![indexPath.row] as! HomeGoodModel
//    let vc = GoodDetailViewController(tableViewStyle: .grouped)
//    vc?.goodModel = model
//    self.navigationController?.pushViewController(vc!, animated: true)
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
