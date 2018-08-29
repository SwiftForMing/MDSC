//
//  ThriceResultComponent.m
//  DuoBao
//
//  Created by clove on 4/16/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "ThriceResultComponent.h"

@interface ThriceResultComponent()
@property (nonatomic, strong) NSArray *numberButtons;


@end


@implementation ThriceResultComponent

- (instancetype)initWithNumbers:(NSArray *)numberArray selectedNumber:(NSString *)selectedNumber bettingCount:(int)count frame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        
        _numberArray = numberArray;
        _selectedNumber = selectedNumber;
        _count = count;
        
        UIColor *grayColor = [UIColor colorFromHexString:@"eeeeee"];
        UIColor *redColor = [UIColor colorFromHexString:@"fb6165"];
        UIColor *blueColor = [UIColor colorFromHexString:@"9857ff"];
        UIColor *orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
        float margin = 16;
        float separationWidth = 1;
        float buttonLeft = 15;
        float buttonWidth = 29;
        float buttonHeight = self.height;
        
        NSString *title = @"1赔3";
        UIColor *color = redColor;
        UIImage *selectedNumberImage = [UIImage imageNamed:@"thrice_component_win_number_bg_red"];
        UIImage *selectedImage = [UIImage imageNamed:@"thrice_component_win_red"];
        
        if ([[numberArray firstObject] isEqualToString:@"0"]) {
            title = @"1赔8";
            color = blueColor;
            selectedNumberImage = [UIImage imageNamed:@"thrice_component_win_number_bg_blue"];
            selectedImage = [UIImage imageNamed:@"thrice_component_win_blue"];
        }
        
        [self addSingleBorder:UIViewBorderDirectTop color:grayColor width:separationWidth];
        [self addSingleBorder:UIViewBorderDirectBottom color:grayColor width:separationWidth];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 29)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = color;
        label.font = [UIFont systemFontOfSize:14];
        [label addSingleBorder:UIViewBorderDirectRight color:grayColor width:separationWidth];
        label.text = title;
        [self addSubview:label];
        
        selectedImage = [selectedImage stretchableImageWithLeftCapWidth:selectedImage.size.width - 10 topCapHeight:selectedImage.size.height/2];
        UIImage *image = [UIImage imageFromContextWithColor:[UIColor colorWithWhite:1.0 alpha:0]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image highlightedImage:selectedImage];
        imageView.frame = CGRectMake(label.width, 0, self.width-label.width, self.height + 2);
        [self addSubview:imageView];
        
        buttonLeft += label.width;

        BOOL isSelected = NO;
        NSMutableArray *buttonArray = [NSMutableArray array];
        NSArray *array = numberArray;
        for (int i=0; i< array.count; i++) {
            NSString *str = [array objectAtIndex:i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 29)];
            label.font = [UIFont fontWithName:@"Arial-BoldMT" size:13];
            label.textColor = color;
            label.frame = CGRectMake(buttonLeft + i*buttonWidth, 0, buttonWidth, buttonHeight);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = str;
            [buttonArray addObject:label];
            
            if (_selectedNumber.length > 0 && [str isEqualToString:_selectedNumber]) {
                isSelected = YES;
                UIImageView *imageView = [[UIImageView alloc] initWithImage:selectedNumberImage];
                imageView.frame = label.frame;
                [self addSubview:imageView];
                label.textColor = [UIColor whiteColor];
            }
            
            [self addSubview:label];
        }
        _numberButtons = buttonArray;
        
        // 有icon的小米数量
        NSString *str = [NSString stringWithFormat:@"%d", _count];
        UIView *view = [self thriceCoinViewWithStr:str fontSize:12];
        view.centerY = self.height/2;
        view.right = ScreenWidth - margin;
        [self addSubview:view];
        
        
        if (isSelected) {
            imageView.highlighted = YES;
        }
        
    }
    
    return self;
}

- (UIView *)thriceCoinViewWithStr:(NSString *)coinStr fontSize:(int)size
{
    if ([coinStr intValue] == 0) {
        return nil;
    }
    
    UIColor *orangeCoinColor = [UIColor colorFromHexString:@"fb9700"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = coinStr;
    label.textColor = orangeCoinColor;
    label.font = [UIFont systemFontOfSize:size];
    [label sizeToFit];
    
    
    UIImageView *imageVeiw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_thrice_coin_17_21"]];
    imageVeiw.left = label.width + 3;
    imageVeiw.centerY = label.height / 2;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.width = label.width + imageVeiw.width + 3;
    view.height = label.height;
    [view addSubview:label];
    [view addSubview:imageVeiw];
    view.clipsToBounds = YES;
    
    return view;
}


@end
