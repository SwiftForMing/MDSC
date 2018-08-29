//
//  EntBuyCouPonCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@protocol EntBuyDelegate // 代理传值方法
- (void)sendValue:(int)value Model:(CouponModel *)model;

@end

@interface EntBuyCouPonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerWidth;
@property (weak, nonatomic) IBOutlet UIImageView *goodHeader;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
//@property (weak, nonatomic) IBOutlet UIImageView *effectImageView;
//@property (weak, nonatomic) IBOutlet UILabel *afterPriceLabel;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *RMBLabel;

@property(nonatomic,strong)CouponModel *couponModel;
// 委托代理人，代理一般需使用弱引用(weak)
@property (weak, nonatomic) id delegate;
@end
