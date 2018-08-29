//
//  LXLuckyWheel.m
//  Test2
//
//  Created by clove on 11/25/17.
//  Copyright © 2017 com.hopever. All rights reserved.
//

#import "LXLuckyWheel.h"
#import <QuartzCore/QuartzCore.h>

#define AverageSpeedAngle (M_PI/180*8)

@interface LXLuckyWheel ()
{
    
}
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) float angleAmount;    // 累加的角度。angel单位是M_PI*2
@property (nonatomic) BOOL willStop;        // 即将停止，开始进入减速动画
@property (nonatomic) float endAngle;         // 停止角度
@property (nonatomic) int beginCount;       // 加速计数器，加速到最大值计数器停止
@property (nonatomic) int endCount;         // 减速计数器，减速到固定角度为止

@end

@implementation LXLuckyWheel

- (void)startDisplayLink{
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(handleDisplayLink) userInfo:nil repeats:YES];
}

- (void)handleDisplayLink{
    
    float speed = AverageSpeedAngle;
    
    // 计算起始加速
    _beginCount++;
    float a = M_PI/180*1;
    float curretSpeed = a * _beginCount;
    speed = curretSpeed >= AverageSpeedAngle ? AverageSpeedAngle : curretSpeed;
    
    // 根据当前速度累加角度值
    float angle = _angleAmount + speed;
    
    // 是否停止动画
    if (_willStop == YES) {
        
        angle = _endAngle;
        [self stopDisplayLink];
       
        CGAffineTransform cgaRotate = CGAffineTransformMakeRotation(angle);
        [self.imageView setTransform:cgaRotate];
        
    } else {
        CGAffineTransform cgaRotate = CGAffineTransformMakeRotation(angle);
        [self.imageView setTransform:cgaRotate];
        
    }
    
    _angleAmount = angle;
}

- (void)stopDisplayLink{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)stopAtAngle:(float)angle {
    
    _willStop = YES;
    _endCount = 0;
    _endAngle = angle;
}

- (void)start {
    
    _willStop = NO;
    _beginCount = 0;
    
    [self startDisplayLink];
    
}

- (void)invalidate
{
    [self.timer invalidate];
    self.timer = nil;
}

@end


