//
//  UserLevelDetailViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/23.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserLevelDetailViewController.h"
#import "MyLeavelRulesTableViewCell.h"

@implementation MyLevelInfo

@end

@implementation LevelRulesInfo

@end


@interface UserLevelDetailViewController ()
{
    NSMutableArray *dataSourceArray;
    MyLevelInfo *myLevelInfo;
}

@end

@implementation UserLevelDetailViewController

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
    self.title = @"我的等级";
    dataSourceArray = [NSMutableArray array];
}

- (void)updateShowUI
{
    NSString * reviewStr = nil;
    if([myLevelInfo.is_max_score isEqualToString:@"n"])
    {
        reviewStr = [NSString stringWithFormat:@"当前成长值为<color1>%@</color1>，升至下一级还差<color1>%@</color1>点成长值!",myLevelInfo.user_score_all,myLevelInfo.differ_score];
    }else{
        reviewStr = [NSString stringWithFormat:@"当前成长值为<color1>%@</color1>，您已升到最高等级，恭喜您!",myLevelInfo.user_score_all];
    }
   
    _detailLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1];
    
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                            @"color1":[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]};
    
    _detailLabel.attributedText = [reviewStr attributedStringWithStyleBook:style];
    _numLabel.text = myLevelInfo.level_order;
    CGSize size = [_numLabel sizeThatFits:CGSizeMake(MAXFLOAT, 30)];
    _numLabelWidth.constant = size.width;
    
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

#pragma mark - http

- (void)httpGetLevelData
{
   
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    myLevelInfo = [[resultDic objectForKey:@"data"] objectByClass:[MyLevelInfo class]];
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"scoreRuleList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (dataSourceArray.count > 0 ) {
            [dataSourceArray removeAllObjects];
            
        }
        for (NSDictionary *dic in resourceArray)
        {
            LevelRulesInfo *info = [dic objectByClass:[LevelRulesInfo class]];
            [dataSourceArray addObject:info];
        }
        [self updateShowUI];
    }else{
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    [_myTableView reloadData];
}


#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
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
    return dataSourceArray.count+1;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;
    
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyLeavelRulesTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"MyLeavelRulesTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyLeavelRulesTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    if (indexPath.row == 0) {
        cell.contentLabel.text = @"规则如下：";
    }else{
        LevelRulesInfo *info = [dataSourceArray objectAtIndex:indexPath.row-1];
        cell.contentLabel.text = [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row,info.remark];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

        [weakSelf httpGetLevelData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
  
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
