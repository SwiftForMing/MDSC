//
//  LoginViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIView *thirdLoginView;

@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *weixinLoginButton;


- (IBAction)clickLoginButtonAction:(id)sender;

- (IBAction)clickFindPwdButtonAction:(id)sender;
- (IBAction)clickQQLoginButtonAction:(id)sender;
- (IBAction)clickWeiXinLoginButtonAction:(id)sender;
@end
