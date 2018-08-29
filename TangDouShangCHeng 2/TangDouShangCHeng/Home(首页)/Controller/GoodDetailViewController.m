//
//  GoodDetailViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "GoodDetialHaderCell.h"
#import "GetCouponOneCell.h"
#import "GetCouponViewController.h"
#import "EditOrderViewController.h"
#import "SafariViewController.h"


@interface GoodDetailViewController ()
{
    NSArray *scModel;
}
@end

@implementation GoodDetailViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    MLog(@"navigationBarHidden%@",self.navigationController);
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
//    [self setRightBarButtonItem:@"收藏"];
    [self setFootViewForPay];
    scModel = [NSArray array];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;

    MLog(@"viewDidLoad");
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-54);
}
#pragma mark - 实现rightBar点击方法
- (void)rightBarButtonItemAction:(id)sender
{
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    if(_goodModel){
        DataManager *dataMannger= [[DataManager alloc] init];
        scModel = [dataMannger fetchAllData];
        if (scModel.count>0) {
            if ([dataMannger isHasDataInTableWithModel:_goodModel]) {
                 [Tool showPromptContent:@"已收藏"];
            }else{
                [dataMannger insertDataWith:self.goodModel];
                return;
            }
            
        }else{
            [dataMannger insertDataWith:self.goodModel];
        }
    }
    
}
#pragma mark - 创建底部视图
-(void)setFootViewForPay{
    UIImageView *buyFooterView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, ScreenHeight-64-50, ScreenWidth, 50))];
    buyFooterView.userInteractionEnabled = YES;
//    buyFooterView.backgroundColor = [UIColor colorFromHexString:@"eefbf3"];
    buyFooterView.image = [UIImage imageNamed:@"nav"];
    //客服
//    UIButton *kfBtn = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, 90, 50))];
//    [kfBtn setImage:[UIImage imageNamed:@"icon_service"] forState:0];
//    kfBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [kfBtn setTitleColor:[UIColor blackColor] forState:0];
//    kfBtn.backgroundColor = [UIColor clearColor];
//    [kfBtn addTarget: self action:@selector(kfBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [buyFooterView addSubview:kfBtn];
    UIButton *addCarBtn = [[UIButton alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth/2, 50))];
    [addCarBtn setTitle:@"加入收藏" forState:0];
    [addCarBtn setTitleColor:[UIColor redColor] forState:0];
    addCarBtn.backgroundColor = [UIColor colorFromHexString:@"ebebeb"];
    [addCarBtn addTarget: self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [buyFooterView addSubview:addCarBtn];
    
    UIButton *goPayBtn = [[UIButton alloc]initWithFrame:(CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 50))];
    [goPayBtn setTitle:@"立即购买" forState:0];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:0];
    goPayBtn.backgroundColor = [UIColor clearColor];
    [goPayBtn addTarget: self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [buyFooterView addSubview:goPayBtn];
    [self.view addSubview:buyFooterView];
}

-(void)addShopCar{
    MLog(@"?????");
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    if(_goodModel){
        ShopManager *dataMannger= [[ShopManager alloc] init];
        scModel = [dataMannger fetchAllData];
        if (scModel.count>0) {
            if ([dataMannger isHasDataInTableWithModel:_goodModel]) {
                [Tool showPromptContent:@"已加入购物车"];
            }else{
                [dataMannger insertDataWith:self.goodModel];
                return;
            }
            
        }else{
            [dataMannger insertDataWith:self.goodModel];
        }
    }
}
#pragma mark -底部按钮点击事件
-(void)kfBtnClick{
    MLog(@"?????");
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
    chatViewConfig.navBarTintColor = [UIColor whiteColor];
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
//        [self.navigationController jxPopViewControllerAnimated:YES];
}

-(void)goPay{
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    if ([ShareManager shareInstance].isInReview == YES) {
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"b"];
      
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    
    
    EditOrderViewController *vc = [[EditOrderViewController alloc]initWithTableViewStyle:1];
    vc.goodModel = _goodModel;

    
    [self.navigationController pushViewController:vc animated:YES];
// [self.navigationController hh_pushViewController:vc style:AnimationStyleRippleEffect];

}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            GoodDetialHaderCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetialHaderCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodDetialHaderCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.goodModel = _goodModel;
            return cell;
        }
            break;
        case 1:
        {
            {
                GetCouponOneCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:@"GetCouponOneCell"];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GetCouponOneCell" owner:nil options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                cell.goodModel = _goodModel;
                cell.getCouponBtn.hidden = NO;
                [cell.getCouponBtn addTarget:self action:@selector(getCoupon) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
            break;
        default:
            return nil;
            break;
        }
            
            
    }
    
}

-(void)getCoupon{

    GetCouponViewController *vc = [[GetCouponViewController alloc]initWithTableViewStyle:0];
    vc.goodModel = _goodModel;
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
      return 10;
    }else{
        return 0.001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            return ScreenWidth+50;
        }
            break;
        case 1:
        {
            return 130;
        }
            break;
            
        default:
            return 0;
            break;
    }
    
}
@end
