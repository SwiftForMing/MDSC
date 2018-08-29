//
//  newGoodsCell.h
//  DuoBao
//
//  Created by 黎应明 on 2017/6/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListInfo.h"
#import <LDProgressView.h>
@interface newGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftPriceButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftProcessNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftAddButton;
@property (weak, nonatomic) IBOutlet UIView *leftView;
//@property (weak, nonatomic) IBOutlet UIButton *leftAddShopCar;
@property (weak, nonatomic) IBOutlet UILabel *leftBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftNeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftRemaLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftAddShopCarBtn;

@property (weak, nonatomic) IBOutlet LDProgressView *lefeNewProcess;


@property (weak, nonatomic) IBOutlet UIButton *rightPriceButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightPhotoImage;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightProcessNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightAddButton;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *rightBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightRemaLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightAddShopCarBtn;

@property (weak, nonatomic) IBOutlet UILabel *rightNeedLabel;
@property (weak, nonatomic) IBOutlet LDProgressView *rightNewProcess;

@end
