//
//  CollertPrizeCellTimeLine.h
//  DuoBao
//
//  Created by clove on 11/7/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TimeLineStateNormal,
    TimeLineStateHighlighted,
    TimeLineStateEmpty,
} TimeLineState;

@interface CollertPrizeCellTimeLine : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *timeLineTop;
@property (weak, nonatomic) IBOutlet UIImageView *timeLineBottom;
@property (weak, nonatomic) IBOutlet UIImageView *timeLineDot;
@property (weak, nonatomic) IBOutlet UILabel *timeLineTitle;
@property (weak, nonatomic) IBOutlet UILabel *trailingLabel;
@property (nonatomic) BOOL hasDisclosureIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingLabelTrailingConstraint;

- (void)setTimeLineState:(TimeLineState)state;

@end
