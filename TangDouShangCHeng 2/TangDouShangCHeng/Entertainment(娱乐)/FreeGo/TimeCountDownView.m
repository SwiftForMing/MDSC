//
//  TimeCountDownView.m
//  Luxy
//
//  Created by robyzhou on 14/12/19.
//  Copyright (c) 2014年 robyzhou. All rights reserved.
//

#import "TimeCountDownView.h"
#import "JDFlipNumberView.h"

@interface TimeCountDownView ()
@property (nonatomic, copy) NSString *imageBundleName;

@property (nonatomic, strong) JDFlipNumberView* hourFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* minuteFlipNumberView;
@property (nonatomic, strong) JDFlipNumberView* secondFlipNumberView;

@property (nonatomic, strong) UIImageView* seperator1;
@property (nonatomic, strong) UIImageView* seperator2;

@property (nonatomic, strong) NSTimer *animationTimer;
@end

@implementation TimeCountDownView

- (id)init
{
    return [self initWithImageBundleName:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithImageBundleName:@"flipNumberBundle"];
    if (self) {
        self.frame = frame;
    }
    return self;
}

- (id)initWithImageBundleName:(NSString*)imageBundleName;
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // view setup
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        
        // setup flipviews
        _imageBundleName = imageBundleName;
        
        self.hourFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        self.minuteFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        self.secondFlipNumberView = [[JDFlipNumberView alloc] initWithDigitCount:2 imageBundleName:imageBundleName];
        
        self.seperator1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vouch_countdown_seperator.png"]];
        self.seperator2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vouch_countdown_seperator.png"]];
        
        // set maximum values
        self.hourFlipNumberView.maximumValue = 60;
        self.minuteFlipNumberView.maximumValue = 60;
        self.secondFlipNumberView.maximumValue = 60;
        
        // disable reverse flipping
        self.hourFlipNumberView.reverseFlippingDisabled = YES;
        self.minuteFlipNumberView.reverseFlippingDisabled = YES;
        self.secondFlipNumberView.reverseFlippingDisabled = YES;
        
        [self setZDistance: 60];
        
        _stopUpdateFlipView = NO;
        
        // set inital frame
        CGRect frame = self.hourFlipNumberView.frame;
        self.frame = CGRectMake(0, 0, frame.size.width* 7, frame.size.height);
        
        // add subviews
        for (JDFlipNumberView* view in @[self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
            [self addSubview:view];
        }
        
        [self addSubview:self.seperator1];
        [self addSubview:self.seperator2];
        
        
        self.hourFlipNumberView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark setter

- (NSUInteger)zDistance;
{
    return self.zDistance;
}

- (void)setZDistance:(NSUInteger)zDistance;
{
    for (JDFlipNumberView* view in @[self.hourFlipNumberView, self.minuteFlipNumberView, self.secondFlipNumberView]) {
        [view setZDistance:zDistance];
    }
}

- (void)setCountDownSeconds:(NSUInteger)countDownSeconds;
{
    _countDownSeconds = countDownSeconds;
    [self updateValuesAnimated:YES];
}

- (void)setupLineImageView {
    CGFloat width = 0.f;
    CGFloat space = 0.f;
    if ([SDiPhoneVersion deviceSize] == iPhone35inch) {
        width = 60.f;
        space = 14.f;
    }
    else if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        width = 64.f;
        space = 9.f;
    }
    else if ([SDiPhoneVersion deviceSize] == iPhone47inch) {
        space = 14.f;
        width = 84.f;
    }
    else if ([SDiPhoneVersion deviceSize] == iPhone55inch) {
        space = 17.f;
        width = 91.f;
    }
    UIImage *image = [UIImage imageNamed:@"vouch_time_line"];
    UIImageView *lineView1 = [[UIImageView alloc] initWithImage:image];
    [lineView1 setFrame:CGRectMake(space, self.height/2, width, 1)];
    [self addSubview:lineView1];
    
    UIImageView *lineView2 = [[UIImageView alloc] initWithImage:image];
    [lineView2 setFrame:CGRectMake(self.width -width-space, self.height/2, width, 1)];
    [self addSubview:lineView2];
}
#pragma mark layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int flipViewWidth = self.width/3;
    int flipViewHeight = self.height;
    
    self.minuteFlipNumberView.frame = CGRectMake(0,0,
                                                 flipViewWidth,
                                                 flipViewHeight);
    self.minuteFlipNumberView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                                   CGRectGetMidY(self.bounds));
    
    self.hourFlipNumberView.frame = CGRectMake(0, 0,
                                               flipViewWidth,
                                               flipViewHeight);
    self.hourFlipNumberView.center = CGPointMake(CGRectGetMidX(self.bounds) - flipViewWidth + 3,
                                                 CGRectGetMidY(self.bounds));
    
    self.secondFlipNumberView.frame = CGRectMake(0, 0,
                                                 flipViewWidth,
                                                 flipViewHeight);
    self.secondFlipNumberView.center = CGPointMake(CGRectGetMidX(self.bounds) + flipViewWidth - 3,
                                                   CGRectGetMidY(self.bounds));
    
    CGPoint seperator1Center = CGPointMake((CGRectGetMidX(self.hourFlipNumberView.frame) + CGRectGetMidX(self.minuteFlipNumberView.frame))/2.f - 1,
                                           CGRectGetMidY(self.hourFlipNumberView.frame) - 1.5f);
    self.seperator1.center = seperator1Center;
    
    CGPoint seperator2Center = CGPointMake((CGRectGetMidX(self.minuteFlipNumberView.frame) + CGRectGetMidX(self.secondFlipNumberView.frame))/2.f - 1,
                                           CGRectGetMidY(self.minuteFlipNumberView.frame) - 1.5f);
    self.seperator2.center = seperator2Center;
    [self setupLineImageView];  
}

#pragma mark update timer
- (void)start;
{
    if (self.animationTimer == nil) {
        [self setupUpdateTimer];
    }
}

- (void)stop;
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

- (void)setupUpdateTimer;
{
    self.animationTimer = [NSTimer timerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer*)timer;
{
    _countDownSeconds--;
    [self updateValuesAnimated:YES];

    if (self.countDownSeconds <= 0) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(vouchTimeCountDownFinish)]) {
            [_delegate vouchTimeCountDownFinish];
        }
    }
}

- (void)updateValuesAnimated:(BOOL)animated;
{
    if (!_stopUpdateFlipView) {
        if (self.countDownSeconds > 0) {
            NSUInteger hours = self.countDownSeconds / 3600;
            NSUInteger mininutes = (self.countDownSeconds / 60) % 60;
            NSUInteger seconds = (self.countDownSeconds) % 60;
            
            if (hours == 60) {
                hours = 0;
            }
            [self.hourFlipNumberView setValue:hours animated:animated];
            [self.minuteFlipNumberView setValue:mininutes animated:animated];
            [self.secondFlipNumberView setValue:seconds animated:animated];
        } else {
            [self.hourFlipNumberView setValue:0 animated:animated];
            [self.minuteFlipNumberView setValue:0 animated:animated];
            [self.secondFlipNumberView setValue:0 animated:animated];
            [self stop];
        }
    }
}

- (void)layoutFlipNumberView {
//    [self.hourFlipNumberView layoutCurrentValue];
//    [self.minuteFlipNumberView layoutCurrentValue];
//    [self.secondFlipNumberView layoutCurrentValue];
}
@end

