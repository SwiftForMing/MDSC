//
//  PaySuccessTableViewController.m
//  DuoBao
//
//  Created by clove on 4/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySuccessTableViewController.h"
#import "ServerProtocol.h"
#import "DuoBaoRecordViewController.h"
#import "HomePageViewController.h"

@interface PaySuccessTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (strong, nonatomic) IBOutlet UIView *payFailureView;
@property (weak, nonatomic) IBOutlet UIButton *payFailureButton;
@property (weak, nonatomic) IBOutlet UILabel *failureReasonLabel;

@end

@implementation PaySuccessTableViewController

- (void)dealloc
{
    MLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

+ (PaySuccessTableViewController *)createWithData:(NSDictionary *)dictionary
{
    PaySuccessTableViewController *vc = [[PaySuccessTableViewController alloc] initWithNibName:@"PaySuccessTableViewController" bundle:nil];
    vc.data = dictionary;
    
    
    NSString *result = [dictionary objectForKey:@"result"];
    NSString *title = @"活动成功";
    NSString *prompt = @"请等待系统为您揭晓";
    
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"timeout"]) {
        title = @"活动成功";
        prompt = @"请等待系统为您揭晓";
        
        int payCrowdfundingCoin = [[dictionary objectForKey:@"payCrowdfundingCoin"] intValue];
        int payThriceCoin = [[dictionary objectForKey:@"payThriceCoin"] intValue];
        
        [ShareManager shareInstance].userinfo.user_money -= payCrowdfundingCoin;
        [ShareManager shareInstance].userinfo.happy_bean_num -= payThriceCoin;
    }
    
    
    [Tool autoLoginSuccess:^(NSDictionary *success) {
        
    } fail:^(NSString *failure) {
    }];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"活动结果";
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    NSString *result = [_data objectForKey:@"result"];
    NSString *title = @"活动成功";
    NSString *prompt = @"请等待系统为您揭晓";
    
    if ([result isEqualToString:@"success"]) {
        title = @"活动成功";
        prompt = @"请等待系统为您揭晓";
       
    }
    
    
    if ([result isEqualToString:@"timeout"]) {
        title = @"活动成功";
        prompt = @"请到活动记录查看活动详情";
    }
    
    _promptLabel.text = prompt;
    
    if ([result isEqualToString:@"failure"]) {
        self.tableView.tableHeaderView = _payFailureView;
        
        //谷歌分析活动失败
      
        
        NSString *description = [_data objectForKey:@"description"];
        if (description) {
            _failureReasonLabel.text = description;
        }
    }
    
    [self leftNavigationItem];
    
    
    UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
    UIButton *button = _leftButton;
    button.layer.cornerRadius = button.height * 0.1;
    button.layer.borderWidth = 1;
    button.layer.borderColor = redColor.CGColor;
    
    button = _rightButton;
    button.layer.cornerRadius = button.height * 0.1;
    
    button = _payFailureButton;
    button.layer.cornerRadius = button.height * 0.1;
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
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

- (void)clickLeftItemAction:(id)sender
{
    [self leftButtonAction:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)dataArray:(NSDictionary *)dictionary
{
    NSMutableArray *array = [NSMutableArray array];
//    UIColor *darkColor = [UIColor colorFromHexString:@"474747"];
    UIColor *grayColor = [UIColor colorFromHexString:@"a3a3a3"];
    UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
    UIFont *font = [UIFont systemFontOfSize:12];
    UIFont *fontBig = [UIFont systemFontOfSize:16];
    
    

    int purchasedTimes = [[dictionary objectForKey:@"purchasedTimes"] intValue];
    int payCNY = [[dictionary objectForKey:@"payCNY"] intValue];
    int costedCrowdfundingCoin = [[dictionary objectForKey:@"costedCrowdfundingCoin"] intValue];

    
    int beas = [[dictionary objectForKey:@"purchasedTimes"] intValue]*[[dictionary objectForKey:@"price"] intValue];
    int jifen = [[dictionary objectForKey:@"pay_score"] intValue];
//    MLog(@"jifen%@",dictionary);
    // 共计
    NSString *str = [NSString stringWithFormat:@"共计:"];
    if (payCNY > 0) {
        str = [str stringByAppendingFormat:@"  %d元", payCNY];
    }
    if (costedCrowdfundingCoin > 0) {
//        str = [str stringByAppendingFormat:@"  %d小米", costedThriceCoin];
    }
    
    if (jifen>0) {
        beas -= jifen;
    }
    
    
    if (beas > 0) {
        str = [str stringByAppendingFormat:@"  %d小米", beas];
    }
    
    if(jifen>0){
         str = [str stringByAppendingFormat:@"  %d欢乐豆", jifen];
    }
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:fontBig}];
    NSDictionary *dict = @{@"title":attr1};
    [array addObject:dict];
    
    
    // 小米
    NSString *goosTitle = [ServerProtocol periodAndGoodsName:dictionary];
    NSString *detail = [NSString stringWithFormat:@"%d人次", purchasedTimes];
    attr1 = [[NSMutableAttributedString alloc] initWithString:goosTitle attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
    dict = @{@"title":attr1, @"detail":attr2};
    [array addObject:dict];
    
    
    // 小米
    NSString *title = nil;
    NSArray *thriceArray = [dictionary objectForKey:@"thriceArray"];
    for (NSDictionary *thriceDict in thriceArray) {
        NSString *type = [thriceDict objectForKey:@"type"];
        NSNumber *count = [thriceDict objectForKey:@"count"];
        
        if ([type hasPrefix:@"1"]) {
            type = @"147";
        }
        if ([type hasPrefix:@"2"]) {
            type = @"258";
        }
        if ([type hasPrefix:@"3"]) {
            type = @"369";
        }
        
        NSString *title = [NSString stringWithFormat:@"三赔玩法%@", type];
        detail = [NSString stringWithFormat:@"%@小米", count];
        attr1 = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
        attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:grayColor, NSFontAttributeName:font}];
        dict = @{@"title":attr1, @"detail":attr2};
        [array addObject:dict];
    }
    
    
    // 返回小米
    int unusedThriceCoint = [[dict objectForKey:@"unusedThriceCoint"] intValue];
    if (unusedThriceCoint > 0) {
        NSString *reason = [dict objectForKey:@"unusedCrowdfundingReason"];
        title = [NSString stringWithFormat:@"返回小米 %@", reason];
        detail = [NSString stringWithFormat:@"%d小米", unusedThriceCoint];
        
        attr1 = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        dict = @{@"title":attr1, @"detail":attr2};
        [array addObject:dict];
    }
    
    
    // 返回小米
    int unusedCrowdfunding = [[dict objectForKey:@"unusedCrowdfunding"] intValue];
    if (unusedCrowdfunding > 0) {
        title = [NSString stringWithFormat:@"返回小米 本期已结束"];
        detail = [NSString stringWithFormat:@"%d小米", unusedCrowdfunding];
        
        attr1 = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        attr2 = [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:redColor, NSFontAttributeName:font}];
        dict = @{@"title":attr1, @"detail":attr2};
        [array addObject:dict];
    }
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftButtonAction:(id)sender {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HomePageViewController class]]) {
//            EntTabBarViewController *vc =(EntTabBarViewController *)controller;
//            [self.navigationController popToViewController:vc animated:YES];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightButtonAction:(id)sender {
    
    DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc] initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
//     
    [self.navigationController pushViewController:vc animated:YES];
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    NSString *result = [_data objectForKey:@"result"];
    
    if ([result isEqualToString:@"success"]) {
        NSArray *array = [self dataArray:_data];
        number = array.count;
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    NSArray *array = [self dataArray:_data];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    NSAttributedString *title = [dict objectForKey:@"title"];
    NSAttributedString *detail = [dict objectForKey:@"detail"];
    
    cell.textLabel.text = @" ";
    
    CGFloat height = 22;
    CGFloat width = ScreenWidth - 30* 2 - 80;
    if (indexPath.row == 0) {
        height = 31;
        width = 300;
    }
    
    
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(30, 0, width, height)];
    lblTitle.attributedText = title;
    [cell.contentView addSubview:lblTitle];
    
    lblTitle= [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, height)];
    lblTitle.attributedText = detail;
    lblTitle.right = ScreenWidth - 30;
    lblTitle.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:lblTitle];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 22;
    if (indexPath.row == 0) {
        height = 31;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    NSString *result = [_data objectForKey:@"result"];
    
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"timeout"]) {
        height = 100;
    }
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    UIView *view = nil;
    
    NSString *result = [_data objectForKey:@"result"];
    
    if ([result isEqualToString:@"success"] || [result isEqualToString:@"timeout"]) {
        
        view = _tableFooterView;
    }
    
    return view;
}


@end

