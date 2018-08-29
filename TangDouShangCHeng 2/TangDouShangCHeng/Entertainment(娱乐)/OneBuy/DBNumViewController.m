//
//  DBNumViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "DBNumViewController.h"
#import "DBNumListCollectionViewCell.h"
#import "SelfDuoBaoRecordInfo.h"

@implementation DuoBaoNumInfo

@end

@interface DBNumViewController ()
{
    NSMutableArray *dataSourceArray;
}

@end

@implementation DBNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _separationLine.backgroundColor = [UIColor colorWithWhite:0.9686 alpha:1.0];
    _separationLine1.backgroundColor = _separationLine.backgroundColor;
    _luckyImageView.image = [UIImage imageNamed:@"lucky_flag_82_20.jpg"];

    [self initVariable];
    [self leftNavigationItem];
    [self loadDuoBaoNum];
    
    [self reloadWithData:_data];
    
    if (_data == nil) {
        _lotteryContainerViewConstraint.constant = 0;
    }
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    //检测截屏
    //注册通知
////    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(userDidTakeScreenshot:)
//                                            name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

////截屏响应
//- (void)userDidTakeScreenshot:(NSNotification *)notification
//{
//    MLog(@"检测到截屏");
//    MLog(@"model%@",self.goodId);
//    [HttpHelper WhetherCutPhotoWithUserId:[ShareManager shareInstance].userinfo.id good_fight_id:self.goodId success:^(NSDictionary *resultDic) {
//        MLog(@"resultDic%@",resultDic);
//    } fail:^(NSString *description) {
//        MLog(@"description%@",description);
//    }];
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadWithData:(SelfDuoBaoRecordInfo *)data
{
    _data = data;
    
    NSString *lotteryNumberString = [NSString stringWithFormat:@"期号：%@", data.good_period];
    NSString *runLotteryTimeString = [NSString stringWithFormat:@"揭晓时间：%@", data.lottery_time];

    // 本期幸运号码：
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"本期幸运号码："];
    
    // 本期幸运号码：234242
    NSString *name = data.win_num ?:@"";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
    [attrString appendAttributedString:attr];

    _tiltleLabel.text = data.good_name;
    _lotteryNumberLabel.text = lotteryNumberString;
    _runLotteryTimeLabel.text = runLotteryTimeString;
    _runLotteryNumberLabel.attributedText = attrString;
    
    if ([data amWinLottery]) {
        _luckyImageView.hidden = NO;
        _lotteryContainerView.backgroundColor = [UIColor colorFromHexString:@"fdffe5"];
    } else {
        _luckyImageView.hidden = YES;
        _lotteryContainerView.backgroundColor = [UIColor whiteColor];
    }
    
    _lotteryContainerViewConstraint.constant = 106;
    NSString *statusStr = data.status;
    if ([statusStr isEqualToString:@"倒计时"]) {
        
        _lotteryContainerViewConstraint.constant = 62;
//        _runLotteryTimeLabelConstraints.constant = 0;
    } else if ([statusStr isEqualToString:@"已揭晓"]) {
        
    } else if ([statusStr isEqualToString:@"进行中"]) {
        
        _lotteryContainerViewConstraint.constant = 62;
    }
}

- (void)initVariable
{
    self.title = @"活动号码";
    dataSourceArray = [NSMutableArray array];
    
    [_myCollectView registerClass:[DBNumListCollectionViewCell class] forCellWithReuseIdentifier:@"DBNumListCollectionViewCell"];
    _tiltleLabel.text = _goodName;
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

#pragma mark -http

- (void)loadDuoBaoNum
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    __weak DBNumViewController *weakSelf = self;
    [HttpHelper loadDuoBaoLuckNumWithGoodsId:_goodId
                                 user_id:_userId
                                 success:^(NSDictionary *resultDic){
                                     [HUD hide:YES];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [weakSelf handleLoadResult:resultDic];
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                 }fail:^(NSString *decretion){
                                     [HUD hide:YES];
                                     [Tool showPromptContent:decretion onView:self.view];
                                 }];
}


- (void)handleLoadResult:(NSDictionary *)resultDic
{
    if (dataSourceArray.count > 0 ) {
        [dataSourceArray removeAllObjects];
        
    }
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"fightRecordList"];
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            DuoBaoNumInfo *info = [dic objectByClass:[DuoBaoNumInfo class]];
            [dataSourceArray addObject:info];
        }
        _warnLabel.text = [NSString stringWithFormat:@"%@共参与%lu人次",_userName,(unsigned long)dataSourceArray.count];
    }else{
       [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
        
    [_myCollectView reloadData];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DBNumListCollectionViewCell *cell = (DBNumListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DBNumListCollectionViewCell" forIndexPath:indexPath];
    
    DuoBaoNumInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    cell.numLabel.text = info.fight_num;
    [Tool setFontSizeThatFits:cell.numLabel];
   
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/4, 40);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
