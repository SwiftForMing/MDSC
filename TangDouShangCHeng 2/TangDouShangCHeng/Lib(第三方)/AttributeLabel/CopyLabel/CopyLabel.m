//
//  CopyLabel.m
//  XHWiFi
//
//  Created by linqsh on 15/9/14.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "CopyLabel.h"

@implementation CopyLabel
{
    UIColor *color;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}

-(BOOL)canBecomeFirstResponder
{
    
    return YES;
    
}

//还需要针对复制的操作覆盖两个方法：
// 可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    return (action == @selector(copy:));
}

//针对于响应方法的实现

-(void)copy:(id)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    NSString *contentStr = self.text;
    
    if(_hideContentStr){
        pboard.string = [contentStr stringByReplacingOccurrencesOfString:_hideContentStr withString:@""];
    }
    else{
        pboard.string = self.text;
    }
}

-(void)attachTapHandler

{
    color = self.backgroundColor;
    self.userInteractionEnabled = YES;  //用户交互的总开关
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    longPressReger.minimumPressDuration = 1;
    [self addGestureRecognizer:longPressReger];
}

- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self)
        
    {
        [self attachTapHandler];
    }
    return self;
}

//同上

-(void)awakeFromNib

{
    
    [super awakeFromNib];
    
    [self attachTapHandler];  
    
}
//

-(void)handleTap:(UIGestureRecognizer*) recognizer

{
    
    [self becomeFirstResponder];
    
//    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@""
//                             
//                                                      action:@selector(copy:)];
    self.backgroundColor = [UIColor lightGrayColor];
    
    [[UIMenuController sharedMenuController] setMenuItems:nil];
    
    [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MenuCHidenNotif:) name:UIMenuControllerWillHideMenuNotification object:nil];
    
}

- (void)MenuCHidenNotif:(id)sender
{
    self.backgroundColor = color;
}

@end
