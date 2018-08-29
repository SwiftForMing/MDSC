//
//  ShaiDanDetailViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ShaiDanDetailViewController.h"
#import "ZoneDetailInfo.h"
#import "ImageListCollectionViewCell.h"
#import "PhotoBroswerVC.h"

@interface ShaiDanDetailViewController ()
{
    ZoneDetailInfo *detailInfo;
    NSArray *imageArray;
    UIButton *btnMoreItem;
}

@end

@implementation ShaiDanDetailViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self loadZoneDetailInfo];
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
    self.title = @"晒单详情";
    [_collectView registerClass:[ImageListCollectionViewCell class] forCellWithReuseIdentifier:@"ImageListCollectionViewCell"];
    _bgView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1] CGColor];
    _bgView.layer.borderWidth = 1.0f;
    _bgWidth.constant = FullScreen.size.width-16;
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

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"分享" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,12)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    btnMoreItem.hidden = YES;
}

- (void)updateShowUIData
{
    _titleLabel.text = detailInfo.title;
    _nameLabel.text = detailInfo.nick_name;
    _timeLabel.text = detailInfo.create_time;
    _goodNameLabel.text = [NSString stringWithFormat:@"[第%@期]%@",detailInfo.good_period,detailInfo.good_name];
    
    _joinNumLabel.text = [NSString stringWithFormat:@"%@人次",detailInfo.count_num];
    _luckNumLabel.text = detailInfo.win_num;
    _jiexiaoTimeLabel.text = detailInfo.lottery_time;
    _contentLabel.text = detailInfo.content;
    
    
    double height1 = 0;
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(FullScreen.size.width-32, MAXFLOAT)];
    if (size.height - 18 > 0) {
        height1 = size.height - 18;
    }
     size = [_goodNameLabel sizeThatFits:CGSizeMake(FullScreen.size.width-99, MAXFLOAT)];
    if (size.height - 18 > 0) {
        height1 = height1 + size.height - 18;
    }
    
    size = [_contentLabel sizeThatFits:CGSizeMake(FullScreen.size.width-32, MAXFLOAT)];
    if (size.height - 18 > 0) {
        height1 = height1 + size.height - 18;
        [_contentLabel sizeToFit];
    }
    
    
    double height = _collectView.contentSize.height-78;
    
    _bgHeight.constant = 300 + height;
    
    _collectView.hidden = NO;
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickRightItemAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
//    [ShareManager shareInstance].shareType = 2;
//    [ShareManager shareInstance].shareContentId = _zoneId;
    
//    [Tool showShareActionSheet:self.view
//                          text:detailInfo.good_name
//                        images:nil
//                           url:[NSURL URLWithString:detailInfo.share_url]
//                         title:@"中奖啦！中奖啦！"
//                          type:0
//                    completion:nil];
}


- (void)loadZoneDetailInfo
{
    MBProgressHUD * HUD = nil;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
 
//    HttpHelper *helper = [HttpHelper helper];
    __weak ShaiDanDetailViewController *weakSelf = self;
    [HttpHelper queryZoneDetailInfoWithGoodsId:_zoneId
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
    
    NSDictionary *dic = [[resultDic objectForKey:@"data"] objectForKey:@"baskMap"];
    if (dic) {
        detailInfo = [dic objectByClass:[ZoneDetailInfo class]];
        
        if ([detailInfo.imgs isEqualToString:@"<null>"]) {
            imageArray = nil;
        }else{
            imageArray = [detailInfo.imgs componentsSeparatedByString:@","];
        }
        btnMoreItem.hidden = NO;
    }else{
        [Tool showPromptContent:@"请求失败" onView:self.view];
    }
    
    [_collectView reloadData];
    [self performSelector:@selector(updateShowUIData) withObject:nil afterDelay:0.5];
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}


- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageListCollectionViewCell *cell = (ImageListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageListCollectionViewCell" forIndexPath:indexPath];
    
    cell.imageView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    cell.imageView.clipsToBounds = YES;
    for (NSString *image in imageArray) {
        if ([image containsString:@"http"]) {
            cell.imageView.hidden = NO;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:indexPath.row]] placeholderImage:PublicImage(@"defaultImage")];
        }else{
            cell.imageView.hidden = YES;
        }
    }
    
    
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (FullScreen.size.width-32)/3,(FullScreen.size.width - 32)/3);
    
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
   
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:indexPath.row photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:imageArray.count];
        for (NSUInteger i = 0; i< imageArray.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            NSString *url = [NSString stringWithFormat:@"%@",[imageArray objectAtIndex:i]];
            pbModel.image_HD_U = url;
            
            ImageListCollectionViewCell *cell = (ImageListCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            //源frame
            UIImageView *imageV =cell.imageView;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        return modelsM;
    }];
}


@end
