//
//  SearchGoodsViewController.m
//  YCSH
//
//  Created by linqsh on 16/1/4.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "ClsaafilyTableViewCell.h"
#import "SearchHotDataInfo.h"
#import "GoodsListViewController.h"

@interface SearchGoodsViewController ()<UISearchBarDelegate>
{
    NSMutableArray *dataSourceArray;
}

@end

@implementation SearchGoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self registerNotif];
    [self initVariable];
    [self httpHotSearchData];
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
    
    _searchBgView.superview.backgroundColor = [UIColor defaultRedColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _searchBgView.layer.masksToBounds =YES;
    _searchBgView.layer.cornerRadius = 4;
//    _searchText.inputAccessoryView = [[UIView alloc] init];
    [_searchText becomeFirstResponder];
    
    dataSourceArray = [NSMutableArray array];
    
}

#pragma mark  - notif register

- (void)registerNotif
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - notif Action

//根据键盘高度将当前视图向上滚动同样高度
-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    CGPoint offset = _myTableView.contentOffset;
    
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _tableBottom.constant = change;
        [self.view layoutIfNeeded];
    }];
    
    
    [_myTableView setContentOffset:offset animated:NO];
    
}

//当键盘消失后，视图需要恢复原状。
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _tableBottom.constant = 0;
        [self.view layoutIfNeeded];
    }];
    
}

//键盘的高度计算：
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

#pragma mark - http

- (void)httpHotSearchData
{
//    HttpHelper *helper = [HttpHelper helper];
//    __weak SearchGoodsViewController *weakSelf = self;
//    [HttpHelper getHttpWithUrlStr:URL_GetHotSearchData
//                      success:^(NSDictionary *resultDic){
//                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
//                              [weakSelf handleloadResult:resultDic];
//                          }else
//                          {
//                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                          }
//                      }fail:^(NSString *decretion){
//                          [Tool showPromptContent:@"网络出错了" onView:self.view];
//                      }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    NSDictionary *dic = [resultDic objectForKey:@"data"] ;
    //广告
    NSArray *resourceArray = [dic objectForKey:@"hotSearchList"];
    if (resourceArray && resourceArray.count > 0) {
        if (dataSourceArray.count > 0) {
            [dataSourceArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            SearchHotDataInfo *info = [dic objectByClass:[SearchHotDataInfo class]];
            [dataSourceArray addObject:info];
        }
        _warnLabel.hidden = NO;
    }
    
    [_myTableView reloadData];
}

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickCannelButtonAction:(id)sender
{
    [_searchText resignFirstResponder];
    [self clickLeftControlAction:nil];
}

#pragma mark -  UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    GoodsListViewController *vc= [[GoodsListViewController alloc] initWithNibName:@"GoodsListViewController" bundle:nil];
    vc.isSearch = YES;
    vc.typeName = textField.text;
    vc.titleLabel.text = @"商品列表";
//     
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSourceArray.count;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}



//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClsaafilyTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ClsaafilyTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClsaafilyTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.iconImage.hidden = YES;
    cell.iconImageWidth.constant = 0;
    
    SearchHotDataInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = info.search_key;
    
    cell.titleLabel.textColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [_searchText resignFirstResponder];
    SearchHotDataInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
    GoodsListViewController *vc= [[GoodsListViewController alloc]initWithNibName:@"GoodsListViewController" bundle:nil];
    vc.isSearch = YES;
    vc.typeName = info.search_key;
//     
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchText resignFirstResponder];
}


@end
