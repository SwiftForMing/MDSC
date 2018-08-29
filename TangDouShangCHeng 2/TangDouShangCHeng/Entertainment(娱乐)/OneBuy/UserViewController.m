//
//  UserViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserViewController.h"
#import "LifeZoneListTableViewCell.h"
#import "ShaiDanDetailViewController.h"
#import "SelfDuoBaoRecordInfo.h"
#import "ZJRecordListInfo.h"
#import "ZoneListInfo.h"
#import "UserCenterZJRecordTableViewCell.h"
#import "DuoBaoRecordListTableViewCell.h"
#import "DBNumViewController.h"
#import "DuoBaoRecordInfo.h"
#import "GoodsDetailInfoViewController.h"
#import "PhotoBroswerVC.h"
#import "PurchaseRecordTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface UserViewController ()<LifeZoneListTableViewCellDelegate>
{
    int selectType;//0 活动记录、1中奖记录、晒单分享
    int pageNum;
    NSMutableArray *duobaoRecordArray;
    NSMutableArray *zjRecordArray;
    NSMutableArray *zoneListArray;
    UserInfo *custInfo;
}

@end

@implementation UserViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    self.title = @"个人中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _iconWidth.constant = FullScreen.size.width/3;
    _levelLabel.layer.masksToBounds =YES;
    _levelLabel.layer.cornerRadius = _levelLabel.frame.size.height/2;
    _photoImage.layer.masksToBounds =YES;
    _photoImage.layer.cornerRadius = _photoImage.frame.size.height/2;
    
    [_dbButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_zjButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_sdButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    selectType = 0;
    
    [self updateSlectStatue];
    
    pageNum = 1;
    duobaoRecordArray = [NSMutableArray array];
    zjRecordArray = [NSMutableArray array];
    zoneListArray = [NSMutableArray array];
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

- (void)updateSlectStatue
{
    UIColor *normalCorlor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    UIColor *selectCorlor = [UIColor colorWithRed:210.0/255.0 green:16.0/255.0 blue:31.0/255.0 alpha:1];
    
    [_dbButton setTitleColor:normalCorlor forState:UIControlStateNormal];
    [_zjButton setTitleColor:normalCorlor forState:UIControlStateNormal];
    [_sdButton setTitleColor:normalCorlor forState:UIControlStateNormal];
    
    _dbLine.hidden = YES;
    _zjLine.hidden = YES;
    _sdLine.hidden = YES;
    
    switch (selectType) {
        case 0:
        {
            [_dbButton setTitleColor:selectCorlor forState:UIControlStateNormal];
            _dbLine.hidden = NO;
        }
            break;
        case 1:
        {
            [_zjButton setTitleColor:selectCorlor forState:UIControlStateNormal];
            _zjLine.hidden = NO;
        }
            break;
        default:
        {
            [_sdButton setTitleColor:selectCorlor forState:UIControlStateNormal];
            _sdLine.hidden = NO;
        }
            break;
    }
}

- (void)updateUserInfo
{
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:custInfo.user_header] placeholderImage:PublicImage(@"default_head.png")];
    _nameLabel.text = custInfo.nick_name;
    _numLabel.text = [NSString stringWithFormat:@"ID: %@",custInfo.id];
    _levelLabel.text = custInfo.level_name;
    
    CGSize size = [_numLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
    _numLabelWidth.constant = size.width + 2;
    size = [_levelLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
    _levelLabelWidth.constant = size.width + 16;
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickDBButtonAction:(id)sender
{
    
    selectType = 0;
    [self updateSlectStatue];
    [_myTableView.mj_header beginRefreshing];
}
- (IBAction)clickZJButtonAction:(id)sender
{
    selectType = 1;
    [self updateSlectStatue];
    [_myTableView.mj_header beginRefreshing];
}
- (IBAction)clickSDButtonAction:(id)sender
{
    selectType = 2;
    [self updateSlectStatue];
    [_myTableView.mj_header beginRefreshing];
}

- (void)clickSeeNumButtonAction:(UIButton *)btn
{
    
    SelfDuoBaoRecordInfo *info = [duobaoRecordArray objectAtIndex:btn.tag];
    DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
    MLog(@"custInfo.id%@",custInfo.id);
    vc.userId = _userId;
    vc.goodId = info.id;
    vc.userName = info.nick_name;
    vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http

- (void)getUserInfo
{
    __weak UserViewController *weakSelf = self;
    [HttpHelper getEntUserInfoWithUserId:_userId
                          success:^(NSDictionary *resultDic){
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                              {
                                  custInfo = [[resultDic objectForKey:@"data"] objectByClass:[UserInfo class]];
                                  [weakSelf updateUserInfo];
                              }else{
                                  [Tool showPromptContent:@"获取用户信息失败" onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              [Tool showPromptContent:decretion onView:self.view];
                          }];
}


- (void)httpGetRecordList
{
   
    __weak UserViewController *weakSelf = self;
    
    
    [HttpHelper getDuoBaoRecordWithUserid:_userId
                               status:@"全部"
                              pageNum:[NSString stringWithFormat:@"%d",pageNum]
                             limitNum:@"20"
                              success:^(NSDictionary *resultDic){
                                  [weakSelf hideRefresh];
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                      [weakSelf handleloadResult:resultDic];
                                  }else
                                  {
                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                  }
                              }fail:^(NSString *decretion){
                                  [weakSelf hideRefresh];
                                  [Tool showPromptContent:decretion onView:self.view];
                              }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (duobaoRecordArray.count > 0 && pageNum == 1) {
            [duobaoRecordArray removeAllObjects];
            
        }
        for (NSDictionary *dic in resourceArray)
        {
            SelfDuoBaoRecordInfo *info = [dic objectByClass:[SelfDuoBaoRecordInfo class]];
            [duobaoRecordArray addObject:info];
        }
        
        if (resourceArray.count < 20 || duobaoRecordArray.count >= 40) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    
    //谷歌分析查看其它用户个人中心统计
    [_myTableView reloadData];
}

- (void)httpGetZJRecordList
{
    __weak UserViewController *weakSelf = self;
    [HttpHelper getZJRecordWithUserid:_userId
                          pageNum:[NSString stringWithFormat:@"%d",pageNum]
                         limitNum:@"20"
                   is_happybean_goods:@"0"
                          success:^(NSDictionary *resultDic){
                              [self hideRefresh];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  [weakSelf handleloadZJRecordResult:resultDic];
                              }else
                              {
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                          }fail:^(NSString *decretion){
                              [self hideRefresh];
                              [Tool showPromptContent:decretion onView:self.view];
                          }];
}

- (void)handleloadZJRecordResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightWinRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        if (zjRecordArray.count > 0 && pageNum == 1) {
            [zjRecordArray removeAllObjects];
            
        }
        for (NSDictionary *dic in resourceArray)
        {
            ZJRecordListInfo *info = [dic objectByClass:[ZJRecordListInfo class]];
            
            // 510000000001 是网易一元购用户电话号码注册进来，参加了注册送10个小米，不中就送移动20元卡充值活动
            if ([info.id isEqualToString:@"510000000001"] == NO) {
                [zjRecordArray addObject:info];
            }
        }
        
        if (resourceArray.count < 20 || zjRecordArray.count >= 40) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [_myTableView.mj_footer resetNoMoreData];
        }
        
        pageNum++;
    }else{
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
    }
    //谷歌分析查看其它用户个人中心统计
    [_myTableView reloadData];
}

- (void)httpZoneList
{
    __weak UserViewController *weakSelf = self;
    [HttpHelper queryZoneListWithGoodsId:nil
                      target_user_id:_userId
                             pageNum:[NSString stringWithFormat:@"%d",pageNum]
                            limitNum:@"20"
                             success:^(NSDictionary *resultDic){
                                 [self hideRefresh];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadZoneListResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                             }fail:^(NSString *decretion){
                                 [self hideRefresh];
                                 [Tool showPromptContent:decretion onView:self.view];
                             }];
}

- (void)handleloadZoneListResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"baskList"];
    
    if (zoneListArray.count > 0 && pageNum == 1) {
        [zoneListArray removeAllObjects];
    }
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ZoneListInfo *info = [dic objectByClass:[ZoneListInfo class]];
            [zoneListArray addObject:info];
        }
        if (resourceArray.count < 20) {
            [_myTableView.mj_footer endRefreshingWithNoMoreData];
        }else
        {
            [_myTableView.mj_footer resetNoMoreData];
        }
        pageNum++;
    }
    else
    {
        if (pageNum == 1) {
            [Tool showPromptContent:@"暂无数据" onView:self.view];
        }
        
    }
    [_myTableView reloadData];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (selectType) {
        case 0:
            return duobaoRecordArray.count;
            break;
        case 1:
            return zjRecordArray.count;
            break;
        default:
            return zoneListArray.count;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectType == 0)
    {
        CGFloat height = 160;
        
        SelfDuoBaoRecordInfo *info = [duobaoRecordArray objectAtIndex:indexPath.row];
        if ([info hasBettingThrice]) {
            height += 112;
        }
        
        return height;
    }
    else if (selectType == 1)
    {
        return 133;
    }
    else{
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
        return [self getCellHeight:cell];
    }
    
}
- (void)loadCellContent:(LifeZoneListTableViewCell*)cell indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row >= zoneListArray.count) {
        return;
    }
    ZoneListInfo *info = [zoneListArray objectAtIndex: indexPath.row];
    NSArray *imageArray = [info.imgs componentsSeparatedByString:@","];
    cell.imageArray = imageArray;
    
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
    [cell.photo sd_setImageWithURL:[NSURL URLWithString:info.user_header] placeholderImage:PublicImage(@"default_head")];
    
    cell.nameLabel.text = info.nick_name;
    cell.timeLabel.text = info.create_time;
    
    cell.titleLabel.text = info.title;
    cell.goodsNameLabel.text = [NSString stringWithFormat:@"(第%@期)%@",info.good_period,info.good_name];
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
    if (selectType == 0) {
        SelfDuoBaoRecordInfo *info = [duobaoRecordArray objectAtIndex:indexPath.row];
        
        PurchaseRecordTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"PurchaseRecordTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PurchaseRecordTableViewCell" owner:nil options:nil];
            cell = [nib firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell reloadWithData:info ofUser:custInfo.id];
        
        cell.purchaseNextButtonInRunLottery.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
//             
    [self.navigationController pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
        cell.purchaseNextButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
//             
    [self.navigationController pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
        cell.purchaseMoreButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
            vc.goodId = info.id;
//             
    [self.navigationController pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
        cell.moreRecordButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            DBNumViewController *vc = [[DBNumViewController alloc]initWithNibName:@"DBNumViewController" bundle:nil];
            [vc reloadWithData:info];
            vc.userId = custInfo.id;
            vc.goodId = info.id;
            vc.userName = custInfo.nick_name;
            vc.goodName = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
//             
    [self.navigationController pushViewController:vc animated:YES];
            return [RACSignal empty];
        }];
        
        return cell;
        //
        //        DuoBaoRecordListTableViewCell *cell = nil;
        //        cell = [tableView dequeueReusableCellWithIdentifier:@"DuoBaoRecordListTableViewCell"];
        //        if (cell == nil)
        //        {
        //            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DuoBaoRecordListTableViewCell" owner:nil options:nil];
        //            cell = [nib objectAtIndex:0];
        //
        //        }
        //        //设点点击选择的颜色(无)
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        //        cell.processView.layer.masksToBounds =YES;
        //        cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2;
        //        cell.processViewHeight.constant = 7;
        //        cell.processView.hidden = NO;
        //
        //        cell.ZJButton.layer.masksToBounds =YES;
        //        cell.ZJButton.layer.cornerRadius = 4;
        //        cell.ZJButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
        //        cell.ZJButton.layer.borderWidth = 1.0f;
        //
        //        if(indexPath.row >= duobaoRecordArray.count)
        //        {
        //            return cell;
        //        }
        //
        //        SelfDuoBaoRecordInfo *info = [duobaoRecordArray objectAtIndex:indexPath.row];
        //        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
        //        cell.titleLabel.text = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
        //        cell.joinNum.text = [NSString stringWithFormat:@"本次参与%@人次",info.count_num];
        //
        //        if ([info.status isEqualToString:@"倒计时"]) {
        //            cell.ZJButton.hidden = YES;
        //            cell.detailView.hidden = YES;
        //            cell.allNum.hidden = YES;
        //            cell.needNum.hidden = YES;
        //            cell.needNumTitle.hidden = YES;
        //            cell.joinNumTop.constant = 0;
        //            cell.processView.hidden = YES;
        //            cell.WarnLabel.hidden = NO;
        //            cell.warnLabelHeight.constant = 15;
        //            cell.WarnLabel.backgroundColor = [UIColor whiteColor];
        //
        //            NSString * reviewStr = [NSString stringWithFormat:@"揭晓倒计时：<color1>请稍后，系统揭晓中...</color1>"];
        //
        //            cell.WarnLabel.textColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1];
        //
        //            NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
        //                                    @"color1":[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]};
        //
        //            cell.WarnLabel.attributedText = [reviewStr attributedStringWithStyleBook:style];
        //
        //
        //        }else if([info.status isEqualToString:@"已揭晓"]){
        //            cell.ZJButton.hidden = YES;
        //            cell.detailView.hidden = NO;
        //            cell.processView.hidden = YES;
        //            cell.allNum.hidden = YES;
        //            cell.needNum.hidden = YES;
        //            cell.needNumTitle.hidden = YES;
        //            cell.joinNumTop.constant = 0;
        //            cell.WarnLabel.hidden = NO;
        //            cell.WarnLabel.text = @"";
        //            cell.WarnLabel.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
        //            cell.warnLabelHeight.constant = 1;
        //
        //            cell.nameLabel.text = info.nick_name;
        //            cell.luckNumLabel.text = info.win_num;
        //            cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",info.win_fight_time];
        //            cell.timeLabel.text = info.lottery_time;
        //
        //
        //
        //        }else{//进行中
        //            cell.ZJButton.hidden = NO;
        //            [cell.ZJButton setTitle:@"跟买" forState:UIControlStateNormal];
        //            cell.detailView.hidden = YES;
        //            cell.joinNumTop.constant = 38;
        //            cell.WarnLabel.hidden = YES;
        //            cell.allNum.hidden = NO;
        //            cell.needNum.hidden = NO;
        //            cell.needNumTitle.hidden = NO;
        //
        //            cell.processLabelWidth.constant = (FullScreen.size.width - 174)*([info.progress doubleValue]/100.0);
        //
        //            cell.allNum.text = [NSString stringWithFormat:@"总需 %@",info.need_people];
        //            CGSize size = [cell.allNum sizeThatFits:CGSizeMake(MAXFLOAT, 15)];
        //            cell.allNumLabel.constant = size.width+5;
        //            cell.needNum.text = [NSString stringWithFormat:@"剩余 %d",(int)([info.need_people intValue]- [info.now_people intValue])];
        //
        //        }
        //        cell.seeButton.tag = indexPath.row;
        //        [cell.seeButton addTarget:self action:@selector(clickSeeNumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        //
        //        return cell;
        
    }
    else if (selectType == 1)
    {
        UserCenterZJRecordTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterZJRecordTableViewCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCenterZJRecordTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row >= zjRecordArray.count)
        {
            return cell;
        }
        ZJRecordListInfo *info = [zjRecordArray objectAtIndex:indexPath.row];
        [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
        cell.titleImage.text = [NSString stringWithFormat:@"[第%@期]%@",info.good_period,info.good_name];
        cell.needImage.text = [NSString stringWithFormat:@"总需 %@",info.need_people];
        cell.luckNumLabel.text = info.win_num;
        cell.joinNumLabel.text = [NSString stringWithFormat:@"%@人次",info.count_num];
        cell.timeLabel.text = info.lottery_time;
        
        return cell;
    }else{
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (selectType == 0) {
        SelfDuoBaoRecordInfo *info = [duobaoRecordArray objectAtIndex:indexPath.row];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
      
        
    [self.navigationController pushViewController:vc animated:YES];
    }
    else if (selectType == 1) {
        ZJRecordListInfo *info = [zjRecordArray objectAtIndex:indexPath.row];
        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
        vc.goodId = info.id;
       
        
    [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        ZoneListInfo *info = [zoneListArray objectAtIndex:indexPath.section];
        ShaiDanDetailViewController *vc = [[ShaiDanDetailViewController alloc]initWithNibName:@"ShaiDanDetailViewController" bundle:nil];
        vc.zoneId = info.id;
//
    [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - LifeZoneListTableViewCellDelegate <NSObject>

- (void)clickImageToSeeTableIndex:(NSIndexPath *)tindex image:(UIImageView *)image collectIndex:(NSIndexPath *)cindex
{
    long num = 0;
    ZoneListInfo *info = [zoneListArray objectAtIndex:tindex.row];
    if ([info.imgs isEqualToString:@"<null>"]) {
        num = 0;
    }else{
        NSArray *array = [info.imgs componentsSeparatedByString:@","];
        num = array.count;
    }
    
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
        [weakSelf getUserInfo];
        pageNum = 1;
        switch (selectType) {
            case 0:
                [weakSelf httpGetRecordList];
                break;
            case 1:
                [weakSelf httpGetZJRecordList];
                break;
            default:
                [weakSelf httpZoneList];
                break;
        }
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        switch (selectType) {
            case 0:
                [weakSelf httpGetRecordList];
                break;
            case 1:
                [weakSelf httpGetZJRecordList];
                break;
            default:
                [weakSelf httpZoneList];
                break;
        }
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
    
//    UILabel *label = [UILabel label];
//    label.text = @"只能查看40条记录";
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
