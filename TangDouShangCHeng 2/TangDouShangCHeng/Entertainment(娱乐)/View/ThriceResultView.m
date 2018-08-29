//
//  ThriceResultView.m
//  DuoBao
//
//  Created by clove on 4/15/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ThriceResultView.h"
#import "UIView+Extend.h"
#import "ThriceResultComponent.h"

@implementation ThriceResultView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/*
- (instancetype)initWithFrame:(CGRect)frame prizeNumber:(NSString *)prizeNumber bettingArray:(NSArray *)bettingArray prizeType:(PrizeType)prizeType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIColor *grayColor = [UIColor colorFromHexString:@"eeeeee"];
        UIColor *redColor = [UIColor colorFromHexString:@"fb6165"];
        UIColor *blueColor = [UIColor colorFromHexString:@"9857ff"];
        UIColor *orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
        float separationWidth = 1;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 58*3 - 3)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = redColor;
        label.font = [UIFont systemFontOfSize:14];
        [label addSingleBorder:UIViewBorderDirectBottom color:grayColor width:separationWidth];
        [label addSingleBorder:UIViewBorderDirectTop color:grayColor width:separationWidth];
        [label addSingleBorder:UIViewBorderDirectRight color:grayColor width:separationWidth];
        label.text = @"1赔3";
        label.backgroundColor = [UIColor whiteColor];
        [self addSubview:label];
        
        
        NSArray *array = @[
                           @[@"1", @"4", @"7"],
                           @[@"2", @"5", @"8"],
                           @[@"3", @"6", @"9"],
                           @[@"0"],
                           ];
        float height = 58;
        
        
        for (int i=0;i<array.count;i++) {
            
            NSArray *numbers = [array objectAtIndex:i];
            
            int count = 0;
            if (i < bettingArray.count) {
                NSString *str = [numbers firstObject];
                NSDictionary *dict = [bettingArray objectAtIndex:i];
                NSString *type = [dict objectForKey:@"type"];
                if ([type containsString:str]) {
                    NSNumber *number = [dict objectForKey:@"count"];
                    count = [number intValue];
                }
            }
            
            CGRect frame = CGRectMake(0, (height -1) * i, self.width, height);
            ThriceResultComponent *view = [[ThriceResultComponent alloc] initWithNumbers:numbers selectedNumber:prizeNumber bettingCount:count frame:frame];
            [self addSubview:view];
        }
        
        UIImage *image = nil;
        if (prizeType == PrizeTypeAccept) {
            
            image = [UIImage imageNamed:@"thrice_component_accept_selected"];
        } else if (prizeType == PrizeTypeLucky) {
            
            image = [UIImage imageNamed:@"thrice_component_accept_normal"];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.centerX = self.width * 0.618;
        imageView.centerY = self.height / 2;
        [self addSubview:imageView];
    }
    
    return self;
}
*/
 
- (void)reloadWithPrizeNumber:(NSString *)prizeNumber bettingArray:(NSArray *)bettingArray prizeType:(PrizeType)prizeType
{
    [self removeAllSubviews];
    
    UIColor *grayColor = [UIColor colorFromHexString:@"eeeeee"];
    UIColor *redColor = [UIColor colorFromHexString:@"fb6165"];
    UIColor *blueColor = [UIColor colorFromHexString:@"9857ff"];
    UIColor *orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
    float separationWidth = 1;
    
    NSArray *array = @[@[@"1", @"4", @"7"],
                       @[@"2", @"5", @"8"],
                       @[@"3", @"6", @"9"],
                       @[@"0"],
                       ];
    
    float height = 29;
    
    
    for (int i=0;i<array.count;i++) {
        
        NSArray *numbers = [array objectAtIndex:i];
        
        int count = 0;
        for (int j=0; j<bettingArray.count; j++) {
            
            NSString *str = [numbers firstObject];
            NSDictionary *dict = [bettingArray objectAtIndex:j];
            NSString *type = [dict objectForKey:@"type"];
            if ([type containsString:str]) {
                NSNumber *number = [dict objectForKey:@"count"];
                count = [number intValue];
                break;
            }
        }
        
        // 中奖号码被选中
        NSString *selectedNumber = nil;
        for (NSString *str in numbers) {
            if (prizeNumber.length > 0 && [str isEqualToString:prizeNumber]) {
                selectedNumber = str;
                break;
            }
        }
        
        
        CGRect frame = CGRectMake(0, (height -1) * i, self.width, height);
        ThriceResultComponent *view = [[ThriceResultComponent alloc] initWithNumbers:numbers selectedNumber:selectedNumber bettingCount:count frame:frame];
        [self addSubview:view];
    }
    
    UIImage *image = nil;
    if (prizeType == PrizeTypeAccept) {
        
        image = [UIImage imageNamed:@"thrice_component_accept_selected"];
    } else if (prizeType == PrizeTypeLucky) {
        
        image = [UIImage imageNamed:@"thrice_component_accept_normal"];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.centerX = self.width * 0.7;
    imageView.centerY = self.height / 2;
    [self addSubview:imageView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 66-1, 29*3-4)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = redColor;
    label.font = [UIFont systemFontOfSize:14];
    [label addSingleBorder:UIViewBorderDirectBottom color:grayColor width:separationWidth];
    [label addSingleBorder:UIViewBorderDirectTop color:grayColor width:separationWidth];
    [label addSingleBorder:UIViewBorderDirectRight color:grayColor width:separationWidth];
    label.text = @"1赔3";
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];
}

@end
