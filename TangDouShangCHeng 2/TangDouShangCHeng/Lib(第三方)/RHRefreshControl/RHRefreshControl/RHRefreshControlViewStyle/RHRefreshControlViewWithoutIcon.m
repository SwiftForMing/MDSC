//
//  CutomRefreshView.m
//  Example
//
//  Created by Ratha Hin on 2/3/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHRefreshControlViewWithoutIcon.h"
#import "RHAnimator.h"


@interface RHRefreshControlViewWithoutIcon ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CALayer *iconLayer;

@end

@implementation RHRefreshControlViewWithoutIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSetupOnInit];
    }
    return self;
}

- (void)commonSetupOnInit
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 32.0f, 32.0f);
    layer.contentsGravity = kCAGravityCenter;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(0, 0, 20.0f, 20.0f);
    view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:view];
    self.activityView = view;
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    // AutoLayout
    self.activityView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint* constraintCenterY = [NSLayoutConstraint
                                             constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self attribute:NSLayoutAttributeCenterY
                                             multiplier:1 constant:0];
    
    
    NSLayoutConstraint* constraintCenterX = [NSLayoutConstraint
                                             constraintWithItem:self.activityView attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self attribute:NSLayoutAttributeCenterX
                                             multiplier:1 constant:0 ];    NSDictionary * viewsDictionary=@{@"activityView":self.activityView};
    
    NSArray *pCenter = @[constraintCenterX, constraintCenterY];
    NSArray *pVList=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityView(==20)]" options:0 metrics:nil views:viewsDictionary];
    NSArray *pHList=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[activityView(==20)]" options:0 metrics:nil views:viewsDictionary];
    
    [self addConstraints:pCenter];
    [self addConstraints:pVList];
    [self addConstraints:pHList];
}

- (void)updateViewOnNormalStatePreviousState:(NSInteger)state {
    if (state == RHRefreshStatePulling) {
    }
    
    [_activityView stopAnimating];
}

- (void)updateViewOnPullingStatePreviousState:(NSInteger)state {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5f;
    animation.removedOnCompletion = YES;
    [self.activityView.layer addAnimation:animation forKey:@"transform"];
    _activityView.hidden = NO;
}

- (void)updateViewOnLoadingStatePreviousState:(NSInteger)state {
    
    
    [self.activityView startAnimating];
    
    
    return;

    CATransform3D fromMatrix = CATransform3DMakeScale(0.0, 0.0, 0.0);
    CATransform3D toMatrix = CATransform3DMakeScale(1.0f, 1.0f, 1.0f);
    CAKeyframeAnimation *animation = [RHAnimator animationWithCATransform3DForKeyPath:@"transform"
                                                                       easingFunction:RHElasticEaseOut
                                                                           fromMatrix:fromMatrix
                                                                             toMatrix:toMatrix];
    animation.duration = 1.0f;
    animation.removedOnCompletion = NO;
    [self.activityView.layer addAnimation:animation forKey:@"transform"];
}

- (void)updateViewOnComplete {
    
}

- (void)updateViewWithPercentage:(CGFloat)percentage state:(NSInteger)state {

}

@end
