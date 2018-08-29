//
//  WantToSDViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "WantToSDViewController.h"
#import "ImageCollectionViewCell.h"
#import <objc/runtime.h>
#import "PhotoBroswerVC.h"

@interface WantToSDViewController ()<UIActionSheetDelegate>
{
    NSString *imageUrlStr;
}

@property (nonatomic, strong) NSMutableArray *imageSourceArray;

@end

@implementation WantToSDViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    
    // 虚拟物品
    if ([_detailInfo isVirtualGoods]) {
        
        _photoCollectView.hidden = YES;
        _reviewTitleLabel.hidden = YES;
        _reviewTitleLabel1.hidden = YES;
    }
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
    self.title = @"我要晒单";
    [_photoCollectView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
    
    self.imageSourceArray = [NSMutableArray array];
    
}

- (void)setDetailInfo:(ZJRecordListInfo *)detailInfo
{
    _detailInfo = detailInfo;
    
    // 虚拟物品
    if ([detailInfo isVirtualGoods]) {
        
        _photoCollectView.hidden = YES;
        _reviewTitleLabel.hidden = YES;
        _reviewTitleLabel1.hidden = YES;
    }
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
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,45, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"提交" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,12)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}


#pragma mark -http

- (void)httpUpdateImage:(UIImage*)image index:(NSInteger)index
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"数据提交中...";
    
    __weak WantToSDViewController *weakSelf = self;
    [HttpHelper postImageHttpWithImage:image
                           success:^(NSDictionary *resultDic){
                               [HUD hide:YES];
                               if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                   [weakSelf handleloadPostImageResult:resultDic index:index];
                               }else
                               {
                                   [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                               }
                               
                               
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:@"网络出错了" onView:self.view];
                           }];
    
}

- (void)handleloadPostImageResult:(NSDictionary *)resultDic index:(NSInteger)index
{
    if (imageUrlStr) {
        imageUrlStr = [NSString stringWithFormat:@"%@,%@",imageUrlStr,[resultDic objectForKey:@"data"]];
    }else{
        imageUrlStr = [resultDic objectForKey:@"data"];
    }
    
    if (index+1 < _imageSourceArray.count) {
        [self httpUpdateImage:[_imageSourceArray objectAtIndex:index+1] index:index+1];
    }
    else{
        [self httpPublicMessageImageUrl:imageUrlStr];
    }
    
}

- (void)httpPublicMessageImageUrl:(NSString*)imageUrl
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"数据提交中...";
    
    NSString *titleStr = @"感谢乐购";
    NSString *contentStr = nil;
    if (_contentText.text.length > 0) {
        contentStr = _contentText.text;
    }
    
//    HttpHelper *helper = [HttpHelper helper];
    __weak WantToSDViewController *weakSelf = self;
    [HttpHelper publicShaiDanWithUserId:[ShareManager shareInstance].userinfo.id
                     goods_fight_id:_detailInfo.id
                              title:titleStr
                            content:contentStr
                               imgs:imageUrl
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
    _detailInfo.is_bask = @"y";
    [Tool showPromptContent:@"提交成功" onView:self.view];
    
    if([self.delegate respondsToSelector:@selector(shaidanSuccess)])
    {
        [self.delegate shaidanSuccess];
    }
    
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
}


#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)clickRightItemAction:(id)sender
{
    if (_contentText.text.length < 1) {
        [Tool showPromptContent:@"请输入晒单内容" onView:self.view];
        return;
    }
    if (_imageSourceArray.count > 0) {
        [self httpUpdateImage:[_imageSourceArray objectAtIndex:0] index:0];
    }else{
        [self httpPublicMessageImageUrl:nil];
    }
}

- (void)clickDeleteButtonAction:(UIButton *)btn
{
    [_imageSourceArray removeObjectAtIndex:btn.tag];
    [_photoCollectView reloadData];
}

- (void)clickPitctureTosee:(UITapGestureRecognizer*)tap
{
    [Tool hideAllKeyboard];
    UIImageView *imageview = (UIImageView *)tap.self.view;
    
    ImageCollectionViewCell *cell = objc_getAssociatedObject(tap, "cell");
    
    NSIndexPath *indexPath = [_photoCollectView indexPathForCell:cell];
    
    if (_imageSourceArray.count == indexPath.row && _imageSourceArray.count != 5) {
        
        __weak WantToSDViewController *blockSelf = self;
        [[ShareManager shareInstance] selectPictureFromDevice:self isReduce:NO isSelect:YES isEdit:NO block:^(UIImage * image,NSString* imageName){
            [blockSelf.imageSourceArray addObject:image];
            [blockSelf.photoCollectView reloadData];
            
        }];
        
    }
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypePush index:indexPath.row photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:_imageSourceArray.count];
        for (NSUInteger i = 0; i< _imageSourceArray.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image = _imageSourceArray[i];
            //源frame
            UIImageView *imageV = imageview;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        return modelsM;
    }];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageSourceArray.count == 5) {
        return _imageSourceArray.count;
    }else{
        return _imageSourceArray.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    
    if (_imageSourceArray.count == 5) {
        cell.pictureImage.image =  [_imageSourceArray objectAtIndex:indexPath.row];
        cell.deleteButton.hidden = NO;
    }else{
        if (_imageSourceArray.count == indexPath.row) {
            cell.pictureImage.image = [UIImage imageNamed:@"xiaotu_41.png"];
            cell.deleteButton.hidden = YES;
        }else{
            //
            cell.pictureImage.image = [_imageSourceArray objectAtIndex:indexPath.row];
            cell.deleteButton.hidden = NO;
        }
        
    }
    cell.pictureImage.clipsToBounds = YES;
    
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(clickDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.pictureImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickPitctureTosee:)];
    [cell.pictureImage addGestureRecognizer:tap];
    objc_setAssociatedObject(tap, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
    
    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (collectionView.frame.size.width)/4, (FullScreen.size.width-16)/4);
    
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
