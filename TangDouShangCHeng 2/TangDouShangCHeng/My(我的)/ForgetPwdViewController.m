//
//  ForgetPwdViewController.m
//  YiDaMerchant
//
//  Created by linqsh on 15/10/7.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()
{
    NSTimer *timer;
    NSInteger remainTime;
    
    BOOL _keyboardIsVisible;
}

@end

@implementation ForgetPwdViewController

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
    
    _codeButton.layer.masksToBounds =YES;
    _codeButton.layer.cornerRadius = 5;
    _codeButton.layer.borderColor = [[UIColor colorFromHexString:@"5ad485"] CGColor];
    _codeButton.layer.borderWidth = 1.0f;
    
    _commitButton.layer.masksToBounds =YES;
    _commitButton.layer.cornerRadius = 10;
    
    if(_isFindPwd)
    {
        _phoneText.placeholder = @"请输入您的手机号";
    }else{
        _phoneText.placeholder = @"请输入手机号(微信版本上绑定的手机号)";
    }
    [_phoneText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [_pwdText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [_pwdAginText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdAginText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    [_codeText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
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
    
    __weak ForgetPwdViewController *weakSelf = self;
    // 1、注册 2、绑定公众号、找回密码 3、第三方授权登录
    [HttpHelper getVerificationCodeByMobile:phoneStr
                                   type:@"2"
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

- (void)httpFindPwd
{
    if ( _phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    if (![Tool validateMobile:_phoneText.text]) {
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
    if (![_pwdText.text isEqualToString:_pwdAginText.text]) {
        [Tool showPromptContent:@"两次输入的密码不一致" onView:self.view];
        return;
    }
    if (_pwdText.text.length < 6 || _pwdText.text.length > 30 ) {
        
        [Tool showPromptContent:@"密码由6-30位数字或字母组成" onView:self.view];
        return;
    }
    
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中...";
    __weak ForgetPwdViewController *weakSelf = self;
    [HttpHelper findPwdByWithMobile:_phoneText.text
                       password:_pwdText.text
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
    [Tool showPromptContent:@"操作成功" onView:self.view];
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
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

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [self httpFindPwd];
}
@end
