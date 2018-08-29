//
//  GoodsListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *processLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *allNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allNeedWidth;
@property (weak, nonatomic) IBOutlet UIImageView *tagFlag;
@property (weak, nonatomic) IBOutlet UILabel *needNum;

@end
