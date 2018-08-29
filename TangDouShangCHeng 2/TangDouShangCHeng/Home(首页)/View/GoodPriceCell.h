//
//  GoodPriceCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodModel.h"
@interface GoodPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *transPriceLabel;
@property(nonatomic,strong)HomeGoodModel *goodModel;
@end
