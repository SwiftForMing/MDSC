//
//  TimeCountDownView.h
//  Luxy
//
//  Created by robyzhou on 14/12/19.
//  Copyright (c) 2014年 robyzhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VouchTimeCountDownDelegate <NSObject>

@optional
//倒计时结束
- (void)vouchTimeCountDownFinish;

@end

@interface TimeCountDownView : UIView

@property (nonatomic, assign) NSUInteger countDownSeconds;
@property (nonatomic, assign) NSUInteger zDistance;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL stopUpdateFlipView;//是否关闭更新倒计时视图

- (id)init;
- (id)initWithImageBundleName:(NSString*)imageBundleName;

- (void)start;
- (void)stop;

- (void)updateValuesAnimated:(BOOL)animated;
- (void)layoutFlipNumberView;
@end
