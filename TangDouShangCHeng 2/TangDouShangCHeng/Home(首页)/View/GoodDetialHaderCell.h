//
//  GoodDetialHaderCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodModel.h"
@interface GoodDetialHaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *normalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceAllLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *goonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterPriceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *baoyouLabel;
@property(nonatomic,strong)HomeGoodModel *goodModel;
@end
