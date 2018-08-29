//
//  RewardSuccess.m
//  Congratulations
//
//  Created by Jeaner on 2017/5/16.
//  Copyright © 2017年 Jeaner. All rights reserved.
//

#import "RewardSuccess.h"
#import "RewardSuccessWindow.h"
static CGFloat SuccessWindow_width = 270;
static CGFloat SuccessWindow_hight = 170;

#define EmitterColor_Red      [UIColor colorWithRed:255/255.0 green:0 blue:139/255.0 alpha:1]
#define EmitterColor_Yellow   [UIColor colorWithRed:251/255.0 green:197/255.0 blue:13/255.0 alpha:1]
#define EmitterColor_Blue     [UIColor colorWithRed:50/255.0 green:170/255.0 blue:207/255.0 alpha:1]

@implementation RewardSuccess

+ (void)showWithTitle: (NSString *)title withExperience:(NSInteger)num
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [window addSubview:backgroundView];
    

    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    //创建一个view
    RewardSuccessWindow *successWindow=[[RewardSuccessWindow alloc]init];
    successWindow.frame=CGRectMake((screenSize.width - SuccessWindow_width)/2.0 , (screenSize.height - SuccessWindow_hight)/2.0, SuccessWindow_width, SuccessWindow_hight);
    
    //对里面的属性进行赋值,这是title的属性
    successWindow.titleLabel.text=title;
    
    //这个是获得经验的属性
    NSString *numString = [NSString stringWithFormat:@"获得小米:+%ld",(long)num];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:numString];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, numString.length)];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"MarkerFelt-Thin" size:35] range:[numString rangeOfString:[NSString stringWithFormat:@"%ld",(long)num]]];
    
    NSShadow *shadow =[[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, 3);
    
    [attributedString addAttribute:NSShadowAttributeName value:shadow range:[numString rangeOfString:[NSString stringWithFormat:@"%ld",(long)num]]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:[numString rangeOfString:[NSString stringWithFormat:@"%ld",(long)num]]];
    successWindow.expLabel.attributedText=attributedString;
    
    [backgroundView addSubview:successWindow];
    
    //缩放
    successWindow.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    successWindow.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        
        successWindow.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        successWindow.alpha = 1;
    }];

    //3s 消失
    double delayInSeconds = 3.0;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.4 animations:^{
            
            successWindow.transform = CGAffineTransformMakeScale(.3f, .3f);
            successWindow.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [backgroundView removeFromSuperview];
        }];
    });
    
    //开始粒子效果
    CAEmitterLayer *emitterLayer = addEmitterLayer(backgroundView,successWindow);
    startAnimate(emitterLayer);
    
}

CAEmitterLayer *addEmitterLayer(UIView *view,UIView *window)
{

    //色块粒子
    CAEmitterCell *subCell1 = subCell([UIImage imageNamed:@"jinb2"]);
    subCell1.name = @"red";
    CAEmitterCell *subCell2 = subCell([UIImage imageNamed:@"jinb1"]);
    subCell2.name = @"yellow";
    CAEmitterCell *subCell3 = subCell([UIImage imageNamed:@"jinb"]);
    subCell3.name = @"blue";
    CAEmitterCell *subCell4 = subCell([UIImage imageNamed:@"success_star"]);
    subCell4.name = @"star";
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = window.center;
    emitterLayer.emitterPosition = window.center;
    emitterLayer.emitterSize	= window.bounds.size;
    emitterLayer.emitterMode	= kCAEmitterLayerOutline;
    emitterLayer.emitterShape	= kCAEmitterLayerRectangle;
    emitterLayer.renderMode		= kCAEmitterLayerOldestFirst;
    
    emitterLayer.emitterCells = @[subCell1,subCell2,subCell3,subCell4];
    [view.layer addSublayer:emitterLayer];
    
    return emitterLayer;
    
}

void startAnimate(CAEmitterLayer *emitterLayer)
{
    CABasicAnimation *redBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.red.birthRate"];
    redBurst.fromValue		= [NSNumber numberWithFloat:30];
    redBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    redBurst.duration		= 0.5;
    redBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *yellowBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.yellow.birthRate"];
    yellowBurst.fromValue		= [NSNumber numberWithFloat:30];
    yellowBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    yellowBurst.duration		= 0.5;
    yellowBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *blueBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.blue.birthRate"];
    blueBurst.fromValue		= [NSNumber numberWithFloat:30];
    blueBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    blueBurst.duration		= 0.5;
    blueBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.star.birthRate"];
    starBurst.fromValue		= [NSNumber numberWithFloat:30];
    starBurst.toValue			= [NSNumber numberWithFloat:  0.0];
    starBurst.duration		= 0.5;
    starBurst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    CAAnimationGroup *group = [CAAnimationGroup animation];
     group.animations = @[redBurst,yellowBurst,blueBurst,starBurst];
    
    [emitterLayer addAnimation:group forKey:@"heartsBurst"];
}

CAEmitterCell *subCell(UIImage *image)
{
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    
    cell.name = @"heart";
    cell.contents = (__bridge id _Nullable)image.CGImage;
    
    // 缩放比例
    cell.scale      = 0.6;
    cell.scaleRange = 0.6;
    // 每秒产生的数量
    //    cell.birthRate  = 40;
    cell.lifetime   = 20;
    // 每秒变透明的速度
    //    snowCell.alphaSpeed = -0.7;
    //    snowCell.redSpeed = 0.1;
    // 秒速
    cell.velocity      = 200;
    cell.velocityRange = 200;
    cell.yAcceleration = 9.8;
    cell.xAcceleration = 0;
    //掉落的角度范围
    cell.emissionRange  = M_PI;
    
    cell.scaleSpeed		= -0.05;
    ////    cell.alphaSpeed		= -0.3;
    cell.spin			= 2 * M_PI;
    cell.spinRange		= 2 * M_PI;
    
    return cell;
}

UIImage *imageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 13, 17);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
