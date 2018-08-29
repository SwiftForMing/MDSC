//
//  AddReciverViewController.h
//  YiDaMerchant
//
//  Created by linqsh on 15/10/3.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoverAddressListInfo.h"

@protocol AddReciverViewControllerDelegate <NSObject>
@optional
- (void)addAction;
@end

@interface AddReciverViewController : UIViewController

@property (nonatomic, strong) RecoverAddressListInfo *addressInfo;
@property (nonatomic, strong) NSMutableArray *proviceArray;

@property (nonatomic, assign) id<AddReciverViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UIButton *quButton;

@property (weak, nonatomic) IBOutlet UIView *unitView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewWidth;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

- (IBAction)clickCityButton:(id)sender;
- (IBAction)clickQuButton:(id)sender;
- (IBAction)clickSuccessButton:(id)sender;
@end
