//
//  ShaiDanViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ShaiDanViewController.h"
#import "LifeZoneListTableViewCell.h"
#import "UserViewController.h"
#import "ShaiDanDetailViewController.h"
#import "ZoneListInfo.h"
#import "PhotoBroswerVC.h"
#import "IQKeyboardManager.h"
#import "ZJRecordViewController.h"

@interface ShaiDanViewController ()<LifeZoneListTableViewCellDelegate, BaseTableViewDelegate>
{
    int pageNum;
    NSMutableArray *dataSourceArray;
    int lookCount;
    int picCount;
}
@property (nonatomic) BOOL loadOnce;

@end

@implementation ShaiDanViewController

- (void)dealloc{
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    MLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loadOnce = NO;
    
    [self initVariable];
    [self leftNavigationItem];
    [self setTabelViewRefresh];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    self.myTableView.delegate = self;
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
    self.title = @"晒单分享";
    pageNum = 1;
    lookCount = 0;
    picCount = 0;
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

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    //谷歌分析点击用户头像次数
    NSLog(@"lookCount: %d%d",lookCount,picCount);
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    //    UIImageView *imageview = (UIImageView *)tap.self.view;
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    lookCount+=1;
    UIImageView *imageview = (UIImageView *)tap.self.view;
    ZoneListInfo *info = [dataSourceArray objectAtIndex:imageview.tag];
    NSString *userIdStr = info.user_id;
    
    if ([userIdStr isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        return;
    }
    
    UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    vc.userId = userIdStr;
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - http

- (void)httpZoneList
{

    __weak ShaiDanViewController *weakSelf = self;
    [HttpHelper queryZoneListWithGoodsId:_goodId
                      target_user_id:_userId
                             pageNum:[NSString stringWithFormat:@"%d",pageNum]
                            limitNum:@"20"
                             success:^(NSDictionary *resultDic){
                                 
                                 weakSelf.loadOnce = YES;
                                 
                                 [weakSelf hideRefresh];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                     [_myTableView reloadData];
                                 }
                             }fail:^(NSString *decretion){
                                 [weakSelf hideRefresh];
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}


-(void)noDataUI
{
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:(CGRectMake(FullScreen.size.width/2-100, 100, 200, 200))];
    bgImage.image = [UIImage imageNamed:@"bg_shaidan"];
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
    bgImage.tag = 100;
    [self.myTableView addSubview:bgImage];
    
}

-(void)removeBgimage
{
    if ([self.myTableView viewWithTag:100]) {
        [[self.myTableView viewWithTag:100] removeFromSuperview];
        
    }else{
        MLog(@"没有东西");
    }
    
}



- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"baskList"];
    
    if (dataSourceArray.count > 0 && pageNum == 1) {
        [dataSourceArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            
            MLog(@"resourceArray%@",dic);
           
            ZoneListInfo *info = [dic objectByClass:[ZoneListInfo class]];
            [dataSourceArray addObject:info];
        }
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }
    //晒单分享界面用户操作统计
  
    
    [_myTableView reloadData];
}


#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只创建一个cell用作测量高度
    static LifeZoneListTableViewCell *cell = nil;
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LifeZoneListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        [cell initImageCollectView];
        cell.imageCollectView.delegate = cell;
        cell.imageCollectView.dataSource = cell;
    }
    
    [self loadCellContent:cell indexPath:indexPath];
    return [self getCellHeight:cell] - 7;
    
}
- (void)loadCellContent:(LifeZoneListTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    
    ZoneListInfo *info = [dataSourceArray objectAtIndex: indexPath.row];
    NSArray *imageArray = [info.imgs componentsSeparatedByString:@","];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (NSString *image in imageArray){
        if ([image containsString:@"http:"]) {
            [imageArr addObject:image];
        }
        
    }
    cell.imageArray = imageArr;
    
    if (imageArray.count >= 3) {
        cell.collectViewWidth.constant = FullScreen.size.width-100;
    }
    else if(imageArray.count == 2)
    {
        cell.collectViewWidth.constant = (FullScreen.size.width-100)/3*2+8;
    }else if(imageArray.count == 1){
        cell.collectViewWidth.constant = (FullScreen.size.width-100)/3;
    }
    
    [cell.imageCollectView reloadData];
    
    cell.photo.layer.masksToBounds =YES;
    cell.photo.layer.cornerRadius = cell.photo.frame.size.height/2;
    MLog(@"info.user_header%@",info.user_header);
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    
    cell.nameLabel.text = info.nick_name;
    cell.timeLabel.text = info.create_time;
    
    cell.titleLabel.text = info.title;
    cell.goodsNameLabel.text = [NSString stringWithFormat:@"[第%@期] %@",info.good_period,info.good_name];
    cell.contentLabel.text = info.content;
}

- (CGFloat)getCellHeight:(LifeZoneListTableViewCell*)cell
{
    
    [cell layoutIfNeeded];
    [cell updateConstraintsIfNeeded];
    CGSize size0 = [cell.titleLabel sizeThatFits:CGSizeMake(FullScreen.size.width-105, MAXFLOAT)];
    CGSize size1 = [cell.goodsNameLabel sizeThatFits:CGSizeMake(FullScreen.size.width-105, MAXFLOAT)];
    CGSize size2 = [cell.contentLabel sizeThatFits:CGSizeMake(FullScreen.size.width-105, MAXFLOAT)];
    
    CGFloat height1 = cell.imageCollectView.contentSize.height;
    
    return 78+height1+size0.height+size1.height+size2.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LifeZoneListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"LifeZoneListTableViewCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LifeZoneListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        [cell initImageCollectView];
        cell.delegate = self;
        cell.imageCollectView.delegate = cell;
        cell.imageCollectView.dataSource = cell;
    }
  
    cell.photo.tag = indexPath.row;
    cell.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
    [cell.photo addGestureRecognizer:tap];
    [self loadCellContent:cell indexPath:indexPath];
    
    
    CGSize size = [cell.titleLabel sizeThatFits:CGSizeMake(FullScreen.size.width-105, MAXFLOAT)];
    cell.titleLabelHeight.constant = size.height;
    
    size = [cell.goodsNameLabel sizeThatFits:CGSizeMake(FullScreen.size.width-105, MAXFLOAT)];
    cell.goodsNameLabelHeight.constant = size.height;
    
    size = [cell.contentLabel sizeThatFits:CGSizeMake(FullScreen.size.width-105, MAXFLOAT)];
    cell.contentLabelHeight.constant = size.height;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ZoneListInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    ShaiDanDetailViewController *vc = [[ShaiDanDetailViewController alloc]initWithNibName:@"ShaiDanDetailViewController" bundle:nil];
    vc.zoneId = info.id;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BaseTableViewDelegate

- (UIView *)emptyViewForTableView:(UITableView *)tableView
{
    UIView *view = nil;
    
    if (dataSourceArray.count == 0 && _loadOnce == YES) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 162)];
        label.font = [UIFont systemFontOfSize:22];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        label.text = @"您还没有晒单记录，\n晒单免费领取小米哦~";
        view = label;
        [self noDataUI];
    }
    
    return view;
}

#pragma mark - LifeZoneListTableViewCellDelegate <NSObject>

- (void)clickImageToSeeTableIndex:(NSIndexPath *)tindex image:(UIImageView *)image collectIndex:(NSIndexPath *)cindex
{
    long num = 0;
    ZoneListInfo *info = [dataSourceArray objectAtIndex:tindex.row];
    if ([info.imgs isEqualToString:@"<null>"]) {
        num = 0;
    }else{
        NSArray *array = [info.imgs componentsSeparatedByString:@","];
        num = array.count;
    }
    
    picCount += 1;
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:cindex.row photoModelBlock:^NSArray *{
        NSArray *array = [info.imgs componentsSeparatedByString:@","];
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:num];
        for (NSUInteger i = 0; i< num; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            NSString *url = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
            pbModel.image_HD_U = url;
            
            //源frame
            UIImageView *imageV =image;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        return modelsM;
    }];
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        [weakSelf httpZoneList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpZoneList];
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
