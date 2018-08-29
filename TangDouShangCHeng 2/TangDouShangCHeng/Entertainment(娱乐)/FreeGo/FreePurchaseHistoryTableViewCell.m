
//
//  FreePurchaseHistoryTableViewCell.m
//  DuoBao
//
//  Created by clove on 1/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "FreePurchaseHistoryTableViewCell.h"
#import "GoodsDetailInfo.h"

@implementation FreePurchaseHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadWithData:(GoodsDetailInfo *)data
{
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.good_header] placeholderImage:PublicImage(@"defaultImage")];
    
    UIColor *markColor = [UIColor colorFromHexString:@"f25555"];
    UIColor *markColorBlack = [UIColor colorFromHexString:@"474747"];
    
    NSString *colorStr = data.win_user.nick_name;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"获得者: "];
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:colorStr attributes:@{NSForegroundColorAttributeName:markColor}];
    [attributedString appendAttributedString:attr];
    _secondLabel.attributedText = attributedString;
    
    colorStr = [data goodsNameWithoutFreePurchase];
    attributedString = [[NSMutableAttributedString alloc] initWithString:@"零元购: "];
    attr = [[NSAttributedString alloc] initWithString:colorStr attributes:@{NSForegroundColorAttributeName:markColorBlack}];
    [attributedString appendAttributedString:attr];
    _firstLabel.attributedText = attributedString;
    
    colorStr = [NSString stringWithFormat:@"%@(唯一不变标识)", data.win_user_id];
    attributedString = [[NSMutableAttributedString alloc] initWithString:@"获奖ID: "];
    attr = [[NSAttributedString alloc] initWithString:colorStr attributes:@{NSForegroundColorAttributeName:markColorBlack}];
    [attributedString appendAttributedString:attr];
    _thirdLabel.attributedText = attributedString;
    
    colorStr = data.lottery_num_id;
    attributedString = [[NSMutableAttributedString alloc] initWithString:@"幸运号码: "];
    attr = [[NSAttributedString alloc] initWithString:colorStr attributes:@{NSForegroundColorAttributeName:markColor}];
    [attributedString appendAttributedString:attr];
    _fourthLabel.attributedText = attributedString;
    
    colorStr = [NSString stringWithFormat:@"第%@期  ", data.good_period];
    attributedString = [[NSMutableAttributedString alloc] initWithString:colorStr attributes:@{NSForegroundColorAttributeName:[UIColor darkTextColor]}];
    NSString *normalStr = [NSString stringWithFormat:@"[揭晓时间: %@]", data.lottery_time];
    attr = [[NSMutableAttributedString alloc] initWithString:normalStr];
    [attributedString appendAttributedString:attr];
    _titleRightLabel.attributedText = attributedString;
}

@end
