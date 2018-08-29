//
//  BuyGoodsListViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/23.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ContactTableViewController.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    
//    self.pageNumber = 0;
//    self.countPerPage = 30;
    
    [super viewDidLoad];
    
    [self initRefreshTopView];

    self.tableView.backgroundColor = [UIColor whiteColor];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

//    [self refreshTopStartAnimating];
//    [self autoRefreshTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.listArray.count == 0) {
        [self refreshTopStartAnimating];
    }
}

- (void)setFriendLevel:(int)friendLevel
{
    _friendLevel = friendLevel;
    self.pageNumber = 0;
    self.countPerPage = 30;
    
//    [self refreshTopStartAnimating];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = self.listArray.count;
    return number;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *defaultImage = PublicImage(@"default_head");
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage];
        imageView.width = 50;
        imageView.height = imageView.width;
        imageView.left = LeftMargin;
        imageView.centerY = [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2;
        imageView.layer.cornerRadius = imageView.height/2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+8, 0, ScreenWidth-imageView.right-8-LeftMargin, height)];
        label.tag = 101;
        label.textColor = [UIColor colorWithHexString:@"474747"];
        [cell.contentView addSubview:label];
    }
    
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *imageView = [cell.contentView viewWithTag:100];
    UILabel *label = [cell.contentView viewWithTag:101];
    
    UserInfo *userInfo = [self.listArray objectAtIndex:indexPath.row];
    NSURL *url = [userInfo avatarURL];
    [imageView sd_setImageWithURL:url placeholderImage:PublicImage(@"default_head")];
    
    label.text = [NSString stringWithFormat:@"%@==>%@",[userInfo nick_name],userInfo.id];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    UserInfo *userInfo = [self.listArray objectAtIndex:indexPath.row];
//    UserViewController *vc = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
//    vc.userId = userInfo.id;
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];

}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    
    if (section == 0) {
        [view addSingleBorder:UIViewBorderDirectTop color:[UIColor defaultTableViewSeparationColor] width:0.5f];
    }
    
    return view;
}

#pragma mark - RefreshControlDelegate

- (void)refreshTopStartAnimating
{
    self.pageNumber = 1;
    
    NSString *userID = [ShareManager userID];
    NSString *level = [NSString stringWithFormat:@"%d", _friendLevel];
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.pageNumber];
    NSString *countPerPageStr = [NSString stringWithFormat:@"%d", self.countPerPage];
    
//    HttpHelper *helper = [HttpHelper helper];
    __weak typeof(self) weakself = self;
    
    [HttpHelper getFriendsByLevelWithUserId:userID
                                  level:level
                                pageNum:pageNumber
                               limitNum:countPerPageStr
                                success:^(NSDictionary *resultDic){
                                    
                                    NSDictionary *data = [resultDic objectForKey:@"data"];
                                    NSArray *array = [data objectForKey:@"friendsList"];
                                    NSMutableArray *listArray = [NSMutableArray array];
                                    for (NSDictionary *dict in array) {
                                        UserInfo *userInfo = [dict objectByClass:[UserInfo class]];
                                        [listArray addObject:userInfo];
                                    }
                                    
                                    [weakself reloadListArray:listArray];
                                }fail:^(NSString *decretion){
                                    
                                    [weakself refreshStopAnimatingTop];
                                }];
}

- (void)refreshBottomStartAnimating
{
    NSString *userID = [ShareManager userID];
    NSString *level = [NSString stringWithFormat:@"%d", _friendLevel];
    NSString *pageNumber = [NSString stringWithFormat:@"%d", self.pageNumber];
    NSString *countPerPageStr = [NSString stringWithFormat:@"%d", self.countPerPage];
    
    __weak typeof(self) weakself = self;
    
    [HttpHelper getFriendsByLevelWithUserId:userID
                                  level:level
                                pageNum:pageNumber
                               limitNum:countPerPageStr
                                success:^(NSDictionary *resultDic){
                                    
                                    NSDictionary *data = [resultDic objectForKey:@"data"];
                                    NSArray *array = [data objectForKey:@"friendsList"];
                                    NSMutableArray *listArray = [NSMutableArray array];
                                    for (NSDictionary *dict in array) {
                                        UserInfo *userInfo = [dict objectByClass:[UserInfo class]];
                                        [listArray addObject:userInfo];
                                    }
                                    
                                    [weakself appendListArray:listArray];
                                }fail:^(NSString *decretion){
                                    
                                    [weakself refreshStopAnimatingBottom];
                                }];
}

@end
