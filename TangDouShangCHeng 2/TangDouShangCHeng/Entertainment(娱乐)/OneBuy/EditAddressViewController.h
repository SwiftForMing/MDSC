//
//  EditAddressViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/20.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJRecordListInfo.h"

@protocol EditAddressViewControllerDelegate <NSObject>
@optional
- (void)editAddressSuccess;

@end

@interface EditAddressViewController : UIViewController

@property (nonatomic, assign) id<EditAddressViewControllerDelegate> delegate;
@property (strong,nonatomic) NSString *oeder_type;
@property (strong, nonatomic) ZJRecordListInfo *orderInfo;
@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (IBAction)clickGoButtonAction:(id)sender;
- (IBAction)clickSureButtonAction:(id)sender;
@end
