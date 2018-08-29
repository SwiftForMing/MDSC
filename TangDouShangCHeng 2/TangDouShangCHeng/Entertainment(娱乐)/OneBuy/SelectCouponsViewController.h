//
//  SelectCouponsViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/23.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsListInfo.h"

@protocol SelectCouponsViewControllerDelegate <NSObject>
@optional
- (void)selectCouponsWithID:(NSString *)couponsIdStr couponsName:(NSString *)couponsName value:(double)value;
- (void)didSelectCoupon:(CouponsListInfo *)coupon;
@end

@interface SelectCouponsViewController : UIViewController

@property (strong, nonatomic) NSString *couponsId;

@property (nonatomic, assign) id<SelectCouponsViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


- (IBAction)clickClearButtonAction:(id)sender;
- (IBAction)clickSureButtonAction:(id)sender;

@end
