//
//  ForgetPwdViewController.h
//  YiDaMerchant
//
//  Created by linqsh on 15/10/7.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPwdViewController : UIViewController

@property (assign, nonatomic) BOOL isFindPwd;

@property (weak, nonatomic) IBOutlet UIScrollView *myScorlleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *pwdText;
@property (weak, nonatomic) IBOutlet UITextField *pwdAginText;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

- (IBAction)clickCodeButton:(id)sender;
- (IBAction)clickCommitButton:(id)sender;

@end
