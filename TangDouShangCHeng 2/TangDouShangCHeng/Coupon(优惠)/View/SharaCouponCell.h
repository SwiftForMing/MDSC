//
//  SharaCouponCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/10/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharaCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *fzBtn;
@property (weak, nonatomic) IBOutlet UIView *sharaView;
@property (weak, nonatomic) IBOutlet UIImageView *qqSharaImage;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImage;
@property (weak, nonatomic) IBOutlet UITextView *rulerLabel;

@end
