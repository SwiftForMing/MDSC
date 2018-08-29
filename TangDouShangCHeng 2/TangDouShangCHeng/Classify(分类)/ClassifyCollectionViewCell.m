//
//  ClassifyCollectionViewCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "ClassifyCollectionViewCell.h"

@implementation ClassifyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.borderColor = [UIColor colorFromHexString:@"f7f7f7"].CGColor;
//    self.layer.borderWidth = 0.5;
    
}

-(void)setTypeModel:(GoodTypeModel *)typeModel{
       NSURL *url = [[NSURL alloc]initWithString:typeModel.goods_type_header];
    [_goodImageView sd_setImageWithURL:url placeholderImage:nil];
    _titleLabel.text = typeModel.goods_type_name;
    _desLabel.text = typeModel.remark;
    _typeModel = typeModel;
}
@end
