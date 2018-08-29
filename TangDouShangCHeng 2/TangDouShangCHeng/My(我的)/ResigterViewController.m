//
//  ResigterViewController.m
//  YiDaMerchant
//
//  Created by linqsh on 15/10/7.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "ResigterViewController.h"
#import "SafariViewController.h"

@interface ResigterViewController ()
{
    BOOL isHasRecommender;
    BOOL isAgreement;
    
    NSTimer *timer;
    NSInteger remainTime;
    
    BOOL _keyboardIsVisible;
}

@end



@implementation ResigterViewController

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
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
     backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initVariable
{
    _bgViewWidth.constant = FullScreen.size.width;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"注册";
    
    //    _codeButton.layer.masksToBounds =YES;
    //    _codeButton.layer.cornerRadius = 5;
    //    _codeButton.layer.borderColor = [[UIColor redColor] CGColor];
    //    _codeButton.layer.borderWidth = 1.0f;
    [_pwdText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [_codeText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [_recommendCodeText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_recommendCodeText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [_phoneText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    _registerButton.layer.masksToBounds =YES;
    _registerButton.layer.cornerRadius = 22;
    
    isHasRecommender = YES;
    isAgreement = YES;
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    //    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
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
    HUD.labelText = @"获取验证码中...";
    
    __weak ResigterViewController *weakSelf = self;
    
    //type:[1.注册,2.找回密码,3.修改电话号码和微信绑定]
    [HttpHelper getVerificationCodeByMobile:phoneStr
                                   type:@"1"
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



- (void)httpResigter
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
    
    if (_codeText.text.length < 1) {
        [Tool showPromptContent:@"请输入验证码" onView:self.view];
        return;
    }
    
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请设置密码" onView:self.view];
        return;
    }
    
    
    if (_pwdText.text.length < 6 || _pwdText.text.length > 30) {
        [Tool showPromptContent:@"密码由6-30位数字或字母组成" onView:self.view];
        return;
    }
    
    NSString *recommendStr = _recommendCodeText.text;
    if (recommendStr.length < 1) {
        recommendStr = nil;
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"注册中...";
    

    __weak ResigterViewController *weakSelf = self;
    [HttpHelper registerByWithMobile:_phoneText.text
                        password:_pwdText.text
               recommend_user_id:recommendStr
                       auth_code:_codeText.text
                         success:^(NSDictionary *resultDic){
                             [HUD hide:YES];
                             if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                 [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
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
   
    [HttpHelper loginByWithMobile:_phoneText.text
                     password:_pwdText.text
                     jpush_id:[CloudPushSDK getDeviceId]
                      success:^(NSDictionary *resultDic){
                          UserInfo *info = [resultDic objectByClass:[UserInfo class]];
                          info.loginPassword = self.pwdText.text;
                          [ShareManager shareInstance].userinfo = info;
                        
                          [Tool httpAddressList];
                          [Tool saveUserInfoToDB:YES];
                          //登录成功通知
                          [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserInfo object:nil];
                      }fail:^(NSString *decretion){
                      }];
    
    [Tool showPromptContent:@"注册成功" onView:self.view];
    if([self.delegate respondsToSelector:@selector(resigterSuccess:)])
    {
        [self.delegate resigterSuccess:_phoneText.text];
    }
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}


#pragma mark - Action

- (IBAction)clickRegisterButton:(id)sender
{
    //    收起所有键盘
    [Tool hideAllKeyboard];
    
    if (!isAgreement) {
        [Tool showPromptContent:@"您未同意惠生惠社使用协议和禁售商品管理" onView:self.view];
        return;
    }
    
    [self httpResigter];
    
  
}

- (IBAction)clickCodeButton:(id)sender
{

    //收起所有键盘
    [Tool hideAllKeyboard];
    [self httGetVerificationCode];
}

- (void)clickLeftControlAction:(id)sender
{
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickFFXYButton:(id)sender
{
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"服务协议";
  
    vc.urlStr = [NSString stringWithFormat:@"%@%@id=6&is_show_message=y",URL_EntOneServer,Wap_AboutDuobao];
    MLog(@"urlStr%@",[NSString stringWithFormat:@"%@%@id=6&is_show_message=y",URL_EntOneServer,Wap_AboutDuobao]);
//     
    [self.navigationController pushViewController:vc animated:YES];
}

@end
