//
//  CollertPrizeCellTimeLine.m
//  DuoBao
//
//  Created by clove on 11/7/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "CollertPrizeCellTimeLine.h"

@implementation CollertPrizeCellTimeLine

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.indentationLevel = 2;
    self.indentationWidth = 10;
    self.timeLineDot.layer.cornerRadius = 5;
    self.trailingLabel.textColor = [UIColor colorFromHexString:@"a3a3a3"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    float indentPoints = self.indentationLevel * self.indentationWidth;
    CGFloat defaultMarginOfCell = self.layoutMargins.left + self.contentView.layoutMargins.left;
    CGFloat leftMargin = defaultMarginOfCell + 2;

    self.contentView.frame = CGRectMake(
                                        leftMargin,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - leftMargin - defaultMarginOfCell,
                                        self.contentView.frame.size.height
                                        );
    
    if (_hasDisclosureIndicator) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        imageView.centerY = self.trailingLabel.centerY;
        imageView.right = self.contentView.width - (imageView.width - 5);
        self.trailingLabelTrailingConstraint.constant = imageView.width + 7;
        [self.contentView addSubview:imageView];
    }
}

- (void)setTimeLineState:(TimeLineState)state
{
    UIColor *darkColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    UIColor *lightColor = [UIColor colorFromHexString:@"eeeeee"];
    
    _timeLineTitle.textColor = [UIColor defaultColor474747];
    
    switch (state) {
        case TimeLineStateNormal:
        {
            _timeLineDot.backgroundColor = darkColor;
            _timeLineTop.backgroundColor = darkColor;
            _timeLineBottom.backgroundColor = darkColor;
        }
            break;
        case TimeLineStateHighlighted:
        {
            _timeLineTop.backgroundColor = darkColor;
            _timeLineBottom.backgroundColor = lightColor;
            _timeLineDot.backgroundColor = [UIColor defaultRedColor];
            _timeLineTitle.textColor = [UIColor defaultRedColor];
        }
            break;
        case TimeLineStateEmpty:
        {
            _timeLineDot.backgroundColor = [UIColor clearColor];
            _timeLineDot.layer.masksToBounds = YES;
            _timeLineDot.layer.borderWidth = 1;
            _timeLineDot.layer.borderColor = lightColor.CGColor;
            _timeLineTop.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
            _timeLineBottom.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
        }
            break;
            
        default:
            break;
    }
}

- (void)setHasDisclosureIndicator:(BOOL)hasDisclosureIndicator
{
    _hasDisclosureIndicator = hasDisclosureIndicator;
    [self setNeedsLayout];
}

@end
