//
//  WiningRecordTableViewCell.m
//  DuoBao
//
//  Created by clove on 4/17/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "WinningRecordTableViewCell.h"
#import "ZJRecordListInfo.h"

@implementation WinningRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codeUIViewContentModeScaleAspectFill
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bettingButton.layer.cornerRadius = _bettingButton.height * 0.1;
    _bettingButton.layer.masksToBounds = YES;
    _bettingButton.layer.borderWidth = 1.0f;
    _bettingButton.layer.borderColor = [UIColor colorFromHexString:@"e6322c"].CGColor;
    [_bettingButton setTitleColor:[UIColor colorFromHexString:@"e6322c"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)reloadWithData:(ZJRecordListInfo *)data ofUser:(NSString *)userID
{
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:data.good_header] placeholderImage:PublicImage(@"defaultImage")];
    _goodsTitleLabel.text =  [NSString stringWithFormat:@"%@", data.good_name];
    _periodLabel.text =  [NSString stringWithFormat:@"期号：%@", data.good_period];
    
    // 我已参与：
    NSMutableAttributedString *purchaseRecodeAttr = [[NSMutableAttributedString alloc] initWithString:@"我已参与："];
    
    // 我已参与：5
    NSString *number = data.count_num ?:@"";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:number attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
    [purchaseRecodeAttr appendAttributedString:attr];
    
    // 我已参与：5人次
    attr = [[NSAttributedString alloc] initWithString:@"人次"];
    [purchaseRecodeAttr appendAttributedString:attr];
    _bettingTimesLabel.attributedText = purchaseRecodeAttr;
    
    // 获得者：
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"获得者："];
    
    // 获得者：xxxxx
    NSString *name = data.nick_name ?:@"";
    attr = [[NSAttributedString alloc] initWithString:name attributes:nil];
    [attrString appendAttributedString:attr];
    _winnerLabel.attributedText = attrString;
    if ([data.get_type isEqualToString:@"转赠"]) {
        if ([data.order_status isEqualToString:@"已转赠"]){
          _acceptPrizeStatusLabel.text = @"转赠成功";
        }else{
         _acceptPrizeStatusLabel.text = @"请等待对方确认";
        }
       
    }else{
    
        _acceptPrizeStatusLabel.text = [data goodsStatus];
    }
    

    // 自己中奖了
    _winningButton.hidden = YES;
    _bettingButton.hidden = YES;
    _acceptPrizeStatusLabel.hidden = YES;
    _disclosureIndicator.hidden = YES;
    [_bettingButton setTitle:@"立即参与" forState:UIControlStateNormal];
    
    // 自己中奖了--- 三赔中奖 或者 一元购中奖
    if ( (userID != nil && [userID isEqualToString:data.win_user_id]) || [data hasWinThrice]) {
        _winningButton.hidden = NO;
        _acceptPrizeStatusLabel.hidden = NO;
        _disclosureIndicator.hidden = NO;
    } else {
        _bettingButton.hidden = NO;
    }
    
    // 仅中了三赔，一元购没中
    if ([data hasWinCrowdfunding] == NO && [data hasWinThrice] && [userID isEqualToString:[ShareManager shareInstance].userinfo.id ?:@""]) {
        
        _acceptPrizeStatusLabel.hidden = YES;
        _disclosureIndicator.hidden = YES;
        _winningButton.hidden = YES;
        _bettingButton.hidden = NO;
        [_bettingButton setTitle:@"再次参与" forState:UIControlStateNormal];
    }

    _thriceResultView.hidden = YES;
    self.height = 160;
    
    
    if (data.sanpeiRecordList.count > 0) {
        
        _thriceResultView.hidden = NO;
        
        NSString *prizeNumber = [data thricePrizeNumber];
        NSArray *thriceBettingArray = [ServerProtocol thriceBettingArrayWithData:data.sanpeiRecordList];
        BOOL hasAcceptWinningThirceCoin = [data hasAcceptWinningThirceCoin];
        PrizeType prizeType = PrizeTypeNone;
        if (hasAcceptWinningThirceCoin) {
            prizeType = PrizeTypeAccept;
        } else if ([data hasBettingThrice]) {
            prizeType = PrizeTypeLucky;
        }
        
        CGFloat thriceHeight = 112;
        self.height = 160 + thriceHeight;
        
        [_thriceResultView removeFromSuperview];
        _thriceResultView = [[ThriceResultView alloc] initWithFrame:CGRectMake(0, 160 - _bottomSeparationLine.height, self.width, thriceHeight) ];
        [self.contentView addSubview:_thriceResultView];
        
        // 这里不显示是否已经领取
        [_thriceResultView reloadWithPrizeNumber:prizeNumber bettingArray:thriceBettingArray prizeType:prizeType];
    }
}


@end
