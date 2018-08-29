//
//  FlyTextView.m
//  FlyLable
//
//  Created by ZhuJX on 16/5/16.
//  Copyright © 2016年 ZhuJX. All rights reserved.
//

#import "FlyTextView.h"

@implementation FlyTextView{
    CGFloat Y;
    CGFloat Height;
    CGRect  SuperRect;
}



-(instancetype)initWithY:(CGFloat)y AndText:(NSString*)text AndWordSize:(CGFloat)wordSize{
    SuperRect = [ [UIScreen mainScreen] bounds];
    CGFloat width = text.length * wordSize;
    Y = y;
    Height = wordSize * 1.2;
    self = [super initWithFrame:CGRectMake(SuperRect.size.width, y, width*2, Height)];
    if(self){
        self.text = text;
        self.font = [UIFont systemFontOfSize:wordSize];
        [self starFly];
    }
    return self;
}

-(void)starFly{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:5 animations:^{
        self.frame = CGRectMake(SuperRect.origin.x - self.frame.size.width, Y, self.frame.size.width, Height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
