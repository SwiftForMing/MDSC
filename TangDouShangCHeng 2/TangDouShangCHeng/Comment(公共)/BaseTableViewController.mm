//
//  LuxyTableViewController.m
//  Luxy
//
//  Created by justin on 3/2/15.
//  Copyright (c) 2015 robyzhou. All rights reserved.
//

#import "BaseTableViewController.h"
#import "RHRefreshControlConfiguration.h"
#import "RHRefreshControlViewCustom.h"
#import "RHRefreshControlViewWithoutIcon.h"
#import "RHRefreshControlViewPinterest.h"

@interface BaseTableViewController ()<RHRefreshControlDelegate>
{
    void ((^scrollToTopBlock)(UIScrollView *scrollView));
}
@property (nonatomic, strong) UIView *moreBannerBottom;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIImageView *noMoreContentPromptImageView;
@property (nonatomic, strong) UILabel *noMoreContentPromptLabel;
@property (nonatomic) BOOL isBottomAnimating;
@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic) BOOL enableBottomRefresh;

@end

@implementation BaseTableViewController

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTableView];
    }
    return self;
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style {
    self = [super init];
    if (self) {
        _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:style];
    }
    return self;
}

- (instancetype)initWithTableViewStyleGrouped {
    return [self initWithTableViewStyle:UITableViewStyleGrouped];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = YES;
//    self.view.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
    
    self.pageNumber = 1;    // 从1开始
    self.countPerPage = 30;
   
    [_tableView setFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = UIColorFromRGB(0xe8e8e8);
    _tableView.delaysContentTouches = NO;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
//    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
//    self.navigationController.navigationBar.hidden = NO;
    for (UIView *currentView in _tableView.subviews)
    {
        if([currentView isKindOfClass:[UIScrollView class]])
        {
            ((UIScrollView *)currentView).delaysContentTouches = NO;
            break;
        }
    }
    
    [_tableView reloadData];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    bgImage.image = [UIImage imageNamed:@"nav"];
//    self.tableView.backgroundView = bgImage;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)setupTableView {
    _tableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
}

- (void)scrollViewDidScrollToTopBlock:(void (^)(UIScrollView *scrollView))block {
    scrollToTopBlock = block;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_numOfSection) {
        return _numOfSection;
    }else{
    
        return 1;
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UIScrollView *scrollView = self.tableView;
    float maxOffset = scrollView.contentSize.height - (scrollView.bounds.size.height + scrollView.contentInset.bottom+scrollView.contentInset.top) - _moreBannerBottom.size.height;
    
    if (maxOffset <= 0 && self.tableView.tableFooterView != nil) {
        self.tableView.tableFooterView = nil;
    }
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_hightForFooter) {
        return _hightForFooter;
    }else{
        
        return 0.1;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma mark - TableView ScrollView

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshControl refreshScrollViewDidEndDragging:scrollView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_refreshControl refreshScrollViewDidScroll:scrollView];
    
    float maxOffset = scrollView.contentSize.height - (scrollView.bounds.size.height + scrollView.contentInset.bottom+scrollView.contentInset.top) - _moreBannerBottom.size.height;
    if (scrollView.contentOffset.y > maxOffset && scrollView.contentSize.height > scrollView.bounds.size.height - 1 && maxOffset > 0) {
        if ([self isAnimating] == NO && _isExtinct == NO && self.isLoading == NO) {
            [self startAnimating];
        }
    }
    
    if (_scrollViewDelegate != nil && [_scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (_scrollViewDelegate != nil && [_scrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_scrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (scrollToTopBlock) {
        scrollToTopBlock(scrollView);
    }
}

#pragma mark - RefreshControlDelegate

- (void)refreshTopStartAnimating
{
    
}

- (void)refreshBottomStartAnimating
{
    
}

- (void)refreshStopAnimatingTop
{
    self.loading = NO;
    [self.refreshControl refreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)refreshStopAnimatingBottom
{
    _isBottomAnimating = NO;
    [_activityIndicatorView stopAnimating];
    _noMoreContentPromptImageView.hidden = YES;
    _noMoreContentPromptLabel.hidden = YES;
    [_tableView flashScrollIndicators];
}

#pragma mark - RHRefreshControlDelegate

- (void)refreshDidTriggerRefresh:(RHRefreshControl *)refreshControl
{
    self.loading = YES;
    [self resetBottomLoading];
    [self refreshTopStartAnimating];
}

- (BOOL)refreshDataSourceIsLoading:(RHRefreshControl *)refreshControl {
    return self.isLoading; // should return if data source model is reloading
}

#pragma mark -

- (void)initRefreshTopViewDefault
{
    RHRefreshControlConfiguration *refreshConfiguration = [[RHRefreshControlConfiguration alloc] init];
    refreshConfiguration.refreshView = [[RHRefreshControlViewCustom alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60) style:RefreshControlStyleDark];
    
    _refreshControl = [[RHRefreshControl alloc] initWithConfiguration:refreshConfiguration];
    _refreshControl.delegate = self;
    [_refreshControl attachToScrollView:self.tableView];
}

- (void)initRefreshTopView
{
    RHRefreshControlConfiguration *refreshConfiguration = [[RHRefreshControlConfiguration alloc] init];
    refreshConfiguration.refreshView = [[RHRefreshControlViewCustom alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60) style:RefreshControlStyleLight];
    
    _refreshControl = [[RHRefreshControl alloc] initWithConfiguration:refreshConfiguration];
    _refreshControl.delegate = self;
    [_refreshControl attachToScrollView:self.tableView];
}

- (void)initRefreshTopViewWithoutIcon
{
    RHRefreshControlConfiguration *refreshConfiguration = [[RHRefreshControlConfiguration alloc] init];
    refreshConfiguration.refreshView = [[RHRefreshControlViewWithoutIcon alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 60)];
    //    refreshConfiguration.minimumForStart = @0;
    //   refreshConfiguration.maximumForPull = @60;
    
    _refreshControl = [[RHRefreshControl alloc] initWithConfiguration:refreshConfiguration];
    _refreshControl.delegate = self;
    [_refreshControl attachToScrollView:self.tableView];
}

- (void)setBottomRefreshStyleWithGrayBackground
{
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    _noMoreContentPromptLabel.textColor = UIColorFromRGBA(0x1d1d1d, 1);
    _noMoreContentPromptLabel.shadowColor = UIColorFromRGBA(0xFFFFFF, 0.1);
    _noMoreContentPromptLabel.shadowOffset = CGSizeMake(0, 1);
    _moreBannerBottom.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"moment_topbg"]];
}

- (void)setBottomOpaque:(BOOL)opaque
{
    _moreBannerBottom.hidden = opaque;
}

- (void)initMoreBannerBottom
{
    _moreBannerBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 64.0f)];
    _moreBannerBottom.backgroundColor = [UIColor clearColor];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.center = CGPointMake(_moreBannerBottom.bounds.size.width/2, _moreBannerBottom.size.height/2.0);
    [_moreBannerBottom addSubview:_activityIndicatorView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"not_more_likelist_prompt_image"]];
    imageView.center = CGPointMake(_moreBannerBottom.bounds.size.width/2.0, _moreBannerBottom.bounds.size.height/2.0);
    imageView.hidden = YES;
    _noMoreContentPromptImageView = imageView;
    
    _noMoreContentPromptLabel = [[UILabel alloc] initWithFrame:_moreBannerBottom.bounds];
    _noMoreContentPromptLabel.text = @"NO MORE";
    _noMoreContentPromptLabel.font = [UIFont boldSystemFontOfSize:17];
    _noMoreContentPromptLabel.textColor = UIColorFromRGB(0xf7f7f7);
    _noMoreContentPromptLabel.hidden = YES;
    _noMoreContentPromptLabel.textAlignment = NSTextAlignmentCenter;
    [_moreBannerBottom addSubview:_noMoreContentPromptLabel];
}

- (void)setRefreshTopUnenabled
{
    [_refreshControl removeRefreshView];
}

- (void)refreshBottomEnabled:(BOOL)enabled
{
    if (enabled) {
        _tableView.tableFooterView = _moreBannerBottom;
    } else {
        _tableView.tableFooterView = nil;
    }
    
    _enableBottomRefresh = enabled;
}

- (void)autoRefreshTop
{
    if (_refreshControl.state != RHRefreshStateLoading) {
        [_refreshControl refreshControlAutoloading];
        [self refreshTopStartAnimating];
    }
}

- (void)startAnimating
{
    if (_isBottomAnimating == NO) {
        if (_enableBottomRefresh == YES) {
            if (_tableView.tableFooterView == nil) {
                _tableView.tableFooterView = _moreBannerBottom;
            }
        }
        
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
        _noMoreContentPromptImageView.hidden = YES;
        _noMoreContentPromptLabel.hidden = YES;
        _isBottomAnimating = YES;
        
        [self refreshBottomStartAnimating];
    }
}

- (BOOL)isAnimating
{
    return _isBottomAnimating;
}

- (void)extinctBottomLoading
{
    _isExtinct = YES;
    _isBottomAnimating = NO;
    _noMoreContentPromptImageView.hidden = NO;
    _activityIndicatorView.hidden = YES;
    _noMoreContentPromptLabel.hidden = NO;
    
    if (self.tableView.contentSize.height < self.tableView.height) {
        _noMoreContentPromptImageView.hidden = YES;
        _noMoreContentPromptLabel.hidden = YES;
    }
}

- (void)resetBottomLoading
{
    _isExtinct = NO;
    // _isBottomAnimating = NO;
    _noMoreContentPromptImageView.hidden = YES;
    _noMoreContentPromptLabel.hidden = YES;
    _activityIndicatorView.hidden = YES;
}

- (UIView *)footerViewWithTitle:(NSString *)title
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    UIButton *button = [self createButtonWithLeftMargin:16 top:20 height:40 title:title];
    [view addSubview:button];
    
    return view;
}

- (UIButton *)createButtonWithLeftMargin:(CGFloat)left top:(CGFloat)top height:(CGFloat)height title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.height = height;
    button.width =  [UIScreen mainScreen].bounds.size.width - 2*left;
    button.left = left;
    button.top = top;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2;
    button.backgroundColor = [UIColor redColor];
   
    [button addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)footerButtonAction
{
    
    
    
    
    
}

- (void)reloadListArray:(NSArray *)array
{
    _pageNumber = 1;
    self.listArray = nil;
    if (array != nil) {
        [self.listArray addObjectsFromArray:array];
    }

    // did extinct
    if (array.count < _countPerPage) {
        
        [self extinctBottomLoading];
    }
    
    _pageNumber++;
    [self refreshStopAnimatingTop];
    [self.tableView reloadData];
}

- (void)appendListArray:(NSArray *)array
{
    _pageNumber++;
    if (array != nil) {
        [self.listArray addObjectsFromArray:array];
    }

    // did extinct
    if (array.count < _countPerPage) {
        
        [self extinctBottomLoading];
    }
    
    [self refreshStopAnimatingBottom];
    
    if (array.count > 0) {
        [self.tableView reloadData];
    }
}

- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [[NSMutableArray alloc] init];
    }
    
    return _listArray;
}



@end
