//
//  ThriceResultView.h
//  DuoBao
//
//  Created by clove on 4/15/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThriceResultView : UIView

//- (instancetype)initWithFrame:(CGRect)frame prizeNumber:(NSString *)prizeNumber bettingArray:(NSArray *)bettingArray prizeType:(PrizeType)prizeType;
- (void)reloadWithPrizeNumber:(NSString *)prizeNumber bettingArray:(NSArray *)bettingArray prizeType:(PrizeType)prizeType;

@end
