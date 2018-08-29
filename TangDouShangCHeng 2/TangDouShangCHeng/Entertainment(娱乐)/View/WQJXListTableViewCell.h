//
//  WQJXListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQJXListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numlabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *namaLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *hjIDLabel;

@property (weak, nonatomic) IBOutlet UILabel *xyhmLabel;

@property (weak, nonatomic) IBOutlet UILabel *joinNumLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@end
