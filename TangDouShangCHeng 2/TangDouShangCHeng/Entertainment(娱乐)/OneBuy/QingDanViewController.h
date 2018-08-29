//
//  QingDanViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QingDanViewController : UIViewController

@property (assign, nonatomic) BOOL isPush;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyLabelWidth;

@property (weak, nonatomic) IBOutlet UIButton *allButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allButtonWidth;

- (IBAction)clickSureButtonAction:(id)sender;

- (IBAction)clickAllButtonAction:(id)sender;
@end
