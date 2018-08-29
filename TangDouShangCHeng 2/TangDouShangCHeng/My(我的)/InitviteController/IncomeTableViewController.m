//
//  IncomeTableViewController.m
//  DuoBao
//
//  Created by clove on 12/17/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "IncomeTableViewController.h"

@interface IncomeTableViewController ()

@end

@implementation IncomeTableViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收益";
    
    [self initRefreshTopView];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    [self refreshTopStartAnimating];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAmountIncome:(NSString *)amountIncome
{
    float value = [amountIncome floatValue];
    _amountIncome = [NSString stringWithFormat:@"%.2f", value];
    [self.tableView reloadData];
}

- (UIView *)tableHeaderView
{
    float width = self.tableView.width;
    
    UIImage *image = [UIImage imageNamed:@"myincome_banner"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, width * (image.size.height/image.size.width))];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [view addSubview:imageView];
    imageView.frame = view.bounds;
    
    UIColor *color = [UIColor colorFromHexString:@"fb6165"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    label.centerY = 52 * UIAdapteRate;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:29];
    label.text = _amountIncome?:@"";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    color = [UIColor colorFromHexString:@"fd9d9f"];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    label.centerY = 88 * UIAdapteRate;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"累计收益(元)";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];

    return view;
}

- (UIView *)sectionHeaderView:(CGFloat)height
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, height)];

    float width = self.tableView.width;
    
    UIImage *image = [UIImage imageNamed:@"daily_earning"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.centerY = view.height/2;
    imageView.left = LeftMargin;
    [view addSubview:imageView];
    
    UIColor *color = [UIColor colorFromHexString:@"474747"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right + 2, 0, width, view.height)];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"每日收益(元)";
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    
    return view;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIndentifier=@"cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dict = [self.listArray objectAtIndex:indexPath.row];
    NSString *todayIncome = [dict objectForKey:@"todays_earning"];
    NSString *timeStr = [dict objectForKey:@"days"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"+%@", todayIncome?:@""];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor colorFromHexString:@"474747"];
    cell.detailTextLabel.text = timeStr?:@"";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor colorFromHexString:@"a3a3a3"];

    return cell;
 }

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
    return [self sectionHeaderView:[self tableView:tableView heightForHeaderInSection:section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 44;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 72;
    return height;
}

#pragma mark - RefreshControlDelegate

- (void)refreshTopStartAnimating
{
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.pageNumber];
    NSString *countPerPageStr = [NSString stringWithFormat:@"%d", self.countPerPage];
    
    
//    HttpHelper *helper = [HttpHelper helper];
    __weak typeof(self) weakself = self;
    
    [HttpHelper getEarningHistoryByDays:pageNumber
                               limitNum:countPerPageStr
                                success:^(NSDictionary *resultDic){
                                    
                                    NSDictionary *data = [resultDic objectForKey:@"data"];
                                    NSArray *array = [data objectForKey:@"EarningByDaysList"];
                                    NSMutableArray *listArray = [NSMutableArray array];
                                    for (NSDictionary *dict in array) {
                                        [listArray addObject:dict];
                                    }
                                    
                                    [weakself reloadListArray:listArray];
                                }fail:^(NSString *decretion){
                                    
                                    [weakself refreshStopAnimatingTop];
                                }];
}

- (void)refreshBottomStartAnimating
{
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.pageNumber];
    NSString *countPerPageStr = [NSString stringWithFormat:@"%d", self.countPerPage];
    
    __weak typeof(self) weakself = self;
    
    [HttpHelper getEarningHistoryByDays:pageNumber
                               limitNum:countPerPageStr
                                success:^(NSDictionary *resultDic){
                                    
                                    NSDictionary *data = [resultDic objectForKey:@"data"];
                                    NSArray *array = [data objectForKey:@"EarningByDaysList"];
                                    NSMutableArray *listArray = [NSMutableArray array];
                                    for (NSDictionary *dict in array) {
                                        [listArray addObject:dict];
                                    }
                                    
                                    [weakself appendListArray:listArray];
                                }fail:^(NSString *decretion){
                                    
                                    [weakself refreshStopAnimatingBottom];
                                }];
}



@end
