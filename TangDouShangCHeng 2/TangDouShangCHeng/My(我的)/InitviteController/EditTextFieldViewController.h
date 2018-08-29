//
//  EditTextFieldViewController.h
//  LLLM
//
//  Created by clove on 10/23/15.
//  Copyright (c) 2015 clove. All rights reserved.
//

#import "BaseTableViewController.h"

@interface EditTextFieldViewController : BaseTableViewController
- (instancetype)initWithText:(NSString *)text placeholder:(NSString *)placeholder completed:(void (^)(BOOL result, NSString *changedText))block;
- (instancetype)initWithText:(NSString *)text placeholder:(NSString *)placeholder indicatorStringForHeader:(NSString *)indicatorString completed:(void (^)(BOOL result, NSString *changedText))block;

@end
