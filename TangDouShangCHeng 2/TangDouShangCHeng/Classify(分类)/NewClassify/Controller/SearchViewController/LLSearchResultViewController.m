//
//  LLSearchResultViewController.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchResultViewController.h"
#import "LLSearchViewController.h"
#import "LLSearchSuggestionVC.h"
#import "LLSearchResultView.h"
#import "LLSearchView.h"

@interface LLSearchResultViewController ()<UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) MySearchBar *searchBar;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL activity;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) LLSearchResultView *resultView;
@property (nonatomic, strong) LLSearchView *searchView;
@property (nonatomic, strong) LLSearchSuggestionVC *searchSuggestVC;

@end

@implementation LLSearchResultViewController

- (NSMutableArray *)searchArray
{
    if (!_searchArray) {
        self.searchArray = [NSMutableArray array];
    }
    return _searchArray;
}


- (LLSearchResultView *)resultView
{
    if (!_resultView) {
        self.resultView = [[LLSearchResultView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) dataSource:self.searchArray];
    }
    return _resultView;
}


- (LLSearchView *)searchView
{
    if (!_searchView) {
        self.searchView = [[LLSearchView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 0) hotArray:self.hotArray historyArray:self.historyArray];

        __weak LLSearchResultViewController *weakSelf = self;
        _searchView.backgroundColor = [UIColor whiteColor];
        _searchView.tapAction = ^(NSString *str) {
            [weakSelf setSearchResultWithStr:str];
        };
    }
    return _searchView;
}

- (LLSearchSuggestionVC *)searchSuggestVC
{
    if (!_searchSuggestVC) {
        self.searchSuggestVC = [[LLSearchSuggestionVC alloc] init];
        _searchSuggestVC.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 0);
        _searchSuggestVC.view.hidden = YES;
        __weak LLSearchResultViewController *weakSelf = self;
        _searchSuggestVC.searchBlock = ^(HomeGoodModel *model) {

            GoodDetailViewController *vc = [[GoodDetailViewController alloc]initWithTableViewStyleGrouped];
            vc.goodModel = model;
            [weakSelf.navigationController pushViewController:vc animated:true];
        };
    }
    return _searchSuggestVC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBarButtonItem];
    [self.view addSubview:self.resultView];
    [self.view addSubview:self.searchSuggestVC.view];
    [self.view addSubview:self.searchView];
//    [self.view bringSubviewToFront:_searchView];
}

- (void)setBarButtonItem
{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    UIImage *img = [UIImage imageNamed:@"new_back"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 13, 17);
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(presentVCFirstBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bbiBack = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 40)];
    
    self.searchBar = [[MySearchBar alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(_titleView.frame)-10, 40)];
    _searchBar.text = _searchStr;

    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor blackColor];
    
    UITextField *searchTextField = searchTextField = [self.searchBar valueForKey:@"_searchField"];
    searchTextField.backgroundColor = [UIColor colorFromHexString:@"F2F2F3"];
    searchTextField.placeholder = @"请输入您要搜索的产品";
    
//    [self.searchBar setImage:[UIImage imageNamed:@"sort_magnifier"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_titleView addSubview:_searchBar];
    [_searchBar becomeFirstResponder];
    self.navigationItem.titleView = _titleView;
    self.navigationItem.leftBarButtonItem = bbiBack;

    
}


- (UIBarButtonItem *)setRightBarItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.selected = NO;
    rightBtn.frame = CGRectMake(14, 7, 30, 30);
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
//    [rightBtn setImage:[UIImage imageNamed:@"icon_wangge"] forState:UIControlStateNormal];
    [rightBtn setTitle:@"取消" forState:0];
    [rightBtn setTintColor:[UIColor blackColor]];
    [rightBtn addTarget:self action:@selector(rightBtnItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    return rightBtnItem;
}

- (void)rightBtnItemAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"nav_list_single"] forState:UIControlStateNormal];
        [_resultView refreshResultViewWithIsDouble:NO];
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_wangge"] forState:UIControlStateNormal];
        [_resultView refreshResultViewWithIsDouble:YES];
    }
}


- (void)cancelDidClick
{
    NSLog(@"cancelDidClick");
    
    [_searchBar resignFirstResponder];
//    [self.view bringSubviewToFront:_searchView];
}

- (void)presentVCFirstBackClick:(UIButton *)sender
{
    [_searchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)setSearchResultWithStr:(NSString *)str
{
    [self.searchBar resignFirstResponder];
    _searchBar.text = str;
    [_searchView removeFromSuperview];
    _searchSuggestVC.view.hidden = NO;
    [self.view bringSubviewToFront:_searchSuggestVC.view];
    [_searchSuggestVC searchTestChangeWithTest:str];
//    _searchSuggestVC.view.hidden = YES;
}


#pragma mark -  UISearchBarDelegate  -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
    _activity = !_activity;
    if (_activity) {
        self.navigationItem.rightBarButtonItem = nil;
        _titleView.frame = CGRectMake(0, 0, ScreenWidth-50, 40);
        _searchBar.frame = CGRectMake(10, 5, CGRectGetWidth(_titleView.frame)-10, 40);

//        searchBar.showsCancelButton = YES;
//        UIButton *cancleBtn = [_searchBar valueForKey:@"cancelButton"];
//        //修改标题和标题颜色
//        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return YES;
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//
//}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing-searchTest:%@",searchBar.text);
    if ([searchBar.text length] > 0) {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
//    NSLog(@"searchBarShouldEndEditing");
    self.navigationItem.rightBarButtonItem = _rightItem;
    _titleView.frame = CGRectMake(0, 0, ScreenWidth-50, 40);
    _searchBar.frame = CGRectMake(10, 5, CGRectGetWidth(_titleView.frame)-10, 40);
    searchBar.showsCancelButton = NO;
    _activity = NO;
    if (![searchBar.text length]) {
        _searchBar.text = _searchStr;
        [_searchView removeFromSuperview];
    };
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidEndEditing");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"textDidChange");
    
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        _searchSuggestVC.view.hidden = YES;
        [self.view addSubview:_searchView];
        [self.view bringSubviewToFront:_searchView];
    } else {
        _searchSuggestVC.view.hidden = NO;
        [self.view bringSubviewToFront:_searchSuggestVC.view];
        [_searchSuggestVC searchTestChangeWithTest:searchBar.text];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarCancelButtonClicked");
    [self.searchBar resignFirstResponder];
//    self.navigationItem.rightBarButtonItem = _rightItem;
    _titleView.frame = CGRectMake(0, 0, ScreenWidth-50, 40);
    _searchBar.frame = CGRectMake(10, 5, CGRectGetWidth(_titleView.frame)-10, 40);
    searchBar.showsCancelButton = NO;
    _activity = NO;
    [self.view bringSubviewToFront:_searchView];
    _searchSuggestVC.view.hidden = YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
//    [_searchView removeFromSuperview];
    [searchBar resignFirstResponder];
//    [self setSearchResultWithStr:searchBar.text];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
