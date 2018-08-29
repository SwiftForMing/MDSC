//
//  JieXiaoListCollectionViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/13.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "JieXiaoListCollectionViewCell.h"
#import "GoodsDetailInfo.h"

@implementation JieXiaoListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JieXiaoListCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}

- (void)reloadWithData:(GoodsDetailInfo *)data
{
    _runLotteryContainer.hidden = YES;
    _djsView.hidden = YES;
    _warnView.hidden = YES;
    
    NSString *status = data.status;
    
    if([status isEqualToString:@"已揭晓"]) {
        _jiexiaoImage.hidden = NO;
        _runLotteryContainer.hidden = NO;
        
        UILabel *label = _winnerLabel;
        NSString *suffixStr = data.nick_name;
        NSString *prefixStr = @"获得者: ";
        UIColor *color = [UIColor colorFromHexString:@"55aaec"];
        NSAttributedString *substring = [[NSAttributedString alloc] initWithString:suffixStr attributes:@{NSForegroundColorAttributeName:color}];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:prefixStr];
        [attString appendAttributedString:substring];
        label.attributedText = attString;
        
        label = _lotteryNumberLabel;
        suffixStr = data.win_num;
        prefixStr = @"幸运号: ";
        color = [UIColor colorFromHexString:@"fb6165"];
        substring = [[NSAttributedString alloc] initWithString:suffixStr attributes:@{NSForegroundColorAttributeName:color}];
        attString = [[NSMutableAttributedString alloc] initWithString:prefixStr];
        [attString appendAttributedString:substring];
        label.attributedText = attString;
        
        label = _joinNumberLabel;
        suffixStr = data.play_num;
        prefixStr = @"本次参与: ";
        label.text = [NSString stringWithFormat:@"%@%@人次", prefixStr, suffixStr];
        
        label = _runLotteryTimeLabel;
        suffixStr = data.lottery_time;
        prefixStr = @"揭晓时间: ";
        label.text = [NSString stringWithFormat:@"%@%@", prefixStr, suffixStr];
        
    } else if([status isEqualToString:@"倒计时"]) {
         _jiexiaoImage.hidden = YES;
        NSString *shouldShowCountdown = data.is_show_daojishi;
        if ([shouldShowCountdown isEqualToString:@"y"]) {
            _djsView.hidden = NO;
        } else {
            _warnView.hidden = NO;
        }
    } else {
        _jiexiaoImage.hidden = YES;
        _warnView.hidden = NO;
    }

    
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:data.good_header] placeholderImage:PublicImage(@"defaultImage")];
    _goodsNameLabel.text = [NSString stringWithFormat:@"[第%@期]%@", data.good_period, data.good_name];
    if (_goodsNameLabel.numberOfLines == 1) {
        _goodsNameLabel.text = [NSString stringWithFormat:@"[第%@期]%@\n", data.good_period, data.good_name];
    }
    
    
    UIImageView *imageView = _goodsTypeImageView;
    imageView.hidden = YES;
    imageView.frame = CGRectMake(10 * UIAdapteRate, 0, 28* UIAdapteRate, 31 * UIAdapteRate);
    
//    if (data.good_single_price.intValue == 10) {
//        imageView.hidden = NO;
//        imageView.image = [UIImage imageNamed:@"cont_ten_flag.png"];
//    }
    
    NSString *str = data.part_sanpei;
    if ([str isEqualToString:@"y"]) {
        imageView.hidden = NO;
        imageView.image = [UIImage imageNamed:@"icon_thrice"];
        float rate = 0.8 * UIAdapteRate;
        imageView.frame = CGRectMake(8 * UIAdapteRate, 4 * UIAdapteRate, 61 * rate, 37 * rate);
    }
    
}

@end
