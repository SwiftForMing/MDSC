//
//  getGoodListCell.m
//  DuoBao
//
//  Created by 黎应明 on 2017/7/26.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "getGoodListCell.h"

@implementation getGoodListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
    _dianjiBtn.layer.borderColor = [UIColor redColor].CGColor;
    _dianjiBtn.layer.borderWidth = 1;
    _dianjiBtn.layer.masksToBounds = YES;
    _dianjiBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
