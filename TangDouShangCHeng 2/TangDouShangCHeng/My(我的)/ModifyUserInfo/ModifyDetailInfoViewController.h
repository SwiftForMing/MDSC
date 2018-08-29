//
//  ModifyDetailInfoViewController.h
//  YCSH
//
//  Created by linqsh on 16/1/6.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyDetailInfoViewControllerDelegate <NSObject>
@optional
- (void)modiftyUserInfoSuccesss;

@end

@interface ModifyDetailInfoViewController : UIViewController
@property (nonatomic, assign) id<ModifyDetailInfoViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *contentStr;
@property (weak, nonatomic) IBOutlet UITextField *contentText;
@end
