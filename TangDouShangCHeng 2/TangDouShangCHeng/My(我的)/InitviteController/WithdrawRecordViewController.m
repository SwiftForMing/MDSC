//
//  WithdrawRecordViewController.m
//  DuoBao
//
//  Created by clove on 12/20/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "WithdrawRecordViewController.h"

@interface WithdrawRecordViewController ()

@end

@implementation WithdrawRecordViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"转出记录";
    
    [self initRefreshTopView];

    self.tableView.backgroundColor = [UIColor whiteColor];
    [self refreshTopStartAnimating];

    [self setLeftBarButtonItemArrow];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

}

- (void)setLeftBarButtonItemArrow
{
    if (self.navigationController == nil) {
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        UIColor *color_a3a3a3 = [UIColor colorFromHexString:@"a3a3a3"];
        UIColor *color_474747 = [UIColor colorFromHexString:@"474747"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
        imageView.width = 40;
        imageView.height = imageView.width;
        imageView.left = LeftMargin;
        imageView.centerY = [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2;
        imageView.layer.cornerRadius = imageView.height/2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        // 转出金额
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor colorFromHexString:@"474747"];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"-0";
        [label sizeToFit];
        label.width = 300;
        label.left = imageView.right + 10;
        label.bottom = height/2+2;
        [cell.contentView addSubview:label];
        label.tag = 101;
        
        // 转出方式
        float left = label.left;
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor colorFromHexString:@"a3a3a3"];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"转出";
        [label sizeToFit];
        label.width = 300;
        label.left = left;
        label.top = height/2 + 4;
        [cell.contentView addSubview:label];
        label.tag = 102;

        // 状态
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor colorFromHexString:@"a3a3a3"];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        label.width = 45;
        label.height = height;
        label.right = ScreenWidth - LeftMargin;
        [cell.contentView addSubview:label];
        label.tag = 104;

        // 时间
        float margin = 30 * UIAdapteRate;
        float right = label.left - margin;
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor colorFromHexString:@"a3a3a3"];
        label.width = 200;
        label.height = height;
        label.right = right;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        label.tag = 103;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [cell.contentView viewWithTag:100];
    UILabel *withdrawNumberLabel = [cell.contentView viewWithTag:101];
    UILabel *typeLabel = [cell.contentView viewWithTag:102];
    UILabel *timeLabel = [cell.contentView viewWithTag:103];
    UILabel *statusLabel = [cell.contentView viewWithTag:104];
    
    NSDictionary *dict = [self.listArray objectAtIndex:indexPath.row];
    NSString *pay_earning = [dict objectForKey:@"pay_earning"];
    NSString *exchange_type = [dict objectForKey:@"exchange_type"];
    NSString *status = [dict objectForKey:@"status"];
    NSString *timeStr = [dict objectForKey:@"create_time"];

    NSString *withdrawString = [NSString stringWithFormat:@"-%@", pay_earning];
    NSString *time = [[timeStr componentsSeparatedByString:@" "] firstObject];
    time = time ?: timeStr;
    
    // 转出类型
    NSString *typeStr = @"转出到支付宝";
    UIImage *image = [UIImage imageNamed:@"alipay_icon_circle"];
    if ([exchange_type isEqualToString:@"virtual"]) {
        typeStr = @"转出到夺宝币";
        image = [UIImage imageNamed:@"duobaobi_icon"];
    }
    
    UIColor *statusColor = [UIColor colorFromHexString:@"a3a3a3"];   // 成功状态颜色
    if ([status isEqualToString:@"失败"]) {
        statusColor = [UIColor colorFromHexString:@"e6322c"];
    } else if ([status isEqualToString:@"审核中"]) {
        statusColor = [UIColor colorFromHexString:@"ff6c00"];
    }
    
    imageView.image = image;
    withdrawNumberLabel.text = withdrawString;
    typeLabel.text = typeStr;
    timeLabel.text = time;
    statusLabel.text = status;
    statusLabel.textColor = statusColor;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 72;
    return height;
}


#pragma mark - 

- (UIView *)sectionHeaderView:(CGFloat)height
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, height)];
    
    float width = self.tableView.width;
    
    UIColor *color = [UIColor colorFromHexString:@"474747"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, width, view.height)];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"交易金额(元)";
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];

    label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, 45, view.height)];
    label.right = ScreenWidth - LeftMargin;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"状态";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    UILabel *previousLabel = label;
    
    float margin = 30 * UIAdapteRate;
    label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, width, view.height)];
    label.right = previousLabel.left - margin;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"时间";
    label.textAlignment = NSTextAlignmentRight;
    [view addSubview:label];
    
    return view;
}

#pragma mark - RefreshControlDelegate

- (void)refreshTopStartAnimating
{
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.pageNumber];
    NSString *countPerPageStr = [NSString stringWithFormat:@"%d", self.countPerPage];
    
    __weak typeof(self) weakself = self;
    
    [HttpHelper getExchangeEarningHistory:pageNumber
                           limitNum:countPerPageStr
                            success:^(NSDictionary *resultDic){
                                
                                NSDictionary *data = [resultDic objectForKey:@"data"];
                                NSArray *array = [data objectForKey:@"exchangeEarningList"];
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
    
    [HttpHelper getExchangeEarningHistory:pageNumber
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
