//
//  HomeOddsCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/5.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "HomeOddsCell.h"

@implementation HomeOddsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _leftImage.layer.masksToBounds = YES;
    _leftImage.layer.cornerRadius = 25;
    
    _rightImage.layer.masksToBounds = YES;
    _rightImage.layer.cornerRadius = 25;
    
    _centerImage.layer.masksToBounds = YES;
    _centerImage.layer.cornerRadius = 25;
    
//    _fireImage.layer.masksToBounds = YES;
//    _fireImage.layer.cornerRadius = 25;
  
}



@end
