//
//  CZResultViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CZResultViewController.h"
#import "CZRecordListViewController.h"

@interface CZResultViewController ()

@end

@implementation CZResultViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
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
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.title = @"支付结果";
    
    _leftButton.layer.masksToBounds =YES;
    _leftButton.layer.cornerRadius = 3;
    
    _rightButton.layer.masksToBounds =YES;
    _rightButton.layer.cornerRadius = 3;
    
    _buttonWidth.constant = (FullScreen.size.width - 50)/2;
    
    NSString * warnStr = [NSString stringWithFormat:@"恭喜您，获得<color1>%.0f</color1>小米",_allMoney];

    if (_coinType) {
        warnStr = [NSString stringWithFormat:@"恭喜您，获得<color1>%.0f</color1>小米",_allMoney * BeanExchangeRate];
    }
    
    _titleLabel.textColor = [UIColor blackColor];
    NSDictionary* style = @{@"body":[UIFont systemFontOfSize:13],
                            @"color1":[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]};
    _titleLabel.attributedText = [warnStr attributedStringWithStyleBook:style];
    
    
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

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickGoBackButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickSeeRecordButtonAction:(id)sender
{
    CZRecordListViewController *vc = [[CZRecordListViewController alloc]initWithNibName:@"CZRecordListViewController" bundle:nil];
    
    vc.title = @"小米充值记录";
    if (_coinType) {
        vc.isThrice = YES;
        vc.title = @"小米记录";
    }
//     
    [self.navigationController pushViewController:vc animated:YES];
}

@end
