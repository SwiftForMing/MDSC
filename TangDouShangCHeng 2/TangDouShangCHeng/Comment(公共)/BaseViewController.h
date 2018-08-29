//
//  BaseViewController.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (void)setRightBarButtonItem:(NSString *)title;
- (void)setLeftBarButtonItemArrow;
-(void)hidenLeftBarButton;
- (void)setLeftBarButtonItem:(NSString *)title;
- (void)setRightBarButtonItemMore;
- (void)setRightBarButtonItemEdit;


// MBHUD
- (void)hiddenWithTitle:(NSString *)title;
- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail;
- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail afterDelay:(NSTimeInterval)time;
- (void)hiddenWithCheckMark:(NSString *)title;
//- (MBProgressHUD *)showLoading;
//- (MBProgressHUD *)showLoadingWithTitle:(NSString *)title;


- (UIButton *)createButtonWithLeftMargin:(CGFloat)left top:(CGFloat)top height:(CGFloat)height title:(NSString *)title;
- (void)footerButtonAction;

@end
