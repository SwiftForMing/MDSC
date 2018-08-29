//
//  ClassifyViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClassifyCollectionViewCell.h"
#import "NewHomeViewController.h"
#import "GoodTypeModel.h"
#import "HomeTopCell.h"
#import "ClassifyTableViewController.h"
#import "GoodDetailViewController.h"
#import "GetCouponViewController.h"

@interface ClassifyViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataArray;
    NSMutableArray *_searchArray;
    NSInteger _page;
    BOOL _first;
    NSString *searchKey;
    
}
@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)UITableView *myTableView;




@end

@implementation ClassifyViewController




-(UICollectionView *)collectionview{
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.minimumInteritemSpacing = 0;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 44, FullScreen.size.width, FullScreen.size.height-104) collectionViewLayout:flowlayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;

      _collectionview.backgroundColor = [UIColor whiteColor];
    }
    return _collectionview;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"分类";
    [self hidenLeftBarButton];
    [self createSearchBar];
    _page = 0;
    _first = true;

    _dataArray = [ShareManager shareInstance].ClassifyData;
    if (_dataArray.count==0) {
       [self getData];
    }
    _searchArray = [NSMutableArray array];
    
    searchKey = @"";
    [self.view addSubview:self.collectionview];
//    [self getData];
    //注册Cell
    [self.collectionview registerNib:[UINib nibWithNibName:@"ClassifyCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"ClassifyCollectionViewCell"];
}

-(void)createSearchBar
{
    self.bar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    //设置bar的frame
//    self.bar.frame=;
    [self.view addSubview:self.bar];
    self.bar.placeholder = @"搜索";
    // searchBar  代理,记得签协议
    self.bar.delegate = self;
   // 去除 searchBar 上下两条黑线
    UIImageView *barImageView = [[[self.bar.subviews firstObject] subviews] firstObject];
    barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
    barImageView.layer.borderWidth = 1;
    
    self.bar.backgroundColor = [UIColor whiteColor];
    self.bar.barTintColor = [UIColor colorWithHexString:@"f7f7f7"];

    UITextField *searchField=[self.bar valueForKey:@"_searchField"];
    searchField.backgroundColor =  [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:12];
    searchField.layer.masksToBounds = YES;
    searchField.layer.cornerRadius = 18;
    searchField.layer.borderWidth = 1;
    searchField.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!_myTableView) {
        self.myTableView = [[UITableView alloc]initWithFrame:(CGRectMake(0, 44, ScreenWidth, ScreenHeight)) style:0];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        self.bar.showsCancelButton = YES;
        [searchBar becomeFirstResponder];
            self.bar.placeholder = @"";
        [self.view addSubview:_myTableView];
    }
    
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_myTableView removeFromSuperview];
    _myTableView = nil;
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    
}
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
    [searchBar resignFirstResponder];
    [self setTabelViewRefresh];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    searchKey = searchText;
}

-(void)getSearchDataWithKey:(NSString *)key{
    
    __weak ClassifyViewController *weakSelf = self;
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
    [_myTableView reloadData];

}

// 设置搜索tableView section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// 设置搜索tableView cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchArray.count == 0) {
        return 1;
    }
    return _searchArray.count;
}

// 设置搜索tableView的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (_searchArray.count != 0) {
        HomeTopCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTopCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeTopCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        //设点点击选择的颜色(无)
        HomeGoodModel *model = [_searchArray objectAtIndex:indexPath.row];
        cell.goodModel = model;
        [cell.getBtn addTarget:self action:@selector(lqBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.getBtn.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        static NSString *cellIdentifier = @"indenfy";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = @"没有查找的内容";
        cell.imageView.image = nil;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 跳转操作
    GoodDetailViewController *vc = [[GoodDetailViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = [_searchArray objectAtIndex:indexPath.row];
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 领取操作
-(void)lqBtnClick:(UIButton *)btn{
    GetCouponViewController *vc = [[GetCouponViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = [_searchArray objectAtIndex:btn.tag];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.bar resignFirstResponder];
}


#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
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
    
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
}

#pragma mark 获取collectionview
-(void)getData{

    __weak ClassifyViewController *weakSelf = self;
    [HttpHelper getHttpWithUrlStr:URL_HomeBasics
                      success:^(NSDictionary *resultDic){
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
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dict in tabArr)
        {
            GoodTypeModel* model = [dict objectByClass:[GoodTypeModel class]];
            
            [array addObject:model];
        }
        _dataArray = array;
    }
    [self.collectionview reloadData];
    
}

#pragma mark 定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark UICollectionView 的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


#pragma mark 每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ClassifyCollectionViewCell";
    
    ClassifyCollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"ClassifyCollectionViewCell" owner:self options:nil]  firstObject];
    }
    GoodTypeModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.typeModel = model;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
#pragma mark 定义每个Item 的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth/2, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


#pragma mark 定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

#pragma mark 返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 返回这个UICollectionView是否可以被选择
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyTableViewController *vc = [[ClassifyTableViewController alloc]initWithTableViewStyle:1];
    GoodTypeModel *model = _dataArray[indexPath.row];
    vc.goodID = model.id;
    vc.goodTitle = model.goods_type_name;
  
    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"%ld--%ld-%ld",(long)indexPath.item,indexPath.section,indexPath.row);
}

@end
