//
//  AddNumberView.m
//  ShoppingCarDemo
//
//  Created by huanglianglei on 15/11/6.
//  Copyright © 2015年 huanglianglei. All rights reserved.
//

#import "AddNumberView.h"
#import "UConstants.h"
#import "UIViewExt.h"
@implementation AddNumberView{
    BOOL can;
    BOOL jcan;
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews{
    can = YES;
    jcan = YES;
    self.jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jianBtn.frame = CGRectMake(0,0, 30, 30);
    [self.jianBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.jianBtn.tag = 11;
//    [self.jianBtn setTitle:@"+" forState:0];
    [self.jianBtn setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    self.jianBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.jianBtn.layer.borderWidth = 1;
    self.jianBtn.layer.cornerRadius = 2;
    [self addSubview:self.jianBtn];
    
//    UIImageView *numberBg = [[UIImageView alloc]initWithFrame:CGRectMake(self.jianBtn.right+5, self.jianBtn.top, 70,30)];
//    numberBg.image = [UIImage imageNamed:@"numbe_bg_icon"];
//
//    [self addSubview:numberBg];
    
    
    self.numberLab = [[UITextField alloc]initWithFrame:CGRectMake(self.jianBtn.right+5, 0, 70, 30)];
    self.numberLab.delegate = self;
    self.numberLab.returnKeyType = UIReturnKeyDone;
    self.numberLab.text = @"1";
    self.numberLab.textAlignment = NSTextAlignmentCenter;
    self.numberLab.textColor = [UIColor darkGrayColor];
    self.numberLab.layer.borderColor = [UIColor grayColor].CGColor;
    self.numberLab.layer.borderWidth = 1;
    self.numberLab.layer.cornerRadius = 2;
    self.numberLab.font = SYSTEMFONT(12);
    [self addSubview:self.numberLab];
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addBtn.frame = CGRectMake(_numberLab.right+5,self.jianBtn.top, 30, 30);
    self.addBtn.tag = 12;
    self.addBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.addBtn.layer.borderWidth = 1;
    self.addBtn.layer.cornerRadius = 2;
    [self.addBtn setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
//    NSLog(@"textFieldDidEndEditing方法");
    if(self.delegate && [self.delegate respondsToSelector:@selector(changeNum:addNumberView:)]){
        
        [self.delegate changeNum:textField.text addNumberView:self];
    }
    
    
}

-(void)setNumberString:(NSString *)numberString{
    _numberString = numberString;
    self.numberLab.text = numberString;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)deleteBtnAction:(UIButton *)sender {
    
//    NSLog(@"减方法");
    if (jcan) {
        jcan = NO;
        if(self.delegate && [self.delegate respondsToSelector:@selector(deleteBtnAction:addNumberView:)]){
            
            [self.delegate deleteBtnAction:sender addNumberView:self];
        }
        [self performSelector:@selector(jcome) withObject:nil afterDelay:1];
    }else{
        MLog(@"addBtnAction");
    }
    
    
    
}

-(void)jcome{
    jcan = YES;
}


- (void)addBtnAction:(UIButton *)sender {
    
    if (can) {
        can = NO;
       
        if(self.delegate && [self.delegate respondsToSelector:@selector(addBtnAction:addNumberView:)]){
            
            [self.delegate addBtnAction:sender addNumberView:self];
        }
        [self performSelector:@selector(come) withObject:nil afterDelay:1];
    }else{
        MLog(@"addBtnAction");
    }
}
-(void)come{
    can =YES;
}


@end
