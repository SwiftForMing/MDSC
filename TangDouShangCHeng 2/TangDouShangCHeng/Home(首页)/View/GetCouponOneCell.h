//
//  GetCouponOneCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodModel.h"
@interface GetCouponOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *getCouponBtn;

@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponGoodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,strong)HomeGoodModel *goodModel;
@end
