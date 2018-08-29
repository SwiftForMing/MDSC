//
//  LVCalendarCell.m
//  CalendarTest
//
//  Created by 吕亚斌 on 2018/4/8.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import "LVCalendarCell.h"
#import "UIColor+Hex.h"
@implementation LVCalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *selectionLayer = [[CALayer alloc] init];
        selectionLayer.backgroundColor = [UIColor colorWithHexString:@"#29B5EB"].CGColor;
        selectionLayer.actions = @{@"hidden": [NSNull null]};
//        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        CALayer *middleLayer = [[CALayer alloc] init];
        middleLayer.backgroundColor = [UIColor colorWithHexString:@"#29B5EB" alpha:0.3].CGColor;
        middleLayer.actions = @{@"hidden": [NSNull null]};
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        // false很关键默认选择有 true 默认选择有无
        self.shapeLayer.hidden = NO;
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.selectionLayer.frame = self.contentView.bounds;
    self.middleLayer.frame = self.contentView.bounds;
}
@end
