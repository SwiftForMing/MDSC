//
//  NoDateWarnView.m
//  Esport
//
//  Created by linqsh on 15/8/21.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "NoDateWarnView.h"

@implementation NoDateWarnView

- (id)initWithFrame:(CGRect)frame title:(NSString*)title image:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        if (imageName) {
            UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            imageview.center = self.center;
            imageview.image = [UIImage imageNamed:imageName];
            [self addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.frame.origin.y + imageview.height + 10, frame.size.width, 20)];
            label.text = title;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
            [self addSubview:label];
        }else{
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0 + 8, frame.size.width, 20)];
            label.text = title;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1];
            [self addSubview:label];
        }
       
    }
    
    return self;
}
@end
