//
//  WithdrawViewController.m
//  DuoBao
//
//  Created by clove on 12/14/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "WithdrawViewController.h"
#import "WithdrawMoneyTableViewController.h"
#import "WithdrawVirtualMoneyTableViewController.h"
#import "WithdrawRecordViewController.h"

@interface WithdrawViewController ()

@end

@implementation WithdrawViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"转出";
    
    WithdrawMoneyTableViewController *vc0 = [[WithdrawMoneyTableViewController alloc] initWithNibName:@"WithdrawMoneyTableViewController" bundle:nil];
    vc0.yp_tabItemTitle = @"转出到支付宝";

    WithdrawVirtualMoneyTableViewController *vc1 = [[WithdrawVirtualMoneyTableViewController alloc] initWithNibName:@"WithdrawVirtualMoneyTableViewController" bundle:nil];
    vc1.yp_tabItemTitle = @"转出到小米";

    self.viewControllers = @[vc1, vc0];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.tabBar.frame = CGRectMake(0, 0, screenSize.width, 44);
    self.contentViewFrame = CGRectMake(0, 44, screenSize.width, screenSize.height - 44 - 50);

    self.tabBar.itemTitleColor = [UIColor colorFromHexString:@"666666"];
    self.tabBar.itemTitleSelectedColor = [UIColor defaultRedColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    
    [self.tabBar setScrollEnabledAndItemWidth:screenSize.width/2];
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = [UIColor defaultRedColor];
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(42, 0, 0, 0) tapSwitchAnimated:NO];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    [self setRightBarButtonItem:@"转出记录"];
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

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemAction
{
    WithdrawRecordViewController *vc = [[WithdrawRecordViewController alloc] initWithTableViewStyleGrouped];
//     
    [self.navigationController pushViewController:vc animated:YES];
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
