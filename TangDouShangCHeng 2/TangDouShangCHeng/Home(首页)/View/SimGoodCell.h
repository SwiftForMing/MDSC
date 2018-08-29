//
//  SimGoodCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodModel.h"
#import "OrderModel.h"
#import "BuyGoodModel.h"
@interface SimGoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodColorLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNumLabel;
@property(nonatomic,strong)HomeGoodModel *goodModel;
@property(nonatomic,strong)OrderModel  *orderModel;
@property(nonatomic,strong)BuyGoodModel *buyModel;
@end
