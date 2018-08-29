//
//  BangdingViewController.h
//  YCSH
//
//  Created by linqsh on 16/1/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BangdingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *myScorlleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UITextField *recommendCodeText;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

- (IBAction)clickCodeButton:(id)sender;
- (IBAction)clickCommitButton:(id)sender;

@end
