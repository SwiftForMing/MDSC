//
//  SharaCouponCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/10/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "SharaCouponCell.h"

@implementation SharaCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _fzBtn.layer.masksToBounds = YES;
    _fzBtn.layer.cornerRadius = 15;
}



@end
