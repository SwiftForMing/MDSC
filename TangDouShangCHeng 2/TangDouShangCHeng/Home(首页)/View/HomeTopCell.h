//
//  HomeTopCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/5.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeGoodModel.h"

@interface HomeTopCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerX;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
//@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerWidth;
@property(nonatomic,strong)HomeGoodModel *goodModel;

@property(nonatomic,strong)HomeGoodModel *couPonModel;
//@property (weak, nonatomic) IBOutlet UILabel *couponName;
//@property (weak, nonatomic) IBOutlet UILabel *goodNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *couponPriceLabel;
//@property (weak, nonatomic) IBOutlet UIButton *lqBtn;
//@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;


//new
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UILabel *couponNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodNaLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponPrLabel;

@property (weak, nonatomic) IBOutlet UIButton *getBtn;

@end
