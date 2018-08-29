//
//  EntClassifyViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "EntClassifyViewController.h"
#import "ClsaafilyTableViewCell.h"
#import "SearchGoodsViewController.h"
#import "GoodsListViewController.h"
#import "GoodsTypeInfo.h"
#import "QingDanViewController.h"
#import "GoodsListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
@interface EntClassifyViewController ()
{
    NSMutableArray *dataSourceArray;
    NSMutableArray *goodsDataSourceArray;
    int selectNum;
    UIActivityIndicatorView* activityIndicator;
}
@property (nonatomic, strong) SearchGoodsViewController *searchViewController;

@end

@implementation EntClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    selectNum = -1;
    [self leftNavigationItem];
    [self rightNavigationItem];
    [self httpGetTypeData];
//    [self httpTenGoodsInfoListWith:@"" typeStr:@""];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:activityIndicator];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    //    [self setRightBarButtonItem:@"购物车"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.searchViewController != nil) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.searchViewController = nil;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Search view controller is not need navigation bar
    if (self.searchViewController != nil) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initVariable
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"分类浏览";
    
    _searchButton.layer.masksToBounds =YES;
    _searchButton.layer.cornerRadius = 5;
    [_searchButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    dataSourceArray = [NSMutableArray array];
    goodsDataSourceArray = [NSMutableArray array];
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


- (void)rightNavigationItem
{
//    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
//
//    [leftItemControl whenTapped:^{
//        [activityIndicator startAnimating];
//        [self addCars];
//    }];
//    UILabel *back = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 60, 26)];
//    back.text = @"一键加入";
//    back.font = [UIFont systemFontOfSize:14];
//    back.layer.borderColor = [UIColor whiteColor].CGColor;
//    back.layer.borderWidth = 1;
//    back.layer.cornerRadius = 13;
//    back.textColor = UIColor.whiteColor;
//    [leftItemControl addSubview:back];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    
}

-(void)addCars{
    NSString *goods = @"";
    NSString *nums = @"";
    if (goodsDataSourceArray.count>0&&goodsDataSourceArray.count<20) {
        for (GoodsListInfo *info in goodsDataSourceArray){
           
            goods = [NSString stringWithFormat:@"%@%@,",goods,info.good_id];
            nums = [NSString stringWithFormat:@"%@%@,",nums,@"1"];
           
        }
        goods = [goods substringWithRange:NSMakeRange(0, goods.length-1)];
        nums = [nums substringWithRange:NSMakeRange(0, nums.length-1)];
    }else{
        [activityIndicator stopAnimating];
        if(goodsDataSourceArray.count>20){
          [Tool showPromptContent:@"一次最多只能添加20个商品哦"];
        }
        return;
    }
    
    [self httpAddGoodsToShopCartWithGoodsID:goods buyNum:nums];
    
    
}
- (void)httpAddGoodsToShopCartWithGoodsID:(NSString *)goodIds buyNum:(NSString *)buyNum
{
    __weak EntClassifyViewController *weakSelf = self;
    [HttpHelper addGoodsForShopCartWithUserId:[ShareManager shareInstance].userinfo.id
                                    goods_ids:goodIds
                               goods_buy_nums:buyNum
                                      success:^(NSDictionary *resultDic){
                                          
                                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                              [weakSelf handleloadAddGoodsToShopCartResult:resultDic buyNum:buyNum];
                                          }else
                                          {
                                              [activityIndicator stopAnimating];
                                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:weakSelf.view];
                                          }
                                      }fail:^(NSString *decretion){
                                          [activityIndicator stopAnimating];
                                          [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                                      }];
}

- (void)handleloadAddGoodsToShopCartResult:(NSDictionary *)resultDic buyNum:(NSString *)buyNum
{
    //    [Tool getUserInfo];
    [activityIndicator stopAnimating];
    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
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

- (void)httpGetTypeData
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
//    HttpHelper *helper = [HttpHelper helper];
    __weak EntClassifyViewController *weakSelf = self;
    [HttpHelper getEntHttpWithUrlStr:URL_GetGoodsType
                      success:^(NSDictionary *resultDic){
                          [HUD hide:YES];
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              [weakSelf handleloadResult:resultDic];
                          }else
                          {
                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                          }
                      }fail:^(NSString *decretion){
                          [HUD hide:YES];
                          [Tool showPromptContent:@"网络出错了" onView:self.view];
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
            MLog(@"GoodsTy%@",dic);
            GoodsTypeInfo *info = [dic objectByClass:[GoodsTypeInfo class]];
            if ([info.goods_type_name isEqualToString:@"PK专区"]){
                
            }else{
              [dataSourceArray addObject:info];
            }
           
        }
    }
    else
    {
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    
    [_myTableView reloadData];
    
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickSearchButtonAction:(id)sender
{
    SearchGoodsViewController *vc = [[SearchGoodsViewController alloc]initWithNibName:@"SearchGoodsViewController" bundle:nil];
    self.searchViewController = vc;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)httpTenGoodsInfoListWith:(NSString *)typeId typeStr:(NSString *)typeStr{
    
    __weak EntClassifyViewController *weakSelf = self;
    [HttpHelper getGoodsListOfTypeWithGoodsTypeIde:typeId
                                           success:^(NSDictionary *resultDic){
//                                               [self hideRefresh];
                                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                                   [weakSelf handleGetTenGoodsListLoadResult:resultDic typeStr:typeStr];
                                               }else
                                               {
                                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                               }
                                           }fail:^(NSString *decretion){
//                                               [self hideRefresh];
                                               [Tool showPromptContent:decretion onView:self.view];
                                           }];
}


- (void)handleGetTenGoodsListLoadResult:(NSDictionary *)resultDic typeStr:(NSString *)typeStr
{
    if (goodsDataSourceArray.count > 0) {
        [goodsDataSourceArray removeAllObjects];
        
    }
    //    goodsTypeList
    MLog(@"handleGetTenGoodsListLoadResult%@",resultDic);
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"goodsTypeList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            MLog(@"goodsList%@",dic);
            GoodsListInfo *info = [dic objectByClass:[GoodsListInfo class]];
            // 1判断是否是妙可
            if ([ShareManager shareInstance].isEnterMK) {
//                2.提取秒开数据
                if ([info.good_name containsString:@"秒开"]) {
//                    3.提取十元百元专区数据
                    if ([typeStr isEqualToString:@"十元专区"]) {
                        if([info.good_single_price intValue] == 1000){
                           [goodsDataSourceArray addObject:info];
                        }
                    }else if ([typeStr isEqualToString:@"百元专区"]) {
                        if([info.good_single_price intValue] == 10000){
                            [goodsDataSourceArray addObject:info];
                        }
                    }else{
                        [goodsDataSourceArray addObject:info];
                    }
                   
                }
            }else{
                if ([info.good_name containsString:@"秒开"]) {
                    
                }else{
                    if ([typeStr isEqualToString:@"十元专区"]) {
                        if([info.good_single_price intValue] == 1000){
                            [goodsDataSourceArray addObject:info];
                        }
                    }else if ([typeStr isEqualToString:@"百元专区"]) {
                        if([info.good_single_price intValue] == 10000){
                            [goodsDataSourceArray addObject:info];
                        }
                    }else{
                        [goodsDataSourceArray addObject:info];
                    }
                    
                }
            }
        }
        
        if (resourceArray.count < 100) {
            [_dataTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_dataTableView.mj_footer resetNoMoreData];
        }
        
        //        pageNum++;
    }
    
    
    
    //刷新
//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [_dataTableView reloadData];
  
    
  
}





#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_myTableView]) {
        return 1;
    }else{
        return 1;
    }
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 if ([tableView isEqual:_myTableView]) {
        return dataSourceArray.count;
 }else{
        return goodsDataSourceArray.count;
 }
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_myTableView]) {
        return 60;
    }else{
        return 102;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
 if ([tableView isEqual:_myTableView]) {
        return 35;
 }else{
     return 0;
 }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([tableView isEqual:_myTableView]) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 35);
        UIView *bgView = [[UIView alloc]initWithFrame:frame];
        bgView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 35)];
        contentView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:contentView];
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, 97,35)];
        titleLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
        titleLabel.text = @"分类浏览";
        titleLabel.font = [UIFont systemFontOfSize:14];
        [contentView addSubview:titleLabel];
        
        return bgView;
       
    }else{
        return nil;
    }
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual: _myTableView]) {
        ClsaafilyTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"ClsaafilyTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClsaafilyTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.iconImage.layer.masksToBounds =YES;
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2;
        cell.lineLabel.hidden = NO;
        if (selectNum == indexPath.row) {
            cell.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
        }else{
           cell.backgroundColor = UIColor.whiteColor;
        }
//
        GoodsTypeInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:info.goods_type_header] placeholderImage:nil];
        cell.titleLabel.text = info.goods_type_name;
        
        return cell;
    }else{
        GoodsListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodsListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
          GoodsListInfo *info = [goodsDataSourceArray objectAtIndex:indexPath.row];
        cell.processView.layer.masksToBounds =YES;
        cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
        
        if ([info.good_single_price intValue] == 1000) {
            cell.tagFlag.hidden = NO;
            cell.tagFlag.image = [UIImage imageNamed:@"new10Icon"];
        }
        
        if ([info.good_single_price intValue] == 10000) {
            cell.tagFlag.hidden = NO;
            cell.tagFlag.image = [UIImage imageNamed:@"new100Icon"];
        }
        if ([info.good_single_price intValue] == 100) {
            cell.tagFlag.hidden = YES;
        }
        
        cell.addButton.hidden = YES;
//        cell.addButton.tag = indexPath.row;
//        [cell.addButton whenTapped:^{
//            [self httpAddGoodsToShopCartWithGoodsID:info.good_id buyNum:@"1"];
//        }];
        cell.titleLabel.text = info.good_name;
        cell.allNum.text = [NSString stringWithFormat:@"总需 %ld",(long)info.need_people];
        CGSize size = [cell.allNum sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
        cell.allNeedWidth.constant = size.width;
        cell.needNum.text = [NSString stringWithFormat:@"剩余 %ld",(long)(info.need_people - info.now_people)];
        
        cell.processLabelWidth.constant = (FullScreen.size.width - 146)*([info.progress doubleValue]/100.0);
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
        cell.titleLabel.text = info.good_name;
        
        
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
   
}

-(void)SingleTap:(GoodsListInfo*)info
{
    //处理单击操作
    if ([info isThriceGoods]) {
    } else {
        
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc] initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([tableView isEqual:_myTableView]) {

         selectNum = (int)indexPath.row;
         [tableView reloadData];
         GoodsTypeInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
        NSString *strid = info.id;

        if ([info.goods_type_name isEqualToString:@"十元专区"]||[info.goods_type_name isEqualToString:@"百元专区"]) {
            strid = @"";
        }
        [self httpTenGoodsInfoListWith:strid typeStr:info.goods_type_name];
    }else{
        
        GoodsListInfo *info = [goodsDataSourceArray objectAtIndex:indexPath.row];
        [self SingleTap:info];
    }
    
}

@end
