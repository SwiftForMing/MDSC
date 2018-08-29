//
//  FreePurchaseHistoryTableViewCell.h
//  DuoBao
//
//  Created by clove on 1/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsDetailInfo;

@interface FreePurchaseHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleRightLabel;

- (void)reloadWithData:(GoodsDetailInfo *)info;

@end
