//
//  LXLuckyWheel.h
//  Test2
//
//  Created by clove on 11/25/17.
//  Copyright © 2017 com.hopever. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXLuckyWheel : NSObject

@property (weak, nonatomic) UIView *imageView;

- (void)invalidate;

- (void)start;
- (void)stopAtAngle:(float)angle; // angel单位是 M_PI*2

@end
