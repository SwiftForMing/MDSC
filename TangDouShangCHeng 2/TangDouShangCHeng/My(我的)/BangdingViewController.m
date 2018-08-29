//
//  BangdingViewController.m
//  YCSH
//
//  Created by linqsh on 16/1/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "BangdingViewController.h"

@interface BangdingViewController ()
{
    NSTimer *timer;
    NSInteger remainTime;
    
    BOOL _keyboardIsVisible;
}

@end

@implementation BangdingViewController

- (void)dealloc {
    if (timer) {
        //关闭定时器
        [timer invalidate];
        timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    if (timer) {
        //关闭定时器
        [timer setFireDate:[NSDate distantFuture]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"绑定手机";
    _bgViewWidth.constant = FullScreen.size.width;
    _bgViewHeight.constant = FullScreen.size.height-64;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _codeButton.layer.masksToBounds =YES;
    _codeButton.layer.cornerRadius = 5;
    _codeButton.layer.borderColor = [[UIColor colorFromHexString:@"5ad485"]CGColor];
    _codeButton.layer.borderWidth = 1.0f;
    
    _commitButton.layer.masksToBounds =YES;
    _commitButton.layer.cornerRadius = _commitButton.frame.size.height/2;
    
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}



#pragma mark - Http


- (void)httGetVerificationCode
{
    NSString *phoneStr = _phoneText.text;
    if (!phoneStr || phoneStr.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    if(![Tool validateMobile:phoneStr])
    {
        [Tool showPromptContent:@"请输入合法的手机号" onView:self.view];
        return;
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    __weak BangdingViewController *weakSelf = self;
    // 1、注册 2、绑定公众号、找回密码 3、第三方授权登录
    [HttpHelper getVerificationCodeByMobile:phoneStr
                                   type:@"3"
                                success:^(NSDictionary *resultDic){
                                    [HUD hide:YES];
                                    if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                        [Tool showPromptContent:@"验证码正在发送至您的手机" onView:self.view];
                                        remainTime = kTimeValue;
                                        [weakSelf handleTimer];
                                        
                                    }else
                                    {
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }
                                }fail:^(NSString *decretion){
                                    [HUD hide:YES];
                                    [Tool showPromptContent:@"网络出错了" onView:self.view];
                                }];
    
}

- (void)httpUpdateUserInfo
{
    if ( _phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    
    if(![Tool validateMobile:_phoneText.text] )
    {
        [Tool showPromptContent:@"请输入正确手机号" onView:self.view];
        return;
    }
    
    NSString *typeStr = nil;
    NSString *appIdStr = nil;
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    if (userInfo.qq_login_id.length > 0 && ![userInfo.qq_login_id isEqualToString:@"<null>"])
    {
        typeStr = @"qq";
        appIdStr = userInfo.qq_login_id;
        
    }else{
        typeStr = @"weixin";
        appIdStr = userInfo.weixin_login_id;
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"绑定中...";
    
    __weak BangdingViewController *weakSelf = self;
    [HttpHelper bangDingByWithLoginId:appIdStr
                             type:typeStr
                          url_tel:_phoneText.text
                        auth_code:_codeText.text
                recommend_user_id:_recommendCodeText.text
                          success:^(NSDictionary *resultDic){
                              [HUD hide:YES];
                              if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                  [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
                                  MLog(@"[resultDic objectForKey]%@",[resultDic objectForKey:@"data"]);
                              }else
                              {
                                  [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                              }
                              
                          }fail:^(NSString *decretion){
                              [HUD hide:YES];
                              [Tool showPromptContent:@"网络出错了" onView:self.view];
                          }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"绑定成功" onView:self.view];
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    [ShareManager shareInstance].token = resultDic[@"token"];
    [ShareManager shareInstance].userinfo = info;
    MLog(@"userid%@",[ShareManager shareInstance].userinfo.id);
    [Tool saveUserInfoToDB:YES];
    
    //登录成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
    [self performSelector:@selector(showHomePage) withObject:nil afterDelay:1.5];
}

- (void)showHomePage
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 获取验证码是button的ui变化

- (void)handleTimer
{
    if (remainTime == kTimeValue)
    {
        if (!timer)
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(handleTimer)
                                                   userInfo:nil
                                                    repeats:YES];
        }
        
        remainTime = kTimeValue;
        [self updateButtonTitleWithTime:remainTime];
        _codeButton.userInteractionEnabled = NO;
        remainTime--;
    }
    else if (remainTime >= 0)
    {
        [self updateButtonTitleWithTime:remainTime];
        remainTime--;
    }
    else
    {
        [timer invalidate];
        timer = nil;
        [self updateButtonTitleWithTime:remainTime];
        _codeButton.userInteractionEnabled = YES;
    }
}

- (void)updateButtonTitleWithTime:(NSInteger)time
{
    if (time > 0)
    {
        NSString *title = [NSString stringWithFormat:@"%@%ld秒", @"等待:",(long)time];
        
        [_codeButton setTitle:title forState:UIControlStateNormal];
        [_codeButton setTitle:title forState:UIControlStateHighlighted];
    }
    else
    {
        [_codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_codeButton setTitle:@"重新获取" forState:UIControlStateHighlighted];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要取消绑定吗？无绑定将无法登录哦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)clickDissMissViewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickCodeButton:(id)sender
{
    //收起所有键盘
    [Tool hideAllKeyboard];
    [self httGetVerificationCode];
    
}
- (IBAction)clickCommitButton:(id)sender
{
    //收起所有键盘
    [Tool hideAllKeyboard];
    
    [self httpUpdateUserInfo];
}



@end
