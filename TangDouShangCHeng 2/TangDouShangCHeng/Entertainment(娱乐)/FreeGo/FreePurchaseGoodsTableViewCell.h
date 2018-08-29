//
//  FreePurchaseGoodsTableViewCell.h
//  DuoBao
//
//  Created by clove on 1/3/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreePurchaseGoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)reloadWithArray:(NSArray *)array;

@end
