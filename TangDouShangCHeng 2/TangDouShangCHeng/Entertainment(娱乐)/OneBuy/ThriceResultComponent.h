//
//  ThriceResultComponent.h
//  DuoBao
//
//  Created by clove on 4/16/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThriceResultComponent : UIView

@property (nonatomic, copy) NSArray *numberArray;
@property (nonatomic, copy) NSString *selectedNumber;
@property (nonatomic) int count;


- (instancetype)initWithNumbers:(NSArray *)numberArray selectedNumber:(NSString *)selectedNumber bettingCount:(int)count frame:(CGRect)frame;


@end
