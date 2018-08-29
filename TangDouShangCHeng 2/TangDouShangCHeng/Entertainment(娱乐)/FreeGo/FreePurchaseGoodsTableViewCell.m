//
//  FreePurchaseGoodsTableViewCell.m
//  DuoBao
//
//  Created by clove on 1/3/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "FreePurchaseGoodsTableViewCell.h"
#import "GoodsDetailInfo.h"

@implementation FreePurchaseGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self UIAdapte];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadWithArray:(NSArray *)array
{
    NSDictionary *firstDict = [array firstObject];
    NSDictionary *secondDict = [array lastObject];
    
    [self reloadLeftWithDictionray:firstDict];
    [self reloadRightWithDictionray:secondDict];
}

- (void)reloadLeftWithDictionray:(NSDictionary *)dict
{
    GoodsDetailInfo *model = [dict objectByClass:[GoodsDetailInfo class]];
    NSString *imagePath = [model firstImage];
    NSString *goodsName = [model goodsNameWithoutFreePurchase];
    NSString *weekStr = [dict objectForKey:@"week"];

    
    int week = [weekStr intValue];
    
    switch (week) {
        case 0:
        {
            weekStr = @"星期一";
            break;
        }
        case 1:
        {
            weekStr = @"星期二";
            break;
        }
        case 2:
        {
            weekStr = @"星期三";
            break;
        }
        case 3:
        {
            weekStr = @"星期四";
            break;
        }
        case 4:
        {
            weekStr = @"星期五";
            break;
        }
        case 5:
        {
            weekStr = @"星期六";
            break;
        }
        case 6:
        {
            weekStr = @"星期日";
            break;
        }
        default:
            break;
    }
    
    _titleLabel.text = weekStr;
    _leftLabel.text = goodsName;
    UIImage *defaultImage = PublicImage(@"defaultImage");
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaultImage];
}

- (void)reloadRightWithDictionray:(NSDictionary *)dict
{
    GoodsDetailInfo *model = [dict objectByClass:[GoodsDetailInfo class]];
    NSString *imagePath = [model firstImage];
    NSString *goodsName = [model goodsNameWithoutFreePurchase];
    
    _rightLabel.text = goodsName;
    UIImage *defaultImage = PublicImage(@"defaultImage");
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:defaultImage];
}

- (void)UIAdapte
{
    float rate = UIAdapteRate;
    
    for (UIView *view in self.contentView.subviews) {
        view.width *= rate;
        view.height *= rate;
        view.left *= rate;
        view.top *= rate;
        
        UIView *containerView = view;
        for (UIView *view in containerView.subviews) {
            view.width *= rate;
            view.height *= rate;
            view.left *= rate;
            view.top *= rate;
        }
    }
}



@end
