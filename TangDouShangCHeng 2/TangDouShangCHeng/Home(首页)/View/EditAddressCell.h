//
//  EditAddressCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoverAddressListInfo.h"
#import "OrderModel.h"
#import "OrderAddressModel.h"
@interface EditAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *nomarLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property(nonatomic,strong)RecoverAddressListInfo *addressModel;
@property(nonatomic,strong)OrderModel *orderModel;
@property(nonatomic,strong)OrderAddressModel *orderAddressModel;
@end
