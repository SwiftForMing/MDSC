//
//  ResigterViewController.h
//  YiDaMerchant
//
//  Created by linqsh on 15/10/7.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResigterViewControllerDelegate <NSObject>
@optional
- (void)resigterSuccess:(NSString *)account;

@end


@interface ResigterViewController : UIViewController

@property (nonatomic, assign) id<ResigterViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *myScorlleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerViewBottom;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *codeText;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (weak, nonatomic) IBOutlet UITextField *pwdText;

@property (weak, nonatomic) IBOutlet UITextField *recommendCodeText;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

- (IBAction)clickCodeButton:(id)sender;
- (IBAction)clickRegisterButton:(id)sender;

- (IBAction)clickFFXYButton:(id)sender;
@end
