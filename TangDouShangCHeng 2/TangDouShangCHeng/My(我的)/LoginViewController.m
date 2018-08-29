//
//  LoginViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//


#import "LoginViewController.h"
#import "ForgetPwdViewController.h"
#import "ResigterViewController.h"
#import "BangdingViewController.h"
#import <TKAlert&TKActionSheet/TKAlert&TKActionSheet.h>
#import "JMWhenTapped.h"

@interface LoginViewController ()<UINavigationControllerDelegate,ResigterViewControllerDelegate>{
    BOOL kanClick;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.title = @"登陆";
    [self initVariable];
    [self leftNavigationItem];
    kanClick = YES;
    _pwdText.layer.masksToBounds = YES;
    _pwdText.layer.cornerRadius = 25;
    _pwdText.layer.borderColor = [UIColor grayColor].CGColor;
    _pwdText.layer.borderWidth = 1;
    [_pwdText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 25;
    
    _phoneText.layer.masksToBounds = YES;
    _phoneText.layer.cornerRadius = 25;
    _phoneText.layer.borderColor = [UIColor grayColor].CGColor;
    _phoneText.layer.borderWidth = 1;
    [_phoneText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneText setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    [_bgImageView whenTapped:^{
     __weak LoginViewController *weakSelf = self;
        [weakSelf.pwdText resignFirstResponder];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];

    if ([ShareManager shareInstance].userinfo.app_login_id.length > 0  && ![[ShareManager shareInstance].userinfo.app_login_id isEqualToString:@"<null>"]) {
        _phoneText.text = [ShareManager shareInstance].userinfo.app_login_id;
    }else{
        _phoneText.text = @"";
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    if (userID.length > 1) {
        NSString *loginHistory = [userID stringByAppendingString:@"_loginHistory"];
        NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:loginHistory];
        if ([value boolValue] == NO) {
            //            [self performSelector:@selector(showVoucher) withObject:nil afterDelay:1];
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:loginHistory];
        }
    }
    
}

- (void)initVariable
{
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIColor whiteColor],
//                                NSForegroundColorAttributeName, nil];
//
//    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    _loginButton.layer.masksToBounds =YES;
    _loginButton.layer.cornerRadius = 5;
     _thirdLoginView.hidden = YES;
    
//    if ([[ShareManager shareInstance].isShowThird isEqualToString:@"y"]) {
//
//
//        if (([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) || ([QQApiInterface isQQInstalled] &&[QQApiInterface isQQSupportApi]))
//        {
//            _thirdLoginView.hidden = NO;
//
//            if (![WXApi isWXAppInstalled] || ![WXApi isWXAppSupportApi])
//            {
//                _weixinLoginButton.hidden = YES;
//            }
//            if (![QQApiInterface isQQInstalled] || ![QQApiInterface isQQSupportApi])
//            {
//                _qqLoginButton.hidden = YES;
//            }
//        }else{
//            _thirdLoginView.hidden = YES;
//        }
//        //隐藏微信登陆
//        _weixinLoginButton.hidden = YES;
//    }else{
//        _thirdLoginView.hidden = YES;
//    }

    
}


- (void)leftNavigationItem
{
   
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"new_back"] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftItemAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor grayColor];
    
    
}


- (void)rightItemView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"免费注册" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItemAction:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorFromHexString:@"5ad485"];
    return;
    }
- (IBAction)registerClick:(id)sender {
    ResigterViewController *vc = [[ResigterViewController alloc]initWithNibName:@"ResigterViewController" bundle:nil];
    vc.delegate = self;

//     
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    if ([Tool islogin]||[ShareManager shareInstance].isInReview) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [Tool showPromptContent:@"请登陆" onView:[UIApplication sharedApplication].keyWindow];
    }
   
}


- (void)clickRightItemAction:(id)sender
{
   
    ResigterViewController *vc = [[ResigterViewController alloc]initWithNibName:@"ResigterViewController" bundle:nil];
    vc.delegate = self;
    
    
//     
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)resitgterBtnClick:(id)sender {
    
    ResigterViewController *vc = [[ResigterViewController alloc]initWithNibName:@"ResigterViewController" bundle:nil];
    vc.delegate = self;
    
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickLoginButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    if (kanClick) {
        kanClick = NO;
        [self httpLogin];
    }else{
        MLog(@"clickLoginButtonAction");
    }
}


- (IBAction)clickFindPwdButtonAction:(id)sender
{
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]initWithNibName:@"ForgetPwdViewController" bundle:nil];
    vc.title = @"找回密码";
    vc.isFindPwd = YES;
   
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickQQLoginButtonAction:(id)sender
{
    
  
    [ShareSDK authorize:SSDKPlatformTypeQQ
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self httpOtherLoginWithId:user.uid
                                  band_type:@"qq"
                                  nick_name:user.nickname
                                 user_photo:user.icon];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [Tool showPromptContent:@"授权失败" onView:self.view];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
    
   }

- (IBAction)clickWeiXinLoginButtonAction:(id)sender
{
   
    [ShareSDK authorize:SSDKPlatformTypeWechat
               settings:nil
         onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         MLog(@"state>>>%luuser>>>>%@",(unsigned long)state,user.uid);
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [self httpOtherLoginWithId:user.uid
                                  band_type:@"weixin"
                                  nick_name:user.nickname
                                 user_photo:user.icon];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [Tool showPromptContent:@"授权失败" onView:self.view];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
    
   
  
}



#pragma mark http

- (void)httpLogin
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
    
    if (_pwdText.text.length < 1) {
        [Tool showPromptContent:@"请输入密码" onView:self.view];
        return;
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    
    __weak LoginViewController *weakSelf = self;
    [HttpHelper loginByWithMobile:_phoneText.text
                     password:_pwdText.text
                     jpush_id:[CloudPushSDK getDeviceId]
                      success:^(NSDictionary *resultDic){
                          [HUD hide:YES];
                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                              MLog(@"LoginresultDic>>>>>%@",resultDic);
                              [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
                          }else
                          {
                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:weakSelf.view];
                              self->kanClick = YES;
                          }
                          
                      }fail:^(NSString *decretion){
                          [HUD hide:YES];
                          [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                          self->kanClick = YES;
                      }];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic

{
    MLog(@"resultDic%@",resultDic);
    //登录成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
    
    UserInfo *info = [resultDic objectByClass:[UserInfo class]];
    info.loginPassword = self.pwdText.text;
    [ShareManager shareInstance].userinfo = info;
    [[NSUserDefaults standardUserDefaults] setObject:_phoneText.text forKey:@"userPhone"];
    [[NSUserDefaults standardUserDefaults] setObject:_pwdText.text forKey:@"pwd"];
    [Tool httpAddressList];
    [Tool saveUserInfoToDB:YES];
        [Tool showPromptContent:@"登录成功" onView:self.view];
    kanClick = YES;
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
    
}

//第三方登录
- (void)httpOtherLoginWithId:(NSString *)band_id
                   band_type:(NSString *)band_type
                   nick_name:(NSString *)nick_name
                  user_photo:(NSString *)user_photo
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"登录中...";
    
    __weak LoginViewController *weakSelf = self;
    [HttpHelper thirdloginByWithLoginId:band_id
                          nick_name:nick_name
                        user_header:user_photo
                               type:band_type
                           jpush_id:[CloudPushSDK getDeviceId]
                            success:^(NSDictionary *resultDic){
                                [HUD hide:YES];
                                if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                    [weakSelf handleloadOtherLoginResult:[resultDic objectForKey:@"data"]];
                                }else
                                {
                                    [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:weakSelf.view];
                                }
                            }fail:^(NSString *decretion){
                                [HUD hide:YES];
                                [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
                            }];
    
}

- (void)handleloadOtherLoginResult:(NSDictionary *)resultDic
{
    UserInfo *info = [ShareManager shareInstance].userinfo;
    if (info.user_tel.length >0 && ![info.user_tel isEqualToString:@"<null>"]) {
        //登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:nil];
        [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
    }
    else{
        [Tool saveUserInfoToDB:NO];
        BangdingViewController *vc = [[BangdingViewController alloc]initWithNibName:@"BangdingViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -

- (void)resigterSuccess:(NSString *)account
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage) {
         [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
        [UINavigationBar appearance].translucent = NO;

    }
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
}

-(void)dealloc{

}

@end
