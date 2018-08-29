//
//  FooterButtonView.m
//  DuoBao
//
//  Created by clove on 4/9/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "FooterButtonView.h"

@implementation FooterButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitle:(NSString *)title
{
    CGRect frame = CGRectMake(0, 0, ScreenWidth, 44+ 20);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.height = 44;
        button.width = ScreenWidth - 30 *2;
        button.centerX = self.width/2;
        button.centerY = self.height / 2;
        button.layer.cornerRadius = button.height * 0.1;
        button.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageFromContextWithColor:[UIColor defaultRedColor] size:button.size];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:button];
        
        _button = button;
    }

    return self;
}

@end
