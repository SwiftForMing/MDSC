//
//  NumberInputField.h
//  DuoBao
//
//  Created by clove on 4/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumberInputField;

@protocol NumberInputFieldDelegate <NSObject>

- (void)numberInputFieldChanged:(NumberInputField *)numberInputField currentValue:(int)money;

@end

@interface NumberInputField : UIView
@property (nonatomic, weak) id delegate;
@property (nonatomic) int cardinalNumber;           // 计数基数
@property (nonatomic) int max;                      // value
@property (nonatomic) int min;                      // value
@property (nonatomic) int exchangeRate;             // 当前数值／兑换比例
@property (nonatomic) CoinType coinType;            // 货币类型
@property (nonatomic) BettingType bettingType;      // 押注类型

- (void)setDefaultValue:(int)defaultValue limit:(int)maxValue;
- (void)resetWidth:(float)width;

- (int)value;

// 显示份额
- (int)number;

- (void)grayStyle:(CGRect)frame;
- (void)whiteStyle:(CGRect)frame;

@end
