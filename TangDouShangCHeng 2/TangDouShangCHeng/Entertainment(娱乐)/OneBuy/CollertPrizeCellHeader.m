//
//  CollertPrizeCellHeader.m
//  DuoBao
//
//  Created by clove on 11/3/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "CollertPrizeCellHeader.h"

@implementation CollertPrizeCellHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _goodsTitleLabel.textColor = [UIColor colorFromHexString:@"474747"];
    _buyRecords.textColor = [UIColor colorFromHexString:@"a3a3a3"];
    _goodsStatusLabel.textColor = [UIColor colorFromHexString:@"474747"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
