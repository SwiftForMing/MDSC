//
//  NewMyViewController.m
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/4/20.
//  Copyright © 2018年 黎应明. All rights reserved.
//

#import "NewMyViewController.h"
#import "MyHeaderView.h"
#import "ClassifyTableViewCell.h"
#import "UserInfoViewController.h"
#import "MyOrderListViewController.h"
#import "EntBuyViewController.h"
#import "EntHomeViewController.h"
//#import "WHCScrollVC.h"
#import "GetGoodListViewController.h"
#import "MallCollectionViewController.h"
#import "HomePageViewController.h"
#import "InviteViewController.h"
#import "CouponViewController.h"
#import "EntHomeViewController.h"
#import "ShoppingCarVC.h"
@interface NewMyViewController ()<BaseTableViewDelegate>
@property (nonatomic, strong) MyHeaderView *headerView;
@end

@implementation NewMyViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.hidden = YES;
    [self httpUserInfo];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self hidenLeftBarButton];
    self.tableView.frame = CGRectMake(0, -20, ScreenWidth, ScreenHeight);
    MyHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MyHeaderView" owner:nil options:nil] firstObject];
    headerView.width = ScreenWidth;
    headerView.height = 300;
    _headerView = headerView;
    [_headerView whenTapped:^{
        [self profileAction];
    }];
    [_headerView.headImage whenTapped:^{
        if ([Tool islogin]) {
            [self profileAction];
            return ;
        }
        [self loginClick];
    }];
    
    self.tableView.tableHeaderView = _headerView;
    
    self.numOfSection = 2;
}

-(void)loginClick{
    [Tool loginWithAnimated:YES viewController:nil];
}

- (void)profileAction
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    UserInfoViewController *vc = [[UserInfoViewController alloc]initWithNibName:@"UserInfoViewController" bundle:nil];
     [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
}


#pragma mark - notif Action

- (void)registerNotif
{
    /**
     *  监听网络状态变化
     */
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(checkNetworkStatus:)
    //                                                 name:kReachableNetworkStatusChange
    //                                               object:nil];
    
    //刷新首页数据
    //    [[NSNotificationCenter defaultCenter]addObserver:self
    //                                            selector:@selector(quitLoginReload)
    //                                                name:kQuitLoginSuccess
    //                                              object:nil];
    
    
    //我的tab点击事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUserInfoFromServer)
                                                name:kLoginSuccess
                                              object:nil];
    
}

- (void)updateUserInfoFromServer
{
    [self httpUserInfo];
}

- (void)httpUserInfo
{
    if (![Tool islogin]) {
        return;
    }
    __weak NewMyViewController *weakSelf = self;
    [HttpHelper getUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                              success:^(NSDictionary *resultDic){
                                  
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                                  {
                                   
                                      [weakSelf handleloadUserInfoResult:[resultDic objectForKey:@"data"]];
                                  }else{
                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                  }
                                  
                              }fail:^(NSString *decretion){
                                  [Tool showPromptContent:@"网络出错了" onView:self.view];
                              }];
}

- (void)handleloadUserInfoResult:(NSDictionary *)resultDic
{
    MLog(@"handleloadUserInfoResult%@",resultDic);
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    [ShareManager shareInstance].userinfo = info;
    [Tool saveUserInfoToDB:YES];
    _headerView.userInfo = info;
    [self.tableView reloadData];
}


//tableViewDeteglate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        if ([[ShareManager shareInstance] isInReview])
        {
            return 4;
        }else{
            return 5;
        }
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndentifier=@"cell";
    
    ClassifyTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil)
    {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"ClassifyTableViewCell" owner:self options:nil]  firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if (Tool.islogin){
                    cell.desLabel.text = [NSString stringWithFormat:@"小米：%0.0f",[ShareManager shareInstance].userinfo.user_money];
                }else{
                    cell.desLabel.text = [NSString stringWithFormat:@"小米：0"];
                }
                cell.rightImage.image = [UIImage imageNamed:@""];
                break;
            case 1:
                cell.desLabel.text = @"米豆商城";
                break;
            case 3:
                if([[ShareManager shareInstance] isInReview]){
                    cell.desLabel.text = @"我的购物车";
                }else{
                    cell.desLabel.text = @"转让商品";
                    
                }
                break;
            case 2:
                if([[ShareManager shareInstance] isInReview]){
                    cell.desLabel.text = @"我的收藏";
                }else{
                    cell.desLabel.text = @"转让小米";
                    
                }
                break;
            case 4:
                cell.desLabel.text = @"我的优惠券";
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:
                cell.desLabel.text = @"联系客服";
                break;
        }
    }
    
    return cell;
}
- (void)clickLeftControlAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if (![ShareManager shareInstance].userinfo.islogin) {
                    [Tool loginWithAnimated:YES viewController:nil];
                    return;
                }
            }
                break;
            case 1:
            {
                MallCollectionViewController *vc = [[MallCollectionViewController alloc] initWithNibName:@"MallCollectionViewController" bundle:nil];
                 [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
            }
                break;
            case 2:
            {
                if ([[ShareManager shareInstance] isInReview]) {
                    NewShopCollectViewController *vc = [[NewShopCollectViewController alloc]init];
//                     
//                    [self.navigationController pushViewController:vc animated:YES];
                     [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
                }else{
                    ChangeJiFenViewController *vc = [[ChangeJiFenViewController alloc]initWithNibName:@"ChangeJiFenViewController" bundle:nil];
//                     
//                    [self.navigationController pushViewController:vc animated:YES];
                     [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
                }
            }
                break;
                
            case 3:
            {
                if ([[ShareManager shareInstance] isInReview]) {
                    ShoppingCarVC *vc = [[ShoppingCarVC alloc] init];
//                     
//                    [self.navigationController pushViewController:vc animated:YES];
                     [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
                }else{
                GetGoodListViewController *vc = [[GetGoodListViewController alloc]init];

                   [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];
                }
            }
                break;
            case 4:
            {
                CouponViewController *couponVC = [[CouponViewController alloc]initWithTableViewStyle:1];
//                [self.navigationController pushViewController:couponVC animated:YES];
                [self.navigationController hh_pushViewController:couponVC style:AnimationStyleRippleEffect];
            }
                break;
            default:
                break;
        }
    }else{
        switch (indexPath.row) {
            case 0:{
                if (![ShareManager shareInstance].userinfo.islogin) {
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
                //                NSString *mqID = [userID stringByAppendingFormat:@"_%@", alias];
                MQChatViewConfig *chatViewConfig = [MQChatViewConfig sharedConfig];
                
                MQChatViewController *chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
                [chatViewConfig setEnableOutgoingAvatar:false];
                [chatViewConfig setEnableRoundAvatar:YES];
                chatViewConfig.navTitleColor = [UIColor whiteColor];
                chatViewConfig.navBarTintColor = [UIColor whiteColor];
                [chatViewConfig setStatusBarStyle:UIStatusBarStyleLightContent];
                
                
//                chatViewController.title = @"客服";
//                [chatViewConfig setNavTitleText:@"客服"];
                [chatViewConfig setCustomizedId:userID];
                [chatViewConfig setEnableEvaluationButton:NO];
//                [chatViewConfig setAgentName:@"客服"];
                [chatViewConfig setClientInfo:@{@"name":alias, @"version": versionString, @"identify": userID, @"telephone": telephone}];
                [chatViewConfig setUpdateClientInfoUseOverride:YES];
                [chatViewConfig setRecordMode:MQRecordModeDuckOther];
                [chatViewConfig setPlayMode:MQPlayModeMixWithOther];
//                [self.navigationController pushViewController:chatViewController animated:YES];
                [self.navigationController hh_pushViewController:chatViewController style:AnimationStyleRippleEffect];

                UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
                [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
                back.image = [UIImage imageNamed:@"new_back"];
                [leftItemControl addSubview:back];
                
                chatViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
            }
                break;
                
            default:
                break;
                
        }
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, 5))];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }else{
        return 0.001;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
    
}

@end
