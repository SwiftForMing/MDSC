//
//  AddNumberView.h
//  ShoppingCarDemo
//
//  Created by huanglianglei on 15/11/6.
//  Copyright © 2015年 huanglianglei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddNumberViewDelegate;


@interface AddNumberView : UIView<UITextFieldDelegate>



@property (strong, nonatomic) UIButton *jianBtn;
@property (strong, nonatomic) UIButton *addBtn;
@property (strong, nonatomic) UITextField *numberLab;

@property (nonatomic,copy) NSString *numberString;

@property (nonatomic,assign) id<AddNumberViewDelegate> delegate;

@end


@protocol AddNumberViewDelegate <NSObject>

@optional


- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view;

- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view;

- (void)changeNum:(NSString *)num addNumberView:(AddNumberView *)view;

@end

