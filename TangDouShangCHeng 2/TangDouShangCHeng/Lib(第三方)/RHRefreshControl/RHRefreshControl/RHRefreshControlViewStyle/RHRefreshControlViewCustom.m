//
//  CutomRefreshView.m
//  Example
//
//  Created by Ratha Hin on 2/3/14.
//  Copyright (c) 2014 Ratha Hin. All rights reserved.
//

#import "RHRefreshControlViewCustom.h"
#import "RHAnimator.h"


@interface RHRefreshControlViewCustom ()

@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) CALayer *iconLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic) RefreshControlStyle style;

@end

@implementation RHRefreshControlViewCustom

- (id)initWithFrame:(CGRect)frame style:(RefreshControlStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        [self commonSetupOnInit];
    }
    return self;
}

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
    UIImage* image = [UIImage imageNamed:@"topic_icon_refresh"];
    switch (_style) {
        case RefreshControlStyleDark:
            image = [UIImage imageNamed:@"moment_refresh_spinner"];
            break;
            case RefreshControlStyleLight:
            image = [UIImage imageNamed:@"topic_icon_refresh"];
            break;
        default:
            break;
    }
    
    
    layer.contents = (id)image.CGImage;
    layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    [[self layer] addSublayer:layer];
    self.iconLayer=layer;
    self.iconLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    switch (_style) {
        case RefreshControlStyleDark:
        {
            view.color = UIColorFromRGB(0xd7ba94);
            view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            break;
        }
        case RefreshControlStyleLight:
            break;
        default:
            break;
    }

    
    
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
                                             multiplier:1 constant:0 ];
    
    NSDictionary * viewsDictionary=@{@"activityView":self.activityView};
    
    NSArray *pCenter = @[constraintCenterX, constraintCenterY];
    NSArray *pVList=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityView(==20)]" options:0 metrics:nil views:viewsDictionary];
    NSArray *pHList=[NSLayoutConstraint constraintsWithVisualFormat:@"H:[activityView(==20)]" options:0 metrics:nil views:viewsDictionary];
    
    [self addConstraints:pCenter];
    [self addConstraints:pVList];
    [self addConstraints:pHList];
}

- (void)updateViewOnNormalStatePreviousState:(NSInteger)state {
    if (state == RHRefreshStatePulling) {
        self.iconLayer.opacity = 0;
        self.circleLayer.opacity = 0;
    }
    
    [_activityView stopAnimating];
}

- (void)updateViewOnPullingStatePreviousState:(NSInteger)state {

    
}

- (void)updateViewOnLoadingStatePreviousState:(NSInteger)state {
    
    [self.activityView startAnimating];
    self.circleLayer.opacity = 0;
    self.iconLayer.opacity = 0;
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
    CGFloat deltaRotate = percentage * 180;
    CGFloat angelDegree = (180.0 - deltaRotate);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.iconLayer.transform = CATransform3DMakeRotation((angelDegree) / 180.0 * M_PI, 0.0f, 0.0f, 1.0f);
    self.circleLayer.strokeEnd = percentage;
    if (state != RHRefreshStateLoading) {
        self.iconLayer.opacity = 1;
        self.circleLayer.opacity = percentage;
    }
    [CATransaction commit];
}

@end
