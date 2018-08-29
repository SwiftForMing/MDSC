//
//  EditAddressCell.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "EditAddressCell.h"

@implementation EditAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setOrderModel:(OrderModel *)orderModel{
    
    _nameLabel.text = orderModel.consignee_name;
    _telLabel.text = orderModel.consignee_tel;
    _addressLabel.text = [NSString stringWithFormat:@"%@",orderModel.consignee_address];
    
}

-(void)setAddressModel:(RecoverAddressListInfo *)addressModel{
    
    _nameLabel.text = addressModel.user_name;
    _telLabel.text = addressModel.user_tel;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",addressModel.address,addressModel.detail_address];
}

-(void)setOrderAddressModel:(OrderAddressModel *)orderAddressModel{
    
    _nameLabel.text = orderAddressModel.user_name;
    _telLabel.text = orderAddressModel.user_tel;
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",orderAddressModel.city_name,orderAddressModel.detail_address];
}
@end
