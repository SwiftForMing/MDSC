//
//  OrderCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/19.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *payPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *useCouponLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong,nonatomic) OrderModel *orderModel;
@end
