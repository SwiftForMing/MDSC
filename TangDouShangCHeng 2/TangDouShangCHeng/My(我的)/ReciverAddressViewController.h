//
//  ReciverAddressViewController.h
//  YiDaMerchant
//
//  Created by linqsh on 15/9/27.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoverAddressListInfo.h"

@protocol ReciverAddressViewControllerDelegate <NSObject>
@optional
- (void)selectAddressWithInfo:(RecoverAddressListInfo *)info;

@end

@interface ReciverAddressViewController : UIViewController
@property (nonatomic, assign) id<ReciverAddressViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (assign, nonatomic) BOOL isSelectAddress;


@end
