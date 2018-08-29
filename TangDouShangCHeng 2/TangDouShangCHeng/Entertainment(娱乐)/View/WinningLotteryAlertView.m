//
//  WinningLotteryAlertView.m
//  DuoBao
//
//  Created by clove on 12/6/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "WinningLotteryAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+JMJParametricAnimation.h"
#import "CollectPrizeViewController.h"
#import "ProfileTableViewController.h"
#import "UIImage+Crop.h"
#import "ZJRecordViewController.h"

@interface WinningLotteryAlertView()
@property (nonatomic, strong) UIImageView *winningBackgroundImageView;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UIImageView *pieceImageView;
@property (nonatomic, strong) UILabel *congratulationLabel;
@property (nonatomic, strong) UILabel *lotteryNumberLabel;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, copy) NSMutableArray *starArray;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) UILabel *timeLabel;
@property (nonatomic, copy) UILabel *addLabel;
@property (nonatomic, copy) UILabel *addDesLabel;
@property (nonatomic, copy) UIImage *qrImage;



@end

@implementation WinningLotteryAlertView

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    self.data = dict;
    
    NSString *lotteryNumber = [dict objectForKey:@"good_period"];
    NSString *goodsTitle = [dict objectForKey:@"good_name"];
      NSString *timeTitle = [dict objectForKey:@"win_time"];
    NSString *user_id = [dict objectForKey:@"user_id"];
     NSString *addnum = [dict objectForKey:@"AddAward_money"];
    NSString *lift = [dict objectForKey:@"Lift"];
//    MLog(@"timeTitle%@",timeTitle);
    _lotteryNumberLabel.text = [NSString stringWithFormat:@"(%@)第%@期",user_id,lotteryNumber];
    _goodsTitleLabel.text = goodsTitle;
    _timeLabel.text = timeTitle;
    _addLabel.text = [NSString stringWithFormat:@"今日运势(%@)嘉奖%@小米",lift,addnum];
    _addDesLabel.text = @"(系统已自动结算)";
    return self;
}

- (instancetype)initWithImage:(UIImage *)image beans:(NSString *)beanNum
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    _lotteryNumberLabel.text = @"";
    _goodsTitleLabel.text = @"";
    _congratulationLabel.text = [NSString stringWithFormat:@"米豆商城恭喜你获得：%@小米",beanNum];;
    _leftButton.alpha = 0;
    _rightButton.alpha = 0;
    _giftImageView.image = image;
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        //        [self addSubview:imageView];
        
        [UIView animateWithDuration:0.25 animations:^{
            imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        }];
        
        [self loadSubviews];
        [self performSelector:@selector(moveInAnimation) withObject:nil afterDelay:0.5];
        
        [self whenTapped:^{
            [self hideView];
        }];
        
        [self performSelector:@selector(screenshoot) withObject:nil afterDelay:2];
    }
    
    return self;
}

- (UIImage *)screenshoot
{
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    
    float height = 120;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-height, self.width, height)];
    view.backgroundColor = [UIColor colorFromHexString:@"1a1a1a"];
    
//    UIImage *image2 = [Tool encodeQRImageWithContent:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.vma.project.base.zmlg" size:CGSizeMake(100, 100)];
//    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image2];
//    imageView2.width = 100;
//    imageView2.height = 100;
//    imageView2.centerY = view.height/2;
//    [view addSubview:imageView2];
    
    float margin = 5;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 31)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor lightTextColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"长按识别二维码";
    [label sizeToFit];
    label.bottom = view.height/2 - margin;
    [view addSubview:label];
    
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor lightTextColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"沾沾我的喜气儿";
    [label sizeToFit];
    label.left = 8;
    label.top = view.height/2 + margin;
    [view addSubview:label];
    
    [self addSubview:view];
    
    
    UIImage *image = [UIImage screenshotFromView:self];
    
    
    _leftButton.hidden = NO;
    _rightButton.hidden = NO;
    view.hidden = YES;
    
    return image;
}

- (void)loadSubviews
{
    float left = 56;
    float rate = self.height / 667; // 适配屏幕比例
    
    // Light imageView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light"]];
    imageView.width *= rate;
    imageView.height *= rate;
    imageView.x = 0;
    imageView.y = 55 * rate;
    [self addSubview:imageView];
    _winningBackgroundImageView = imageView;
    
    // Gift imageView
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"win"]];
    imageView.width *= rate;
    imageView.height *= rate;
    imageView.centerX = self.width/2.0;
    imageView.y = 153 * rate;
    [self addSubview:imageView];
    _giftImageView = imageView;
    
    // Stars image view
    UIColor *whiteColor = [UIColor whiteColor];
    UIColor *starColorYellow = [UIColor colorFromHexString:@"cdca93"];
    UIColor *starColorDarkYellow = [UIColor colorFromHexString:@"fafa96"];
    CGFloat starLeft = _winningBackgroundImageView.left;
    CGFloat starTop = _winningBackgroundImageView.top;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:6];
    
    imageView = [self createImageViewWithFrame:CGRectMake(starLeft+181, starTop+96, 16, 16 *52.0/35.0f) maskColor:starColorDarkYellow];
    imageView.tag = 100;
    imageView.alpha = 0.9;
    [array addObject:imageView];
    [self addSubview:imageView];
    
    imageView = [self createImageViewWithFrame:CGRectMake(starLeft+200, starTop+75, 22, 22 *52.0/35.0f) maskColor:whiteColor];
    imageView.tag = 101;
    [array addObject:imageView];
    [self addSubview:imageView];
    
    imageView = [self createImageViewWithFrame:CGRectMake(starLeft+202, starTop+95, 30, 30 *52.0/35.0f) maskColor:starColorYellow];
    imageView.tag = 102;
    imageView.alpha = 0.5;
    [array addObject:imageView];
    [self addSubview:imageView];
    
    imageView = [self createImageViewWithFrame:CGRectMake(starLeft+226, starTop+87, 14, 14 *52.0/35.0f) maskColor:whiteColor];
    imageView.tag = 103;
    [array addObject:imageView];
    [self addSubview:imageView];
    
    imageView = [self createImageViewWithFrame:CGRectMake(starLeft+238, starTop+96, 35, 35 *52.0/35.0f) maskColor:whiteColor];
    imageView.tag = 104;
    [array addObject:imageView];
    [self addSubview:imageView];
    
    imageView = [self createImageViewWithFrame:CGRectMake(starLeft+268, starTop+103, 18, 18 *52.0/35.0f) maskColor:starColorYellow];
    imageView.tag = 105;
    [array addObject:imageView];
    [self addSubview:imageView];
    
    _starArray = array;
    
    // piece imageView
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"piece"]];
    imageView.width *= rate;
    imageView.height *= rate;
    imageView.centerX = self.width/2.0;
    imageView.centerY = _winningBackgroundImageView.centerY;
    [self addSubview:imageView];
    _pieceImageView = imageView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, _giftImageView.top + 205 * rate, self.width - 2*left, 21)];
    label.text = @"米豆商城恭喜您获得";
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    _congratulationLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom + 16*rate, label.width, 21)];
    label.text = @"第1242342期";
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"ffc100"];
    [self addSubview:label];
    _lotteryNumberLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom + 18*rate, label.width, 21)];
    label.text = @"移动50元充值卡";
    label.font = [UIFont boldSystemFontOfSize:21];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"ffc100"];
    [self addSubview:label];
    _goodsTitleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom + 18*rate, label.width, 21)];
    label.text = @"2018:08:01";
    label.font = [UIFont boldSystemFontOfSize:21];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"ffc100"];
    [self addSubview:label];
    _timeLabel = label;
    
    UIColor *yellowColor = [UIColor yellowColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(label.left, label.bottom + 41*rate, 120*rate, 44*rate);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    button.backgroundColor = [UIColor colorFromHexString:@"ffc000"];
    UIImage *image = [UIImage imageFromContextWithColor:[UIColor colorFromHexString:@"ffc000"] size:button.size];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"查看详情" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"661502"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2;
    [self addSubview:button];
    _leftButton = button;
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(_leftButton.right + 23*rate, _leftButton.top, _leftButton.width, _leftButton.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    button.backgroundColor = [UIColor colorFromHexString:@"ee0a0b"];
    image = [UIImage imageFromContextWithColor:[UIColor colorFromHexString:@"ee0a0b"] size:button.size];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setTitle:@"我要炫耀" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromHexString:@"fffffd"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2;
    [self addSubview:button];
    _rightButton = button;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, _rightButton.bottom + 0, ScreenWidth-40, 50)];
    label.text = @"2018:08:01";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"ffc100"];
    [self addSubview:label];
    _addLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, label.bottom + 0, ScreenWidth-40, 20)];
    label.text = @"";
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorFromHexString:@"ffc100"];
    [self addSubview:label];
    _addDesLabel = label;
    
    self.userInteractionEnabled = NO;
    _giftImageView.hidden = YES;
    _winningBackgroundImageView.hidden = YES;
    _pieceImageView.hidden = YES;
    _congratulationLabel.hidden = YES;
    _goodsTitleLabel.hidden = YES;
    _lotteryNumberLabel.hidden = YES;
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    [self setStarsHidden:YES];
    
    if (rate < 1) {
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:22.0 * rate];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:22.0 * rate];
        _congratulationLabel.font = [UIFont systemFontOfSize:17.0 * rate];
        _lotteryNumberLabel.font = [UIFont systemFontOfSize:18.0 * rate];
        _goodsTitleLabel.font = [UIFont systemFontOfSize:26.0 * rate];
    }
}

- (void)moveInAnimation
{
    _giftImageView.hidden = NO;
    
    UIView *view = _giftImageView;
    CGPoint giftFromPosition = CGPointMake(view.centerX, -view.centerY);
    CGPoint giftToPosition = view.center;
    CGFloat duration = 0.5;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        self.userInteractionEnabled = YES;
        _giftImageView.hidden = NO;
        _winningBackgroundImageView.hidden = NO;
        _congratulationLabel.hidden = NO;
        _goodsTitleLabel.hidden = NO;
        _lotteryNumberLabel.hidden = NO;
        _leftButton.hidden = NO;
        _rightButton.hidden = NO;
        
        
        [self performSelector:@selector(pieceAnimation:) withObject:[NSNumber numberWithFloat:duration] afterDelay:0.25];
        
        float delay = -0.5;
        UIView *starView = [self viewWithTag:104];
        [self performSelector:@selector(starAnimations:duration:) withObject:@[starView, @2.5] afterDelay:2+delay];
        starView = [self viewWithTag:101];
        [self performSelector:@selector(starAnimations:duration:) withObject:@[starView, @2] afterDelay:1.5+delay];
        starView = [self viewWithTag:103];
        [self performSelector:@selector(starAnimations:duration:) withObject:@[starView, @1.5] afterDelay:1+delay];
        starView = [self viewWithTag:100];
        [self performSelector:@selector(starAnimations:duration:) withObject:@[starView, @1.5] afterDelay:0.5+delay];
        starView = [self viewWithTag:102];
        [self performSelector:@selector(starAnimations:duration:) withObject:@[starView, @3] afterDelay:1+delay];
    }];
    
    CABasicAnimation *giftDropdownAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    giftDropdownAnimation.fromValue = [NSValue valueWithCGPoint:giftFromPosition];
    giftDropdownAnimation.toValue = [NSValue valueWithCGPoint:giftToPosition];
    giftDropdownAnimation.duration = duration;
    giftDropdownAnimation.beginTime = CACurrentMediaTime();
    giftDropdownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [view.layer addAnimation:giftDropdownAnimation forKey:@"roseFadeInAnimation"];
    [CATransaction commit];
    
    // background animation
    CABasicAnimation *turnFadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    turnFadeInAnimation.fromValue = @0;
    turnFadeInAnimation.toValue = @1;
    turnFadeInAnimation.duration = 0.25+0.2;
    turnFadeInAnimation.beginTime = CACurrentMediaTime() + duration;
    [_winningBackgroundImageView.layer addAnimation:turnFadeInAnimation forKey:@"turnFadeInAnimation"];
    
    CABasicAnimation *starAniamtion = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    starAniamtion.fromValue = 0;
    starAniamtion.toValue = [NSNumber numberWithFloat:M_PI*2];
    starAniamtion.duration = 12;
    starAniamtion.beginTime = CACurrentMediaTime() + duration;
    starAniamtion.removedOnCompletion = NO;
    starAniamtion.repeatCount = INFINITY;
    starAniamtion.fillMode = kCAFillModeForwards;
    starAniamtion.autoreverses = NO;
    [_winningBackgroundImageView.layer addAnimation:starAniamtion forKey:@"rotate star"];
    
    //    [self makeFireworksDisplay];
    
    //    float beginTime = 2;
    //    UIView *starView = [self viewWithTag:104];
    //    [self starAnimations:starView beginTime:2 duration:2.5];
    //    starView = [self viewWithTag:101];
    //    [self starAnimations:starView beginTime:1.5 duration:2];
    //    starView = [self viewWithTag:103];
    //    [self starAnimations:starView beginTime:1 duration:2];
    //    beginTime = 3;
    //    starView = [self viewWithTag:100];
    //    [self starAnimations:starView beginTime:0.5 duration:1.5];
    //    starView = [self viewWithTag:102];
    //    [self starAnimations:starView beginTime:1 duration:3];
    //    starView = [self viewWithTag:103];
    //    [self starAnimations:starView beginTime:beginTime];
    
    [self moveInAnimation:_congratulationLabel delay:0.];
    [self moveInAnimation:_lotteryNumberLabel delay:0.];
    [self moveInAnimation:_goodsTitleLabel delay:0.05];
    [self moveInAnimation:_leftButton delay:0.1];
    [self moveInAnimation:_rightButton delay:0.1];
}

- (void)pieceAnimation:(float)delay
{
    _pieceImageView.hidden = NO;
    
    // piece animation
    CABasicAnimation *turnFadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    turnFadeInAnimation.fromValue = @0;
    turnFadeInAnimation.toValue = @1;
    turnFadeInAnimation.duration = 0.5;
    turnFadeInAnimation.beginTime = CACurrentMediaTime() + delay;
    turnFadeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [_pieceImageView.layer addAnimation:turnFadeInAnimation forKey:@"pieceAnimation1"];
    
    //    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //    animation.fromValue = [NSNumber numberWithFloat:0.1];
    //    animation.toValue = [NSNumber numberWithFloat:1];
    //    animation.duration = 0.25;
    //    animation.beginTime = CACurrentMediaTime() + delay;
    //    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    ////    [_pieceImageView.layer addAnimation:animation forKey:@"animation star"];
    //    CABasicAnimation *scaleAnimation = animation;
    //
    //    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    //    animation.fromValue = 0;
    //    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    //    animation.duration = 0.25;
    //    animation.beginTime = CACurrentMediaTime() + delay;
    //    animation.fillMode = kCAFillModeForwards;
    //    animation.autoreverses = NO;
    ////    [_pieceImageView.layer addAnimation:animation forKey:@"rotate piece"];
    //    CABasicAnimation *rotationAnimation = animation;
    //
    //    CAAnimationGroup *group = [CAAnimationGroup animation];
    //    group.animations = @[scaleAnimation, rotationAnimation];
    //    group.duration = 0.25;
    //    group.beginTime = CACurrentMediaTime() + delay;
    //    [_pieceImageView.layer addAnimation:group forKey:@"group piece"];
}

- (void)moveInAnimation:(UIView *)view delay:(float)delay
{
    CGPoint fromPosition = CGPointMake(self.width + view.centerX, view.centerY);
    CGPoint toPosition = view.center;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    animation.toValue = [NSValue valueWithCGPoint:toPosition];
    animation.duration = 0.5;
    animation.beginTime = CACurrentMediaTime() + 0.25 + delay;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    [view.layer addAnimation:animation forKey:@"roseFadeInAnimationd"];
}

- (void)starAnimations:(UIView *)view beginTime:(float)beginTime duration:(float)dutation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    animation.autoreverses = YES;
    //    animation.repeatDuration = 1;
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation.beginTime = CACurrentMediaTime() + beginTime;
    [view.layer addAnimation:animation forKey:@"animation dsfs"];
}

- (void)starAnimations:(UIView *)view duration:(float)duration
{
    NSArray *array = (NSArray *)view;
    view = [array firstObject];
    duration = [[array lastObject] floatValue];
    
    view.hidden = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    animation.autoreverses = YES;
    //    animation.repeatDuration = 1;
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    animation.beginTime = CACurrentMediaTime();
    [view.layer addAnimation:animation forKey:@"animation dsfs"];
}

- (void)setStarsHidden:(BOOL)value
{
    for (int i=100; i<106; i++) {
        UIView *view = [self viewWithTag:i];
        view.hidden = value;
    }
}

- (void)makeFireworksDisplay{
    // Cells spawn in the bottom, moving up
    
    //分为3种粒子，子弹粒子，爆炸粒子，散开粒子
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize    = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode    = kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape    = kCAEmitterLayerLine;
    fireworksEmitter.renderMode        = kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;
    
    // Create the rocket
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate        = 1.0;
    rocket.emissionRange    = 0.02 * M_PI;  // some variation in angle
    rocket.velocity            = viewBounds.size.height*0.85;
    rocket.velocityRange    = 150;
    rocket.yAcceleration    = 75;
    rocket.lifetime            = 1.02;    // we cannot set the birthrate < 1.0 for the burst
    
    //小圆球图片
    rocket.contents            = (id) [[UIImage imageNamed:@""] CGImage];
    rocket.scale            = 0.2;
    rocket.color            = [[UIColor redColor] CGColor];
    rocket.greenRange        = 1.0;        // different colors
    rocket.redRange            = 1.0;
    rocket.blueRange        = 1.0;
    rocket.spinRange        = M_PI;        // slow spin
    
    
    
    // the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate            = 1.0;        // at the end of travel
    burst.velocity            = 0;        //速度为0
    burst.scale                = 2.5;      //大小
    burst.redSpeed            =-1.5;        // shifting
    burst.blueSpeed            =+1.5;        // shifting
    burst.greenSpeed        =+1.0;        // shifting
    burst.lifetime            = 0.35;     //存在时间
    
    // and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate            = 400;
    spark.velocity            = 125;
    spark.emissionRange        = 2* M_PI;    // 360 度
    spark.yAcceleration        = 75;        // gravity
    spark.lifetime            = 3;
    //星星图片
    spark.contents            = (id) [[UIImage imageNamed:@"scrap"] CGImage];
    spark.scaleSpeed        =-0.2;
    spark.greenSpeed        =-0.1;
    spark.redSpeed            = 0.4;
    spark.blueSpeed            =-0.1;
    spark.alphaSpeed        =-0.25;
    spark.spin                = 2* M_PI;
    spark.spinRange            = 2* M_PI;
    
    // 3种粒子组合，可以根据顺序，依次烟花弹－烟花弹粒子爆炸－爆炸散开粒子
    fireworksEmitter.emitterCells    = [NSArray arrayWithObject:rocket];
    rocket.emitterCells                = [NSArray arrayWithObject:burst];
    burst.emitterCells                = [NSArray arrayWithObject:spark];
    [self.layer addSublayer:fireworksEmitter];
}


- (UIImageView *)createImageViewWithFrame:(CGRect)frame maskColor:(UIColor *)color
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageFromContextWithColor:color size:imageView.size];
    
    UIImageView *maskImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    maskImageView.frame = imageView.bounds;
    
    imageView.layer.mask = maskImageView.layer;
    return imageView;
}

- (void)leftButtonAction
{
    UITabBarController *rootViewController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController *tempNV = (UINavigationController *)rootViewController.selectedViewController;
    UIViewController *topVC = tempNV.topViewController;
    if ([topVC isMemberOfClass:[ZJRecordViewController class]]) {
        
        [self hideView];
        return;
    }
    
    [rootViewController.navigationController popToRootViewControllerAnimated:NO];
    [rootViewController setSelectedIndex:3];
    
    for (UINavigationController *nv in rootViewController.viewControllers) {
        [nv popToRootViewControllerAnimated:NO];
    }
    
    UINavigationController *nv = (UINavigationController *)rootViewController.selectedViewController;
    ProfileTableViewController *vc = (ProfileTableViewController *)nv.viewControllers.firstObject;
    if ([vc isMemberOfClass:[ProfileTableViewController class]]) {
        [vc.navigationController popToRootViewControllerAnimated:NO];
        [vc pushWinLotteryViewController];
    }
    
    [self hideView];
}

- (void)rightButtonAction
{
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    UIImage *image = [self screenshoot];
    
    [ShareManager shareInstance].shareType = 3;
    NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"%@ - 最靠谱的众筹购物APP，一元购你所想！", bundleDisplayName];
    NSString *description = [NSString stringWithFormat:@"朋友们一起来参与吧，一元就能抢iPhone7。注册有豪礼，万元商品带回家！我的推荐码:%@",[ShareManager shareInstance].userinfo.id];
    
    [Tool showShareActionSheet:self
                          text:description
                        images:image
                           url:[NSURL URLWithString:ShareDownloadLink]
                         title:str
                          type:SSDKContentTypeImage
                    completion:nil];
}


@end
