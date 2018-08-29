//
//  InviteViewController.m
//  DuoBao
//
//  Created by clove on 12/2/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "InviteViewController.h"
#import "Masonry.h"
#import "AHButton.h"
#import "IncomeTableViewController.h"
#import "EditTextFieldViewController.h"
#import "FriendsViewController.h"
#import "WithdrawViewController.h"
#import "LevelTableViewController.h"
#import "QRImageViewController.h"
#import "InviteModel.h"
#import "LookupInviteRuleTableViewController.h"

@interface InviteViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ruleButton;
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UIView *containerView3;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UILabel *remainderMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendNumberLabel;
@property (weak, nonatomic) IBOutlet AHButton *takeOutButton;
@property (weak, nonatomic) IBOutlet AHButton *lookFriendsButton;
@property (weak, nonatomic) IBOutlet AHButton *myEarningButton;
@property (weak, nonatomic) IBOutlet UIImageView *separationImageForEarning;
@property (weak, nonatomic) IBOutlet UIView *todayEarningContainerView;
@property (weak, nonatomic) IBOutlet UIView *amountEarningContainerView;
@property (weak, nonatomic) IBOutlet UILabel *todayEarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountEarningLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCst;

@property (nonatomic, strong) InviteModel *model;

@end

@implementation InviteViewController

- (void)loadView
{
    [super loadView];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat rate = screenWidth/375.0f;
//    UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
//    UIColor *orangeColor = [UIColor colorFromHexString:@"ff6c00"];
    
    AHButton *button = _takeOutButton;
//    [button setTitleColor:redColor forState:UIControlStateNormal];
//    [button setTitleColor:[redColor darkerColor] forState:UIControlStateSelected];
//    [button setCornerRadius:button.height/2 borderWidth:1 borderColor:redColor forState:UIControlStateNormal];
//    [button setCornerRadius:button.height/2 borderWidth:1 borderColor:[redColor darkerColor] forState:UIControlStateHighlighted];
//    [button setCornerRadius:button.height/2 borderWidth:1 borderColor:[redColor darkerColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(takeOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    button = _lookFriendsButton;
//    [button setTitleColor:orangeColor forState:UIControlStateNormal];
//    [button setTitleColor:[orangeColor darkerColor] forState:UIControlStateSelected];
//    [button setCornerRadius:button.height/2 borderWidth:1 borderColor:orangeColor forState:UIControlStateNormal];
//    [button setCornerRadius:button.height/2 borderWidth:1 borderColor:[orangeColor darkerColor] forState:UIControlStateSelected];
//    [button setCornerRadius:button.height/2 borderWidth:1 borderColor:[orangeColor darkerColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(lookFriendsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    button = _inviteButton;
//    button.backgroundColor = redColor;
    button.layer.cornerRadius = button.height/2;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(inviteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = _containerView3;
    float leftMargin =  [containerView viewWithTag:100].centerX;
    float margin = (screenWidth- 2*leftMargin)/3;
    for (int i=1; i<4; i++) {
        int tag = i+100;
        UIView *view = [containerView viewWithTag:tag];
        view.centerX = leftMargin + i*margin;
    }
    
    _separationImageForEarning.left *= rate;
    _todayEarningContainerView.left = _separationImageForEarning.right + 20;
    _amountEarningContainerView.left = (screenWidth - _separationImageForEarning.right)/2 + _separationImageForEarning.right;
    
    _ruleButton.width *= rate;
    _ruleButton.height *= rate;
    _ruleButton.left *= rate;
    _ruleButton.top *= rate;
    self.title = @"邀请好友";
}




- (void)viewDidLoad {
    [super viewDidLoad];
    __block typeof(self) weakself = self;
    [HttpHelper getInviteInfo:^(NSDictionary *resultDic) {
        
        NSDictionary *data = [resultDic objectForKey:@"data"];
        InviteModel *model = [data objectByClass:[InviteModel class]];
        weakself.model = model;
        [[ShareManager shareInstance] setInviteModel:model];
        
        [self reloadInterface];
    } fail:^(NSString *description) {
        
    }];
    
    [self setLeftBarButtonItemArrow];
//    [self setRightBarButtonItem];
    
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    //    _containerView.width = ScreenWidth;
    //    _scrollView.contentSize = _containerView.size;
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

- (void)setRightBarButtonItem
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(ruleButtonAction:)];
    backButton.title = @"查看规则";
    backButton.tintColor = UIColor.whiteColor;
    self.navigationItem.rightBarButtonItem = backButton;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadInterface];
    self.navigationController.navigationBar.hidden = NO;
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
 
    //    _scrollView.frame = CGRectMake(0, 64, ScreenWidth, [UIScreen mainScreen].bounds.size.height - 64);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    _containerView.size = CGSizeMake(ScreenWidth, [UIScreen mainScreen].bounds.size.height - 64);
    //    _scrollView.contentSize = _containerView.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _containerView.width = ScreenWidth;
    _scrollView.contentSize = CGSizeMake(ScreenWidth, _containerView.height + 1);
    _bottom.constant = [UIScreen mainScreen].bounds.size.height - 603;
    _widthCst.constant = ScreenWidth;
    _heightCst.constant = 603;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)reloadInterface
{
    InviteModel *model = _model;
    _remainderMoneyLabel.text = model.remainderMoney;
    _friendNumberLabel.text = model.friends_all;
    _todayEarningLabel.text = model.today_earnings;
    _amountEarningLabel.text = model.all_earnings;
}

#pragma mark -

#pragma mark - Action

- (void)takeOutButtonAction
{

    WithdrawViewController *vc = [[WithdrawViewController alloc] init];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)lookFriendsButtonAction
{

    FriendsViewController *vc = [[FriendsViewController alloc] init];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inviteButtonAction
{
    
    NSString *link = [Tool inviteFriendToRegisterAddress:[ShareManager userID]];
    NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"%@ - 米花糖，最甜的糖果分享予你", bundleDisplayName];
    NSString *description = [NSString stringWithFormat:@"1元就能买iphoneX、黄金、充值卡、电脑、零食等。万元商品带回家！我的推荐码:%@",[ShareManager shareInstance].userinfo.id];
    
    [Tool showShareActionSheet:self.view
                          text:description
                        images:nil
                           url:[NSURL URLWithString:link]
                         title:str
                          type:SSDKContentTypeText
                    completion:nil];
    
}

- (IBAction)ruleButtonAction:(id)sender {
    
    LookupInviteRuleTableViewController *vc = [[LookupInviteRuleTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)copyLinkAction:(id)sender {

    NSString *link = [Tool inviteFriendToRegisterAddress:[ShareManager userID]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = link;
    [Tool showPromptContent:@"复制成功"];
}

- (IBAction)QRCodeAction:(id)sender {

    QRImageViewController *vc = [[QRImageViewController alloc] init];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)levelAction:(id)sender {

    int number = [_model.friends_all intValue];
    LevelTableViewController *vc = [[LevelTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc setFriendsNumber:number];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)recommendPeopleAction:(id)sender {
    
    // 推荐人ID为空
    NSString *recommendUserID = [ShareManager shareInstance].userinfo.recommend_user_id;
    NSString *placeholder = @"请输入推荐人ID";
    if (recommendUserID.length > 0 && ![recommendUserID isEqualToString:@"<null>"]) {
        placeholder = [NSString stringWithFormat:@"您的推荐人ID是%@", recommendUserID];
    }
    
    NSString *myUserID = [NSString stringWithFormat:@"温馨提示：当您邀请好友时，请将自己的ID(%@)分享给您的朋友，以获取邀请收益。", [ShareManager userID]];
    
    EditTextFieldViewController *vc = [[EditTextFieldViewController alloc] initWithText:@"" placeholder:placeholder indicatorStringForHeader:myUserID completed:^(BOOL result, NSString *changedText) {
        
    }];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)myIncomeAction:(id)sender {
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    IncomeTableViewController *vc = [[IncomeTableViewController alloc] initWithTableViewStyleGrouped];
    [vc setAmountIncome:_model.all_earnings];
//     
    [self.navigationController pushViewController:vc animated:YES];
}


@end
