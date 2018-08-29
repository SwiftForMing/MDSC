//
//  HaveCouponCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodModel.h"
#import "BuyCouponModel.h"
@interface HaveCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property(nonatomic,strong)HomeGoodModel *goodModel;
@property(nonatomic,strong)BuyCouponModel *buyCouponModel;
@end
