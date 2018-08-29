
//
//  CardIntroduceViewController.m
//  DuoBao
//
//  Created by clove on 11/12/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "CardIntroduceViewController.h"

@interface CardIntroduceViewController ()

@end

@implementation CardIntroduceViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self leftNavigationItem];
    self.title = @"使用说明";
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

}



- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _textView.text = @"您收到卡密信息后请不要透露给第三方，请尽快充值成手机话费。\n\n您可以通过如下方式使用话费充值卡：\n\n收到卡密后直接进行充值操作如果遇到问题，请不要着急，请根据充值失败提示再操作，或者拨打相关运营商的服务电话进行询问；卡密发出后，卡密使用时间在发送时间之后一概不会退款。\n\n1. 中国移动充值卡充值话费方法：\n\n充值话费请拨打10086或者13800138000根据语音提示选择充值卡充值。如果本机欠费，请选择其它移动（必须和你欠费的手机归属地一致）手机充值。\n\n2. 中国联通话费充值卡充值话费方法：\n\n充值话费请拨打10011根据语音提示选择充值卡充值。如果本机欠费，请选择其它联通（必须和你欠费的手机归属地一致）手机充值。\n\n3. 中国电信话费充值卡充值话费方法：\n\n使用本机拨打11888输入18位密码充值，如果手机已欠费停机无法拨通11888时请用同省其他手机、座机为其代充。卡号只做备查使用，充值不需要输入卡号。";
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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
