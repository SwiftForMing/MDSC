//
//  ProfileTableViewController.m
//  DuoBao
//
//  Created by clove on 2/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "DuoBaoRecordViewController.h"
#import "ZJRecordViewController.h"
#import "ShaiDanViewController.h"
//#import "JFDHViewController.h"
#import "SafariViewController.h"
#import "UserInfoViewController.h"
//#import "CouponsViewController.h"
//#import "CZViewController.h"
#import "LoginViewController.h"
//#import "SettingViewController.h"
//#import "InviteViewController.h"
#import "RechargeThriceTableViewController.h"
#import "GetGoodListViewController.h"
#import "MQChatViewManager.h"
#import "MQChatDeviceUtil.h"
#import <MeiQiaSDK/MeiQiaSDK.h>
#import "NSArray+MQFunctional.h"
#import "MQBundleUtil.h"
#import "MQAssetUtil.h"
#import "MQImageUtil.h"
#import "BTBadgeView.h"

@interface ProfileTableViewController ()<UINavigationControllerDelegate>

@end

@implementation ProfileTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    UIButton *backBtn = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, 30, 30))];
    [backBtn setImage:[UIImage imageNamed:@"new_back"] forState:0];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
    self.tableView.contentInset = UIEdgeInsetsZero;
    
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    bgImage.image = [UIImage imageNamed:@"nav"];
//    self.tableView.backgroundView = bgImage;
    
}

-(void)back{    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [HttpHelper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id success:^(NSDictionary *resultDic) {
//
//    } fail:^(NSString *description) {
//
//    }];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUserInfoFromServer];
    self.navigationController.navigationBar.hidden = NO;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger num = 2;
    
    if (section == 0) {
        num = 1;
    }
    if (section == 3) {
        num = 1;
    }
   
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageName = @"";
    NSString *title = @"我的红包";
    NSString *detail = @"";
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                imageName = @"";
                title = [NSString stringWithFormat:@"小米：%d",(int)[ShareManager shareInstance].userinfo.user_money];
                
                detail = @"";
                
            }
        }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            imageName = @"";
            title = @"活动记录";
            detail = @"";
        }else if (indexPath.row == 1){
            imageName = @"";
            title = @"中奖记录";
            detail = @"";
        }
    }
    
//    if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            imageName = @"";
//            title = @"我的晒单";
//            detail = @"";
//        }
//    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0){
            imageName = @"";
            title = @"转让商品";
            detail = @"";
        }
        if (indexPath.row == 1){
            imageName = @"";
            title = @"转让小米";
            detail = @"";
        }
    }
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            imageName = @"";
            title = @"联系客服";
            detail = @"";}
        
    }
    
        cell.textLabel.text = title;
        cell.detailTextLabel.text = detail;
        cell.imageView.image = [UIImage imageNamed:imageName];
    
//        if (indexPath.section == 0) {
//            cell.accessoryType =  UITableViewCellAccessoryNone;
//        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }

        cell.textLabel.textColor = [UIColor colorFromHexString:@"474747"];
        cell.textLabel.font = [UIFont systemFontOfSize:16 * UIAdapteRate];
        //        cell.detailTextLabel.textColor = [UIColor colorFromHexString:@""];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14 * UIAdapteRate];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0.5;
    }
        return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        EntBuyViewController *vc = [[EntBuyViewController alloc]initWithTableViewStyle:1];
//         
    [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            DuoBaoRecordViewController *vc = [[DuoBaoRecordViewController alloc] initWithNibName:@"DuoBaoRecordViewController" bundle:nil];
            vc.type = @"myvc";
            [self.navigationController pushViewController:vc animated:YES ];
            
        } else if (indexPath.row == 1) {
            if (![Tool islogin]) {
                [Tool loginWithAnimated:YES viewController:nil];
                return;
            }
            ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
            vc.is_happybean_goods = @"0";
            vc.title = @"中奖记录";
//             
    [self.navigationController pushViewController:vc animated:YES ];
        }
        
    }
//    if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            if (![Tool islogin]) {
//                [Tool loginWithAnimated:YES viewController:nil];
//                return;
//            }
//            ShaiDanViewController *vc = [[ShaiDanViewController alloc] initWithNibName:@"ShaiDanViewController" bundle:nil];
//            vc.userId = [ShareManager shareInstance].userinfo.id;
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
//
//        }
//    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            GetGoodListViewController *vc = [[GetGoodListViewController alloc]init];
//             
    [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            ChangeJiFenViewController *vc = [[ChangeJiFenViewController alloc]initWithNibName:@"ChangeJiFenViewController" bundle:nil];
//             
           [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self messageAction];
        }
    }
    
    
    
}




- (void)voucherDismiss
{
    [self.tabBarController setSelectedIndex:3];
    [self couponAction];
}

//网络状态捕捉
- (void)checkNetworkStatus:(NSNotification *)notif
{
    NSDictionary *userInfo = [notif userInfo];
    if(userInfo)
    {
        [self httpUserInfo];
    }
}

#pragma mark -

- (void)couponAction
{
  
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
//    CouponsViewController *vc = [[CouponsViewController alloc]initWithNibName:@"CouponsViewController" bundle:nil];
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
}

- (void)inviteAction
{

    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
//    InviteViewController *vc = [[InviteViewController alloc]initWithNibName:@"InviteViewController" bundle:nil];
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
}

- (void)messageAction
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    userID = userID ? userID : @"";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"iOS %@", version];
    NSString *alias = [ShareManager shareInstance].userinfo.nick_name;
    NSString *telephone = userInfo.user_tel ?:@"";
    
    MQChatViewConfig *chatViewConfig = [MQChatViewConfig sharedConfig];
    
    MQChatViewController *chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    [chatViewConfig setEnableOutgoingAvatar:false];
    [chatViewConfig setEnableRoundAvatar:YES];
    chatViewConfig.navTitleColor = [UIColor whiteColor];
    chatViewConfig.navBarTintColor = [UIColor redColor];
    [chatViewConfig setStatusBarStyle:UIStatusBarStyleLightContent];
//    chatViewController.title = @"客服";
//    [chatViewConfig setNavTitleText:@"客服"];
    [chatViewConfig setCustomizedId:userID];
    [chatViewConfig setEnableEvaluationButton:NO];
//    [chatViewConfig setAgentName:@"客服"];
    [chatViewConfig setClientInfo:@{@"name":alias, @"version": versionString, @"identify": userID, @"telephone": telephone}];
    [chatViewConfig setUpdateClientInfoUseOverride:YES];
    [chatViewConfig setRecordMode:MQRecordModeDuckOther];
    [chatViewConfig setPlayMode:MQPlayModeMixWithOther];
    [self.navigationController pushViewController:chatViewController animated:YES];
//    
//    [self.navigationController pushViewController:chatViewController animated:YES transition:magicMove];
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    chatViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)clickLeftControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickLoginAction
{
    [Tool loginWithAnimated:YES viewController:nil];
}

#pragma mark -

- (void)httpUserInfo
{
    if (![ShareManager shareInstance].userinfo.islogin) {
        return;
    }
    [HttpHelper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                          success:^(NSDictionary *resultDic){
                              
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                              {
                                  NSDictionary *dict = [resultDic objectForKey:@"data"];
                                  UserInfo *info = [dict objectByClass:[UserInfo class]];
                                  info.user_agency = [ShareManager shareInstance].userinfo.user_agency;
                                  info.loginPassword = [ShareManager shareInstance].userinfo.loginPassword;
                                  [ShareManager shareInstance].userinfo = info;
                                  [Tool saveUserInfoToDB:YES];
//                                  [weakSelf updateUserInterface];
                                
                              }else{
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                              
                          }fail:^(NSString *decretion){
                              [Tool showPromptContent:@"网络出错了" onView:self.view];
                          }];
}

- (void)updateUserInfoFromServer
{
//    [self updateUserInterface];
    [self httpUserInfo];
    [self.tableView reloadData];
}

- (void)pushBettingRecordViewController:(NSDictionary *)dictionary
{
        if (![Tool islogin]) {
            [Tool loginWithAnimated:YES viewController:nil];
            return;
        }
        ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
         vc.is_happybean_goods = @"0";
         vc.title = @"中奖记录";
//         
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)pushWinLotteryViewController
{
    [self winRecordAction:nil];
}

- (void)winRecordAction:(id)sender {
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    ZJRecordViewController *vc = [[ZJRecordViewController alloc] initWithNibName:@"ZJRecordViewController" bundle:nil];
    vc.is_happybean_goods = @"0";
    vc.title = @"中奖记录";
//     
    [self.navigationController pushViewController:vc animated:YES];
}
@end
