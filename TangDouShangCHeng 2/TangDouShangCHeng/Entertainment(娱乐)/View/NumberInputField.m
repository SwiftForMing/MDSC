//
//  NumberInputField.m
//  DuoBao
//
//  Created by clove on 4/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "NumberInputField.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YYKitMacro.h"

@interface NumberInputField()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation NumberInputField

- (void)dealloc
{
    MLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadView];
    }
    
    return self;
}

- (void)grayStyle:(CGRect)frame
{
    self.frame = frame;
    
    UIColor *lightGrayColor = [UIColor colorFromHexString:@"f9f9f9"];
    UIColor *darkGrayColor = [UIColor colorFromHexString:@"a3a3a3"];
    UIColor *grayColor = [UIColor colorFromHexString:@"eeeeee"];
    UIColor *textColor = [UIColor colorFromHexString:@"474747"];
    
    UIView *view = self;
    view.layer.borderColor = grayColor.CGColor;
    view.layer.cornerRadius = view.height * 0.1f;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0f;
    
    _textField.background = nil;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = darkGrayColor;
    _textField.delegate = self;
    
    
//    UIButton *button = _leftButton;
//    button.backgroundColor = lightGrayColor;
////    [button setTitle:@"-" forState:UIControlStateNormal];
////    [button setTitleColor:darkGrayColor forState:UIControlStateNormal];
////    [button setBackgroundImage:nil forState:UIControlStateNormal];
////    [button setBackgroundImage:nil forState:UIControlStateSelected];
////    [button setBackgroundImage:nil forState:UIControlStateDisabled];
////    [button addSingleBorder:UIViewBorderDirectRight color:grayColor width:1.0];
//    
//    button = _rightButton;
//    button.backgroundColor = lightGrayColor;
//    [button setTitle:@"+" forState:UIControlStateNormal];
//    [button setTitleColor:darkGrayColor forState:UIControlStateNormal];
//    [button setBackgroundImage:nil forState:UIControlStateNormal];
//    [button setBackgroundImage:nil forState:UIControlStateSelected];
//    [button setBackgroundImage:nil forState:UIControlStateDisabled];
//    [button addSingleBorder:UIViewBorderDirectLeft color:grayColor width:1.0];
}

- (void)resetWidth:(float)width;
{
    self.width = width;
    _textField.width = width;
    _rightButton.right = width;
}

- (void)whiteStyle:(CGRect)frame
{
    self.frame = frame;
    UIColor *separationColor = [UIColor colorFromHexString:@"B5B5B5"];
    
    UIView *view = self;
    view.layer.borderColor = separationColor.CGColor;
    view.layer.cornerRadius = view.height * 0.1f;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0f;
    
    _textField.background = nil;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.textColor = [UIColor defaultRedColor];
    _textField.delegate = self;
    
    
    UIButton *button = _leftButton;
    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:@"-" forState:UIControlStateNormal];
    [button setTitleColor:separationColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateSelected];
    [button setBackgroundImage:nil forState:UIControlStateDisabled];
    [button setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateDisabled];
    [button addSingleBorder:UIViewBorderDirectRight color:separationColor width:1.0];
    
    button = _rightButton;
    button.backgroundColor = [UIColor whiteColor];
//    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:separationColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    [button setBackgroundImage:nil forState:UIControlStateSelected];
    [button setBackgroundImage:nil forState:UIControlStateDisabled];
    [button setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"plus_normal"] forState:UIControlStateDisabled];
    [button addSingleBorder:UIViewBorderDirectLeft color:separationColor width:1.0];
}

- (int)cardinalNumber
{
    if (_cardinalNumber <= 0) {
        _cardinalNumber = 1;
    }
    
    return _cardinalNumber;
}

- (void)leftButtonAction
{
    int value = [_textField.text intValue];
    value -= _cardinalNumber;
    _textField.text = [NSString stringWithFormat:@"%d", value];
    
    if (value <= _min) {
        _leftButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _min];
    }
    
    
    if (value >= _max) {
        _rightButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _max];
    }

    [self updateUserInterface];

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(numberInputFieldChanged:currentValue:)]) {
        [self.delegate numberInputFieldChanged:self currentValue:value];
    }
}

- (void)rightButtonAction
{
    int value = [_textField.text intValue];
    
    if (value == 1 && _cardinalNumber - value > 3) {
        
        value = _cardinalNumber;
    } else {
        value += _cardinalNumber;
    }
   
    _textField.text = [NSString stringWithFormat:@"%d", value];
    
    if (value <= _min) {
        _leftButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _min];
    }
    
    if (value >= _max) {
        _rightButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _max];
    }

    [self updateUserInterface];

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(numberInputFieldChanged:currentValue:)]) {
        [self.delegate numberInputFieldChanged:self currentValue:value];
    }
}

- (void)setDefaultValue:(int)defaultValue limit:(int)maxValue
{
    
    _textField.text = [NSString stringWithFormat:@"%d", defaultValue];
    
    _max = maxValue;
    
    [self updateUserInterface];
    
    [self addObserverForTextField];
}

- (void)updateUserInterface
{
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;

    int value = [_textField.text intValue];
    
    if (value >= _max) {
        _rightButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _max];
    }
    
    if (value <= _min) {
        _leftButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _min];
    }
}

- (void)loadView
{
    CGRect frame = self.bounds;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"input_number_bg"];
    UIImage *leftButtonImageNormal = [UIImage imageNamed:@"input_number_button_left_normal"];
    UIImage *leftButtonImageSelected = [UIImage imageNamed:@"input_number_button_left_selected"];
    UIImage *rightButtonImageNormal = [UIImage imageNamed:@"input_number_button_right_normal"];
    UIImage *rightButtonImageSelected = [UIImage imageNamed:@"input_number_button_right_selected"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:backgroundImage.size.width/2 topCapHeight:backgroundImage.size.height/2];
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.background = backgroundImage;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.textColor = [UIColor whiteColor];
    textField.font = [UIFont systemFontOfSize:13];
    textField.delegate = self;

    
    UIFont *font = [UIFont systemFontOfSize:13];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setBackgroundImage:leftButtonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:leftButtonImageSelected forState:UIControlStateSelected];
    [button setBackgroundImage:leftButtonImageSelected forState:UIControlStateDisabled];
    button.width = textField.height;
    button.height = button.width;
    [button addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    textField.leftView = button;
    _leftButton = button;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setBackgroundImage:rightButtonImageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:rightButtonImageSelected forState:UIControlStateSelected];
    [button setBackgroundImage:rightButtonImageSelected forState:UIControlStateDisabled];
    button.width = textField.height;
    button.height = button.width;
    [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = button;
    _rightButton = button;
    
    [self addSubview:textField];
    self.textField = textField;
}

- (void)addObserverForTextField
{
    
    UITextField *textField = self.textField;
    
    @weakify(self);
    
    __weak typeof(self) wself = self;
    [[[[self.textField.rac_textSignal map:^id(id value) {
        
        @strongify(self);
        
        NSString *text = value;
        int m = [text intValue];
        int cardinalNumber = wself.cardinalNumber;
        int max = wself.max;
        int min = wself.min;
        
        // 消除数字02中的0
        text = [NSString stringWithFormat:@"%d", m];
        
        //        if (m > max || m % cardinalNumber != 0) {
        if (m > max) {
            
            if (m > max) {
                m = max;
            }
            //            if ( m % cardinalNumber != 0) {
            //                m = (m / cardinalNumber + 1) * cardinalNumber;
            //            }
            
            text = [NSString stringWithFormat:@"%d", m];
        }
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:text];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
        return signal;
        
    }] throttle:0.5] switchToLatest] subscribeNext:^(id x) {
        
        @strongify(self);
        textField.text = [NSString stringWithFormat:@"%@",x];
        if (wself.delegate != nil && [wself.delegate respondsToSelector:@selector(numberInputFieldChanged:currentValue:)]) {
            [wself.delegate numberInputFieldChanged:wself currentValue:[textField.text intValue]];
        }
        
        [wself updateUserInterface];
         MLog(@"end %@", x);
        //更新text
        textField.text = [NSString stringWithFormat:@"%@",x];
    }];
}

- (int)value
{
    int value = [_textField.text intValue];
    value *= _exchangeRate;
    return value;
}

- (int)number
{
    int value = [_textField.text intValue];
    return value;
}

- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;
    
    int value = [_textField.text intValue];
    
    if (value <= _min) {
        _leftButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _min];
    }
    
    if (value >= _max) {
        _rightButton.enabled = NO;
        _textField.text = [NSString stringWithFormat:@"%d", _max];
    }
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(numberInputFieldChanged:currentValue:)]) {
        [self.delegate numberInputFieldChanged:self currentValue:value];
    }
}

@end
