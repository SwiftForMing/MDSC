//
//  RefundReasonViewController.h
//  YiDaMerchant
//
//  Created by linqsh on 15/11/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RefundReasonViewControllerDelegate <NSObject>
@optional
- (void)selectOverWithId:(NSString *)typeIs typeName:(NSString *)typeName;
@end

@interface RefundReasonViewController : UIViewController

@property (nonatomic, assign) id<RefundReasonViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *contentArray;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIPickerView *myPickerView;

-(IBAction)clickControlAction:(id)sender;
-(IBAction)clickCancelButtonAction:(id)sender;
-(IBAction)clickSureButtonAction:(id)sender;
@end
