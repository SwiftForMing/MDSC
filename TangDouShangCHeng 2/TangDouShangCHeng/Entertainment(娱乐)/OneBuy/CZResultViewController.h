//
//  CZResultViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/24.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZResultViewController : UIViewController

@property (assign, nonatomic) double allMoney;
@property (copy, nonatomic) NSString *coinType;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)clickGoBackButtonAction:(id)sender;
- (IBAction)clickSeeRecordButtonAction:(id)sender;
@end
