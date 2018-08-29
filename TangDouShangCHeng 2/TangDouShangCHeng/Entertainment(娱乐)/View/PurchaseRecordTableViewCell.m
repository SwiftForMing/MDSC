//
//  PurchaseRecordTableViewCell.m
//  DuoBao
//
//  Created by clove on 12/5/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "PurchaseRecordTableViewCell.h"
#import "SelfDuoBaoRecordInfo.h"
#import "LDProgressView.h"

@implementation PurchaseRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _separationLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _bottomSeparationLine.backgroundColor = _separationLine.backgroundColor;
    
//    _luckyImageView.image = [UIImage imageNamed:@"lucky_flag_82_20.jpg"];
    
    _progressView.background = [UIColor colorFromHexString:@"ebebeb"];
    _progressView.color = [UIColor defaultRedButtonColor];
    [LDProgressView appearance].showBackgroundInnerShadow = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].showStroke = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].flat = @NO;
    [LDProgressView appearance].showText = @NO;
    _progressView.type = LDProgressSolid;
    _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
//    _purchaseMoreButton.backgroundColor = [UIColor defaultRedButtonColor];
//    [_purchaseMoreButton setTitle:@"追加" forState:UIControlStateNormal];
//    _purchaseMoreButton.layer.masksToBounds = YES;
//    _purchaseMoreButton.layer.cornerRadius = _purchaseMoreButton.height*0.1;
//    [_purchaseMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _purchaseNextButton.backgroundColor = [UIColor whiteColor];
    _purchaseNextButton.layer.masksToBounds = YES;
    _purchaseNextButton.layer.cornerRadius = _purchaseMoreButton.height*0.1;
    _purchaseNextButton.layer.borderWidth = 1.0f;
    _purchaseNextButton.layer.borderColor = [UIColor defaultRedButtonColor].CGColor;
    [_purchaseNextButton setTitle:@"再次购买" forState:UIControlStateNormal];
    [_purchaseNextButton setTitleColor:[UIColor defaultRedButtonColor] forState:UIControlStateNormal];
    
    UIButton *button = _purchaseNextButtonInRunLottery;
    button.backgroundColor = [UIColor whiteColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height*0.1;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor defaultRedButtonColor].CGColor;
    [button setTitle:@"再次购买" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor defaultRedButtonColor] forState:UIControlStateNormal];

    _runLotteryLabel.textColor = [UIColor defaultRedColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadWithData:(SelfDuoBaoRecordInfo *)data ofUser:(NSString *)userID
{
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:data.good_header] placeholderImage:PublicImage(@"defaultImage")];
    _goodsTitle.text =  [NSString stringWithFormat:@"%@", data.good_name];
    _orderSerialize.text =  [NSString stringWithFormat:@"期号：%@", data.good_period];

    // 我已参与：
    NSMutableAttributedString *purchaseRecodeAttr = [[NSMutableAttributedString alloc] initWithString:@"我已参与："];
    
    // 我已参与：5
    NSString *number = data.count_num ?:@"";
    NSAttributedString *attr = [[NSAttributedString alloc] initWithString:number attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
    [purchaseRecodeAttr appendAttributedString:attr];
    
    // 我已参与：5人次
    attr = [[NSAttributedString alloc] initWithString:@"人次"];
    [purchaseRecodeAttr appendAttributedString:attr];
    _recordLabel.attributedText = purchaseRecodeAttr;
    
    
    // 幸运号码
    _lotteryNumberLabel.text = [NSString stringWithFormat:@"幸运号码：%@", data.win_num];
    
    
    _runLotteryContainerView.hidden = YES;
    _winnerContainerView.hidden = YES;
    _progressContainerView.hidden = YES;

    NSString *statusStr = data.status;
    if ([statusStr isEqualToString:@"倒计时"]) {
        
        _runLotteryContainerView.hidden = NO;
    } else if ([statusStr isEqualToString:@"已揭晓"]) {
        
        _winnerContainerView.hidden = NO;
    } else if ([statusStr isEqualToString:@"进行中"]) {
        
        _progressContainerView.hidden = NO;
    }
    
    _progressView.animate = @NO;
    _progressView.progress = 0;
    _amountLabel.text = [NSString stringWithFormat:@"总需%@人次", data.need_people?:@""];
    _remainderLabel.text = [NSString stringWithFormat:@"剩余%d", [data remainderCount]];
    _progressView.progress = [data.progress intValue] / 100.0f;
    
    
    
    // 获得者：
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"获得者："];
    
    // 获得者：xxxxx
    NSString *name = data.nick_name ?:@"";
    attr = [[NSAttributedString alloc] initWithString:name attributes:nil];
    [attrString appendAttributedString:attr];
    _winnerLabel.attributedText = attrString;
    
    
    // 40人次
    attrString = [[NSMutableAttributedString alloc] initWithString:@""];

    // 40
    NSString *str = data.win_fight_time ?:@"";
    attr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
    [attrString appendAttributedString:attr];
    
    // 40人次
    attr = [[NSAttributedString alloc] initWithString:@"人次"];
    [attrString appendAttributedString:attr];
    _winnerPurchaseLabel.attributedText = attrString;
    
    _runLotteryLabel.text = @"即将揭晓 正在计算，请稍后...";
    
    // 自己中奖了
    self.backgroundColor = [UIColor whiteColor];
    _luckyImageView.hidden = YES;
    _moreRecordButton.hidden = NO;
    if (userID != nil && [userID isEqualToString:data.win_user_id]) {
//        self.backgroundColor = [UIColor colorFromHexString:@"fdffe5"];
        _luckyImageView.hidden = NO;
        _moreRecordButton.hidden = YES;
    }
    
    
    // not myself
    _winnerPurchaseLabel.right = _purchaseNextButton.left - 16;
    _purchaseMoreButton.hidden = NO;

    if (userID != nil && ![userID isEqualToString:[ShareManager shareInstance].userinfo.id]) {
        _purchaseNextButton.hidden = YES;
        _winnerPurchaseLabel.right = _purchaseNextButton.right;
        
        if ([statusStr isEqualToString:@"进行中"]) {
            _purchaseMoreButton.hidden = YES;
        }
    }
    
    _thriceResultView.hidden = YES;
    self.height = 160;
    
    
    if (data.sanpeiRecordList.count > 0) {
        
        _thriceResultView.hidden = NO;
        
        NSString *prizeNumber = [data thricePrizeNumber];
        NSArray *thriceBettingArray = [ServerProtocol thriceBettingArrayWithData:data.sanpeiRecordList];
        BOOL hasWinThrice = [data hasWinThrice];
        PrizeType prizeType = PrizeTypeNone;
        if (hasWinThrice) {
            prizeType = PrizeTypeAccept;
        }
        
        CGFloat thriceHeight = 112;
        self.height = 160 + thriceHeight;
        
        if (_thriceResultView == nil) {
            _thriceResultView = [[ThriceResultView alloc] initWithFrame:CGRectMake(0, 160 - _bottomSeparationLine.height, self.width, thriceHeight) ];
            [self.contentView addSubview:_thriceResultView];
        }
        
        // 这里不显示是否已经领取
        [_thriceResultView reloadWithPrizeNumber:prizeNumber bettingArray:thriceBettingArray prizeType:PrizeTypeNone];
    }
}

@end
