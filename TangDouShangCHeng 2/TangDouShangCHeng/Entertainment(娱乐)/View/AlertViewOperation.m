//
//  AlertViewOperation.m
//  DuoBao
//
//  Created by clove on 4/21/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "AlertViewOperation.h"
//#import "WinningThriceAlertView.h"
#import "WinningLotteryAlertView.h"

@implementation AlertViewOperation

- (instancetype)initWithWinningThriceData:(NSDictionary *)data
{
    self = [super init];
    
    if (self) {
        
        _data = data;
        _bettingType = BettingTypeThrice;
    }
    
    return self;
}


- (instancetype)initWithWinningCrowdfundingData:(NSDictionary *)data
{
    self = [super init];
    
    if (self) {
        
        _data = data;
        _bettingType = BettingTypeCrowdfunding;
    }
    
    return self;
}


- (void)main
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_bettingType == BettingTypeThrice) {
            [self showWinningThrice];
        } else {
            [self showWinningCrowdfunding];
        }
    });

    [super main];
}

- (void)showWinningCrowdfunding
{
    NSDictionary *data = _data;

    WinningLotteryAlertView *alertView = [[WinningLotteryAlertView alloc] initWithDictionary:data];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rootViewController presentViewController:alertController animated:YES completion:nil];
    
    alertController.viewDidHideHandler = ^ (UIView *alertView){
        
        self.done = YES;
    };
}

- (void)showWinningThrice
{
//    NSDictionary *data = _data;
//
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WinningThriceAlertView" owner:nil options:nil];
//    
//    WinningThriceAlertView *alertView = [nib firstObject];
//    [alertView setData:data];
//    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleAlert];
//    alertController.backgoundTapDismissEnable = YES;
//    alertController.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
//    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
//    [rootViewController presentViewController:alertController animated:YES completion:nil];
//    
//    
//    alertController.viewDidHideHandler = ^ (UIView *alertView){
//        
//        self.done = YES;
//    };
}









@end
