//
//  ChartRelistViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/8.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "ChartRelistViewController.h"

@interface ChartRelistViewController (){
    int pageNum;
    NSMutableArray *recordDataArray;
}

@end

@implementation ChartRelistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参与记录";
    pageNum = 1;
    recordDataArray = [NSMutableArray array];
    [self setTabelViewRefresh];
    // Do any additional setup after loading the view.
}


- (void)loadDuoBaoRecord
{
    __weak ChartRelistViewController *weakSelf = self;
    [HttpHelper loadDuoBaoRecordWithGoodsId:_goodId
                                    pageNum:[NSString stringWithFormat:@"%d",pageNum]
                                   limitNum:@"20"
                                    success:^(NSDictionary *resultDic){
                                        [self hideRefresh];
                                        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                            [weakSelf handleLoadRecordResult:resultDic];
                                        }else
                                        {
                                            [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                        }
                                    }fail:^(NSString *decretion){
                                        [self hideRefresh];
                                        [Tool showPromptContent:decretion onView:self.view];
                                    }];
}


- (void)handleLoadRecordResult:(NSDictionary *)resultDic
{
    if (recordDataArray.count > 0 && pageNum == 1) {
        [recordDataArray removeAllObjects];
        
    }
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            DuoBaoRecordInfo *info = [dic objectByClass:[DuoBaoRecordInfo class]];
            [recordDataArray addObject:info];
        }
        
        if (resourceArray.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }else{
        if (pageNum == 1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    [self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return recordDataArray.count;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"RecordTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.photoImage.tag = indexPath.row;
    cell.photoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserPhotoAction:)];
    [cell.photoImage addGestureRecognizer:tap];
    cell.seeNumButton.tag = indexPath.row;
    [cell.seeNumButton addTarget:self action:@selector(clickSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:indexPath.row];
    
    cell.photoImage.layer.masksToBounds =YES;
    cell.photoImage.layer.cornerRadius = cell.photoImage.frame.size.height/2;
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@ ip:%@)",info.nick_name,info.user_ip_address,info.user_ip];
     cell.nameLabel.text = [NSString stringWithFormat:@"%@",info.nick_name];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",info.fight_time_all];
    cell.joinTimeLabel.text = [NSString stringWithFormat:@"参与%@人次",info.count_num];
    cell.joinNameLabel.text = [NSString stringWithFormat:@"%@",@""];
    
    if ([info.count_num intValue] > 1) {
        cell.seeNumButton.hidden = NO;
        cell.luckNumLabel.hidden = YES;
    }else{
        cell.seeNumButton.hidden = YES;
        cell.luckNumLabel.hidden = NO;
        cell.luckNumLabel.text = [NSString stringWithFormat:@"幸运号码：%@",info.fight_num];
    }
    
    
    return cell;
}

- (void)clickUserPhotoAction:(UITapGestureRecognizer*)tap
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    
    
    UIImageView *imageview = (UIImageView *)tap.self.view;
    NSString *userIdStr = nil;
    if (imageview.tag == -1) {
        userIdStr = _goodsDetailInfo.win_user_id;
    }else{
        DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:imageview.tag];
        userIdStr = info.user_id;
    }
    
    if ([userIdStr isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        return;
    }
    
    UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
    vc.userId = userIdStr;
//     
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


- (void)clickSeeNumButtonAction:(UIButton *)btn
{
    DuoBaoRecordInfo *info = [recordDataArray objectAtIndex:btn.tag];
    
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    vc.goodId = _goodsDetailInfo.id;
    vc.userId = info.user_id;
    vc.userName = info.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",_goodsDetailInfo.good_period,_goodsDetailInfo.good_name];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 1;
        MLog(@"66666666");
        [weakSelf loadDuoBaoRecord];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadDuoBaoRecord];
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([self.tableView.mj_header isRefreshing])
    {
        [self.tableView.mj_header endRefreshing];
    }
    if([self.tableView.mj_footer isRefreshing])
    {
        [self.tableView.mj_footer endRefreshing];
    }
    
}



@end
