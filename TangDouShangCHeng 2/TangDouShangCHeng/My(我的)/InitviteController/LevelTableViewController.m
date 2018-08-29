//
//  LevelTableViewController.m
//  DuoBao
//
//  Created by clove on 12/17/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "LevelTableViewController.h"

@interface LevelTableViewController ()
@property (nonatomic, copy) NSArray *levelDescriptionArray;
@property (nonatomic, copy) NSArray *requestArray;

@end

@implementation LevelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"等级特权";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    NSArray *array = @[
                       @"1+",
                       @"100+",
                       @"200+",
                       @"500+",
                       @"1000+",
                       @"2000+",
                       @"5000+"
                       ];
    _requestArray = array;
    
    array = @[
              @"等级1的用户获得一级提成1%\n二级提成1%",
              @"等级2的用户获得一级提成1.5%\n二级提成1%",
              @"等级3的用户获得一级提成2%\n二级好友1%",
              @"等级4的用户获得一级提成3%\n二级好友1%",
              @"等级5的用户获得一级提成4%\n二级好友1%",
              @"等级6的用户获得一级提成6%\n二级好友1%",
              @"等级7的用户获得一级提成8%\n二级好友2%"
              ];
    
    _levelDescriptionArray = array;
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setLeftBarButtonItemArrow];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
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

- (int)calculateLevelWithFriendsNumber:(int)number
{
    NSArray *array = @[
                       @"100+",
                       @"200+",
                       @"500+",
                       @"1000+",
                       @"2000+",
                       @"5000+"
                       ];
    
    int level = 1;
    
    for (int i=0; i<array.count; i++) {
        NSString *str = [array objectAtIndex:i];
        int numberRequered = [str intValue];
        if (number < numberRequered) {
            level = i+1;
            break;
        }
        
        if (i==5) {
            level = 7;
        }
    }
    
    return level;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFriendsNumber:(int)friendsNumber
{
    _friendsNumber = friendsNumber;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger number = 1;
    if (section == 1) number = 7;
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        [cell.contentView addSubview:[self myLevelView]];
    } else {
        
        NSString *imageStr = [NSString stringWithFormat:@"v%ld", indexPath.row+1];
        UIImage *defaultImage = PublicImage(imageStr);
//        cell.imageView.image = defaultImage;
//        cell.textLabel.text = @"+13234132 \nsfafasdfada";
//        cell.textLabel.numberOfLines = 2;
//        cell.textLabel.font = [UIFont systemFontOfSize:17];
//        cell.detailTextLabel.text = @" \n2019-09-11";
//        cell.textLabel.numberOfLines = 2;
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage];
//        imageView.width = 50;
//        imageView.height = imageView.width;
        imageView.left = LeftMargin;
        imageView.centerY = [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2;
//        imageView.layer.cornerRadius = imageView.height/2;
//        imageView.layer.masksToBounds = YES;
//        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
        
        UIColor *color = [UIColor colorFromHexString:@"474747"];
        NSString *description = [_levelDescriptionArray objectAtIndex:indexPath.row];
        NSString *requestStr = [_requestArray objectAtIndex:indexPath.row];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right+8, 0, ScreenWidth-imageView.right-8-LeftMargin, height)];
        label.tag = 101;
        label.textColor = [UIColor colorFromHexString:@"474747"];
        label.text = description;
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, ScreenWidth-2*LeftMargin, height)];
        label.textColor = color;
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentRight;
        label.text = requestStr;
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    if (section == 1) height = 50;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    if (section == 0) height = 10;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 90;
    if (indexPath.section == 1) height = 80;
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;   // custom view for header. will be adjusted to default or specified header height
{
    UIView *view = [self sectionView];
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section;   // custom view for footer. will be adjusted to default or specified footer height
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    if (section == 0) {
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.height = 10;
        view.width = ScreenWidth;
        view.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
        [view addSingleBorder:UIViewBorderDirectBottom color:[UIColor defaultTableViewSeparationColor] width:0.5];
    }

    return view;
}

- (UIView *)myLevelView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
    
    NSURL *avatarURL = [UserInfo avatarURL];
    
    UIImage *defaultImage = PublicImage(@"default_head");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultImage];
    imageView.width = 50;
    imageView.height = 50;
    imageView.left = LeftMargin;
    imageView.centerY = view.height/2;
    [imageView sd_setImageWithURL:avatarURL placeholderImage:defaultImage];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.height/2;
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor colorFromHexString:@"474747"];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"用户ID：%@", [ShareManager userID]];
    [label sizeToFit];
    [view addSubview:label];
    UILabel *label1 = label;

    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor colorFromHexString:@"474747"];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"我的等级：";
    [label sizeToFit];
    [view addSubview:label];
    UILabel *label2 = label;

//    label1.height = 21;
    label1.bottom = imageView.centerY;
    label1.left = imageView.right + 10;
    
    label1.height = label.height;
    label2.top = label1.bottom;
    label2.left = label1.left;
    
    
    UIImage *image = [UIImage imageNamed:[self levelImageStr]];
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.centerY = label2.centerY;
    imageView.left = label2.right;
    [view addSubview:imageView];

//    label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.textColor = [UIColor colorFromHexString:@"474747"];
//    label.font = [UIFont systemFontOfSize:15];
//    label.text = @"我的等级:";
//    [label sizeToFit];
//    label.centerY = label2.centerY;
//    label.left = imageView.left;
//    [view addSubview:label];

    return view;
}

- (NSString *)levelImageStr
{
    int level = [self calculateLevelWithFriendsNumber:_friendsNumber];
    NSString *str = [NSString stringWithFormat:@"level%d", level];
    return str;
}

- (UIView *)sectionView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    UIColor *color = [UIColor colorFromHexString:@"8d8d8d"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, ScreenWidth-2*LeftMargin, 50)];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"等级特权";
    [view addSubview:label];

    label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, 0, ScreenWidth-2*LeftMargin, 50)];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"邀请人数";
    [view addSubview:label];

    return view;
}

@end
