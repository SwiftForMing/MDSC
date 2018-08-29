//
//  ZJRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CollectPrizeViewController.h"
#import "CollertPrizeCellHeader.h"
#import "CollertPrizeCellTimeLine.h"
#import "CollertPrizeCardInfoView.h"
#import "UIImage+Color.h"
#import "BottomToolBar.h"
#import "CollertPrizeSelectView.h"
#import "SafariViewController.h"
#import "WantToSDViewController.h"
#import "GoodsDetailInfoViewController.h"
#import <CoreText/CoreText.h>
#import "CardIntroduceViewController.h"
#import "MoreCardTableViewController.h"

#import "DLAVAlertView.h"
#import "DLAVAlertViewTheme.h"
#import "DLAVAlertViewTextFieldTheme.h"
#import "DLAVAlertViewButtonTheme.h"

//#import "TransferViewController.h"
#define SubviewLeftMargin 16
#define SubviewTopMargin 8
#define SubviewBottomMargin -11
#define CellHeight 44
#define GrayBackgroundColor [UIColor colorWithWhite:0.9686 alpha:1.0]



@interface CollectPrizeViewController ()<WantToSDViewControllerDelegate>
{
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation CollectPrizeViewController

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
//    [self setTabelViewRefresh];
    [self addBottomToolBar];
    [_myTableView setContentInset:UIEdgeInsetsMake(_myTableView.contentInset.top, 0, 49, 0)];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setOrderInfo:(ZJRecordListInfo *)orderInfo
{
    _orderInfo = orderInfo;
    
    if ([_orderInfo.order_status isEqualToString:@"已发货"]) {
        [self updateOrder];
    }
}

- (void)updateOrder
{
//    CollertPrizeSelectView *view = (CollertPrizeSelectView *)[button superview];
    
    
        _orderInfo.order_status = @"已发货";
//        _orderInfo.get_type = [view collectPrizeModeStringValue];
    
        __weak typeof(self) weakSelf = self;
        
//        HttpHelper *helper = [HttpHelper helper];
        [HttpHelper getFightOneWinRecord:[ShareManager shareInstance].userinfo.id
                         orderID:_orderInfo.order_id
                            order_type:@""
                                success:^(NSDictionary *resultDic){
                                    
                                    int result = [[resultDic objectForKey:@"status"] intValue];
                                    if (result == 0) {
                                        
                                        NSDictionary *dict = [resultDic objectForKey:@"data"];
                                        if (dict) {
                                            ZJRecordListInfo *object = [dict objectByClass:[ZJRecordListInfo class]];
                                            weakSelf.orderInfo.rechargeList = object.rechargeList;
                                        }
                                        
                                        _orderInfo.order_status = @"已发货";
                                        [weakSelf.myTableView reloadData];
                                    }
                                }fail:^(NSString *decretion){
                                }];
}

- (void)initVariable
{
    self.title = @"中奖记录";
    pageNum = 1;
    dataSourceArray = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_myTableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];    
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
    UIControl *rightItemControl = [[UIControl alloc] initWithFrame:CGRectMake(ScreenWidth-50, 0, 40, 44)];
    [rightItemControl addTarget:self action:@selector(setGiftToOther:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *rightLbel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 40, 20)];
    rightLbel.text = @"转让";
    rightLbel.textColor = [UIColor whiteColor];
    [rightItemControl addSubview:rightLbel];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemControl];
}
-(void)setGiftToOther:(UIButton*)btn{
    
//    TransferViewController *vc = [[TransferViewController alloc]init];
//    vc.order_type = @"donor";
//    vc.goodInfo = _orderInfo;
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView             // Default is 1 if not implemented
{
    return 2;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 1;
    if (section == 1) {
        num = 5;
    }
    
    return num;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 130;
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            height = 44;
        } else {
            
            NSString *stauts = [_orderInfo goodsStatus];
            
            if ([stauts isEqualToString:@"待发货"]||[stauts isEqualToString:@"别人的中奖列表"]) {
                height = [self configureCollectPrizeInterface:indexPath.row];
            } else if ([stauts isEqualToString:@"等待商品派发"]) {
                height = [self configureWaitInterface:indexPath.row];
            } else if ([stauts isEqualToString:@"已兑换小米"]) {
                height = [self configureCollectPrizeToCoinInterface:indexPath.row];
            } else if ([stauts isEqualToString:@"卡密已派发"]) {
                height = [self configReceivedCardInfoInterface:indexPath.row];
            }
        }
    }

    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    if (section == 0) {
        height = 10;
    }
    
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0)
//{
//    CGFloat height = 130;
//    
//    return height;
//}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJRecordListInfo *orderInfo = _orderInfo;
    UITableViewCell *cell = nil;

//     NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellHeader" owner:nil options:nil];
//     CollertPrizeCellHeader *object = [nib objectAtIndex:0];
//     cell = object;

    
    if (indexPath.section == 0) {
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellHeader" owner:nil options:nil];
        CollertPrizeCellHeader *object = [nib objectAtIndex:0];
        [object.goodsImageView sd_setImageWithURL:[NSURL URLWithString:orderInfo.good_header] placeholderImage:PublicImage(@"defaultImage")];
        object.goodsTitleLabel.text = [NSString stringWithFormat:@"[第%@期]%@", orderInfo.win_num, orderInfo.good_name];
        object.buyRecords.text = [NSString stringWithFormat:@"转出ID：%@", orderInfo.donor_user_id];
        cell = object;
        
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[orderInfo goodsStatus] attributes:@{NSForegroundColorAttributeName:[UIColor defaultRedColor]}];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"商品状态："];
        [attString appendAttributedString:str2];
        object.goodsStatusLabel.attributedText = attString;

    } else if (indexPath.section == 1){
        
        // Cell 商品跟踪
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            cell.textLabel.text = @"商品跟踪";
            cell.textLabel.font = [UIFont systemFontOfSize:15.];
            cell.textLabel.textColor = [UIColor colorFromHexString:@"474747"];
            
            CGFloat defaultMarginOfCell = cell.layoutMargins.left + cell.contentView.layoutMargins.left;
            cell.separatorInset = UIEdgeInsetsMake(0, defaultMarginOfCell, 0, defaultMarginOfCell);
            
        } else {
            
            
            NSString *stauts = [_orderInfo goodsStatus];
            NSLog(@"stauts%@",stauts);
            if ([stauts isEqualToString:@"待发货"]||[stauts isEqualToString:@"别人的中奖列表"]) {
                cell = [self cellForCollectPrize:indexPath.row];
            } else if ([stauts isEqualToString:@"等待商品派发"]) {
                cell = [self cellForWait:indexPath.row];
            } else if ([stauts isEqualToString:@"已兑换小米"]) {
                cell = [self cellForCollectPrizeToCoin:indexPath.row];
            } else if ([stauts isEqualToString:@"卡密已派发"]) {
                cell = [self cellForReceivedCard:indexPath.row];
            }
            
            
//            // 设置timeline 状态
            if ([self indexOfCurrentProgress] > indexPath.row) {
                [(CollertPrizeCellTimeLine *)cell setTimeLineState:TimeLineStateNormal];
            } else if ([self indexOfCurrentProgress] == indexPath.row) {
                [(CollertPrizeCellTimeLine *)cell setTimeLineState:TimeLineStateHighlighted];
            } else {
                [(CollertPrizeCellTimeLine *)cell setTimeLineState:TimeLineStateEmpty];
            }

        }
    }
  
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action

// 再次参与
- (void)rightBottomButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.tabBarController setSelectedIndex:0];
}

// 使用说明
- (void)instructionAction
{
    CardIntroduceViewController *vc = [[CardIntroduceViewController alloc] initWithNibName:@"CardIntroduceViewController" bundle:nil];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

// 查看卡密
- (void)reviewRechargeAction
{
    MoreCardTableViewController *vc = [[MoreCardTableViewController alloc] initWithNibName:@"MoreCardTableViewController" bundle:nil];
    vc.rechargeArray = _orderInfo.rechargeList;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

// 晒单分享
- (void)shareAction
{
    WantToSDViewController *vc = [[WantToSDViewController alloc]initWithNibName:@"WantToSDViewController" bundle:nil];
    vc.detailInfo = _orderInfo;
    vc.delegate = self;
//     
    [self.navigationController pushViewController:vc animated:YES];
}

// 复制充值卡卡号到剪切板
- (void)numberCopyAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [_orderInfo firstCardNumber];
    
    [Tool showPromptContent:@"复制成功"];
}

// 复制充值卡密码到剪切板
- (void)passwordCopyAction
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [_orderInfo firstCardPassword];
    
    [Tool showPromptContent:@"复制成功"];
}

// 充值到手机
- (void)rechargeAction
{
    [self showAlertView];
}

// 选择兑奖方式
- (void)collectPrizeAction:(UIButton *)button
{
    CollertPrizeSelectView *view = (CollertPrizeSelectView *)[button superview];
    
    if ([_orderInfo.order_status isEqualToString:@"待发货"]) {
        
        _orderInfo.order_status = @"已发货";
        _orderInfo.get_type = [view collectPrizeModeStringValue];
        
        __weak typeof(self) weakSelf = self;
       
        [HttpHelper setCardCollectPrizeMode:_orderInfo.order_id
                         virtualGetType:_orderInfo.get_type
                                success:^(NSDictionary *resultDic){
                                    
                                    int result = [[resultDic objectForKey:@"status"] intValue];
                                    if (result == 0) {
                                        
                                        NSDictionary *dict = [resultDic objectForKey:@"data"];
                                        if (dict) {
                                            ZJRecordListInfo *object = [dict objectByClass:[ZJRecordListInfo class]];
                                            weakSelf.orderInfo.rechargeList = object.rechargeList;
                                            weakSelf.orderInfo.order_status = object.order_status;
                                        }
                                        
                                        [weakSelf.myTableView reloadData];
                                        
                                        // 数据库未保存，自动从网络更新
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserInfo object:nil];

                                    } else {
                                        
                                        _orderInfo.order_status = @"待发货";
                                        _orderInfo.get_type = nil;
                                        [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                    }

                                }fail:^(NSString *decretion){
                                    
                                    _orderInfo.order_status = @"待发货";
                                    _orderInfo.get_type = nil;
                                    [Tool showPromptContent:decretion onView:self.view];
                                }];
    }
}

// 阅读米花糖服务协议
- (void)legalAgreementAction
{
    SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
    vc.title = @"服务协议";
    vc.urlStr = [NSString stringWithFormat:@"%@%@id=6&is_show_message=y",URL_Server,Wap_AboutDuobao];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request

// 此方法用于占位提示
- (void)requestForCollectPrize
{
    [self collectPrizeAction:nil];
}

#pragma mark -  EditAddressViewControllerDelegate

- (void)editAddressSuccess
{
    [_myTableView.mj_header beginRefreshing];
}

#pragma mark -  WantToSDViewControllerDelegate

- (void)shaidanSuccess
{
    [_myTableView.mj_header beginRefreshing];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSDButtonAction:(UIButton *)btn
{
    
}

#pragma mark - 已选择兑换充值卡，等待商品派发

// 等待商品派发 cell height
- (CGFloat)configureWaitInterface:(NSInteger)index
{
    CGFloat height = 44;
    
    switch (index) {
        case 1:
        {
            height = 44;
        }
            break;
        case 2:
        {
            height = [self subviewOneLineHeight];
        }
            break;
        case 3:
        {
            height = 44;
        }
            break;
        case 4:
        {
            height = 44;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)cellForWait:(NSInteger)index
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellTimeLine" owner:nil options:nil];
    CollertPrizeCellTimeLine *cell = [nib objectAtIndex:0];
    cell.separatorInset = UIEdgeInsetsMake(0, screenWidth/2, 0, screenWidth/2);
    
    switch (index) {
        case 1:
        {
            cell.timeLineTop.hidden = YES;
            cell.timeLineTitle.text = @"恭喜您获得该商品";
            cell.trailingLabel.text = _orderInfo.lottery_time;
        }
            break;
        case 2:
        {
            cell.timeLineTitle.text = @"已选择使用方式";
            cell.trailingLabel.hidden = YES;
            
            NSString *str = @"已选择：使用卡密";
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self subviewOneLineHeight];
            [cell.contentView addSubview:subview];
        }
            break;
        case 3:
        {
            cell.timeLineTitle.text = @"等待商品派发";
            cell.trailingLabel.hidden = YES;
        }
            break;
        case 4:
        {
            cell.timeLineBottom.hidden = YES;
            cell.timeLineTitle.text = @"晒单";
            cell.trailingLabel.hidden = YES;
            
            if ([self indexOfCurrentProgress] == 4) {
                UIButton *button = [self customerReviewButton];
                button.centerY = cell.height/2+ 8;
                [cell addSubview:button];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 兑换充值卡

// 卡密已下发cell height
- (CGFloat)configureCollectPrizeInterface:(NSInteger)index
{
    CGFloat height = 44;
    
    switch (index) {
        case 1:
        {
            height = 44;
        }
            break;
        case 2:
        {
            height = [self collertPrizeCellHeight];
        }
            break;
        case 3:
        {
            height = 44;
        }
            break;
        case 4:
        {
            height = 44;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

// 兑换充值卡 cell configure
- (UITableViewCell *)cellForCollectPrize:(NSInteger)index
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellTimeLine" owner:nil options:nil];
    CollertPrizeCellTimeLine *cell = [nib objectAtIndex:0];
    cell.separatorInset = UIEdgeInsetsMake(0, screenWidth/2, 0, screenWidth/2);
    
    switch (index) {
        case 1:
        {
            cell.timeLineTop.hidden = YES;
            cell.timeLineTitle.text = @"恭喜您获得该商品";
            cell.trailingLabel.text = _orderInfo.lottery_time;
        }
            break;
        case 2:
        {
            
            cell.timeLineTitle.text = @"请选择使用方式";
            cell.trailingLabel.hidden = YES;
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeSelectView" owner:nil options:nil];
            CollertPrizeSelectView *subview = [nib lastObject];
            subview.left = SubviewLeftMargin;
            subview.top =  CellHeight + SubviewTopMargin;
            subview.width = cell.contentView.width - SubviewLeftMargin;
            
            [subview.confirmButton addTarget:self action:@selector(collectPrizeAction:) forControlEvents:UIControlEventTouchUpInside];
            [subview.legalAgreementButton addTarget:self action:@selector(legalAgreementAction) forControlEvents:UIControlEventTouchUpInside];
            subview.firstRowLabel.text = [NSString stringWithFormat:@"我要兑换%@个小米", _orderInfo.goodvalues];
            subview.secondRowLabel.text = [NSString stringWithFormat:@"我要充值卡的卡号和密码"];

            cell.height = [self collertPrizeCellHeight];
                [cell.contentView addSubview:subview];
            
            
        }
            break;
        case 3:
        {
            cell.trailingLabel.hidden = YES;
            cell.timeLineTitle.text = @"等待商品派发";
        }
            break;
        case 4:
        {
            cell.timeLineBottom.hidden = YES;
            cell.trailingLabel.hidden = YES;
            cell.timeLineTitle.text = @"晒单";
            
            if ([self indexOfCurrentProgress] == 4) {
                UIButton *button = [self customerReviewButton];
                button.centerY = cell.height/2+ 8;
                [cell addSubview:button];
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 已经兑换小米

// 已经兑换小米 cell height
- (CGFloat)configureCollectPrizeToCoinInterface:(NSInteger)index
{
    CGFloat height = 44;
    
    switch (index) {
        case 1:
        {
            height = 44;
        }
            break;
        case 2:
        {
            height = [self subviewOneLineHeight];
        }
            break;
        case 3:
        {
            height = [self heightForCollectPrizeCoin];
        }
            break;
        case 4:
        {
            height = 44;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

// 已经兑换小米 cell configure
- (UITableViewCell *)cellForCollectPrizeToCoin:(NSInteger)index
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellTimeLine" owner:nil options:nil];
    CollertPrizeCellTimeLine *cell = [nib objectAtIndex:0];
    cell.separatorInset = UIEdgeInsetsMake(0, screenWidth/2, 0, screenWidth/2);
    
    switch (index) {
        case 1:
        {
            cell.timeLineTop.hidden = YES;
            cell.timeLineTitle.text = @"恭喜您获得该商品";
            cell.trailingLabel.text = _orderInfo.lottery_time;
        }
            break;
        case 2:
        {
            cell.timeLineTitle.text = @"已选择使用方式";
            cell.trailingLabel.hidden = YES;
            
            NSString *str = @"已选择：兑换小米";
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self subviewOneLineHeight];
            [cell.contentView addSubview:subview];
        }
            break;
        case 3:
        {
            cell.timeLineTitle.text = @"兑换成功";
            cell.trailingLabel.hidden = YES;
            
            NSString *str = [NSString stringWithFormat:@"你已兑换%@个小米。", _orderInfo.goodvalues];
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self heightForCollectPrizeCoin];
            [cell.contentView addSubview:subview];
        }
            break;
        case 4:
        {
            cell.timeLineBottom.hidden = YES;
            cell.trailingLabel.hidden = YES;
            cell.timeLineTitle.text = @"晒单";
            
//            if ([self indexOfCurrentProgress] == 4) {
//                UIButton *button = [self customerReviewButton];
//                button.centerY = cell.height/2+ 8;
//                [cell addSubview:button];
//            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 卡密已派发

// 卡密已下发cell height
- (CGFloat)configReceivedCardInfoInterface:(NSInteger)index
{
    CGFloat height = 44;
    
    switch (index) {
        case 1:
        {
            height = 44;
        }
            break;
        case 2:
        {
            height = [self subviewOneLineHeight];
        }
            break;
        case 3:
        {
            height = [self showCardInfoCellHeight];
        }
            break;
        case 4:
        {
            height = 44;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

// 卡密已派发cell configure
- (UITableViewCell *)cellForReceivedCard:(NSInteger)index
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellTimeLine" owner:nil options:nil];
    CollertPrizeCellTimeLine *cell = [nib objectAtIndex:0];
    cell.separatorInset = UIEdgeInsetsMake(0, screenWidth/2, 0, screenWidth/2);
    
    switch (index) {
        case 1:
        {
            cell.timeLineTop.hidden = YES;
            cell.timeLineTitle.text = @"恭喜您获得该商品";
            cell.trailingLabel.text = _orderInfo.lottery_time;
        }
            break;
        case 2:
        {
            cell.timeLineTitle.text = @"已选择使用方式";
            cell.trailingLabel.hidden = YES;
            
            NSString *str = @"已选择：使用卡密";
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self subviewOneLineHeight];
            [cell.contentView addSubview:subview];
        }
            break;
        case 3:
        {
            
            if ([_orderInfo onlyOneRecharge] == NO) {
                cell.timeLineTitle.text = @"卡密已派发";
                cell.trailingLabel.hidden = YES;
                
                NSString *str = [NSString stringWithFormat:@"您获得%d张100元充值卡", [_orderInfo cardCount]];
                UIView *subview = [self subviewWithButton:str];
                
                cell.height = [self subviewOneLineHeight];
                [cell.contentView addSubview:subview];
            } else {
                
                cell.timeLineTitle.text = @"卡密已派发";
                cell.trailingLabel.hidden = YES;
                
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCardInfoView" owner:nil options:nil];
                CollertPrizeCardInfoView *subview = [nib objectAtIndex:0];
                
                subview.titleLabel.text = [NSString stringWithFormat:@"您获得一张%@元充值卡", _orderInfo.goodvalues];
                subview.cardNumberLabel.text = [_orderInfo firstCardNumber];
                subview.passwordString = [_orderInfo firstCardPassword];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"点击查看密码"];
                [attString addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){0,[attString length]}];
                subview.cardPasswordLabel.attributedText = attString;
                
                
                [subview.instructionsButton addTarget:self action:@selector(instructionAction) forControlEvents:UIControlEventTouchUpInside];
                [subview.numberCopyButton addTarget:self action:@selector(numberCopyAction) forControlEvents:UIControlEventTouchUpInside];
                [subview.passwordCopyButton addTarget:self action:@selector(passwordCopyAction) forControlEvents:UIControlEventTouchUpInside];
                [subview.rechargeButton addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
                
                subview.left = SubviewLeftMargin;
                subview.top =  CellHeight + SubviewTopMargin;
                subview.width = cell.contentView.width - SubviewLeftMargin;
                
                cell.height = [self showCardInfoCellHeight];
                [cell.contentView addSubview:subview];
            }
        }
            break;
        case 4:
        {
            cell.timeLineBottom.hidden = YES;
            cell.timeLineTitle.text = @"晒单";
            cell.trailingLabel.hidden = YES;
            
//            if ([self indexOfCurrentProgress] == 4) {
//                UIButton *button = [self customerReviewButton];
//                button.centerY = cell.height/2+ 8;
//                [cell addSubview:button];
//            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark -

- (void)addBottomToolBar
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BottomToolBar" owner:nil options:nil];
    BottomToolBar *view = [nib lastObject];
    view.bottom = self.view.height;
    view.width = self.view.width;
    [view.rightButton addTarget:self action:@selector(rightBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    view.titleLabel.text = @"手气不错，要乘胜追击哦！";
    
    [self.view addSubview:view];
}

- (UIButton *)customerReviewButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(100, 30);
    button.layer.cornerRadius = button.height/2;
    button.layer.masksToBounds = YES;
    //            button.backgroundColor = [UIColor defaultRedColor];
    UIImage *image = [UIImage imageFromContextWithColor:[UIColor defaultRedColor] size:button.size];
    [button setTitle:@"去晒单" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    //            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1] forState:UIControlStateSelected];
    //            [button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.right = [self timelineCellWidth];
    
    [button addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (float)subviewWidth
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    CGFloat defaultMarginOfCell = cell.layoutMargins.left + cell.contentView.layoutMargins.left;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = screenWidth - defaultMarginOfCell*2 - SubviewLeftMargin;
    
    return width;
}

- (CGFloat)timelineCellWidth
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    CGFloat defaultMarginOfCell = cell.layoutMargins.left + cell.contentView.layoutMargins.left;
    
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float width = screenWidth - defaultMarginOfCell;
    
    return width;
}

- (CGFloat)subviewOneLineHeight
{
    CGFloat height = CellHeight + SubviewBottomMargin + SubviewTopMargin + 40;
    return height;
}

- (CGFloat)heightForCollectPrizeCoin
{
    CGFloat height = CellHeight + SubviewBottomMargin + SubviewTopMargin + 40 + 11;
    return height;
}

- (CGFloat)showCardInfoCellHeight
{
    CGFloat height = CellHeight + SubviewBottomMargin + SubviewTopMargin + 118 + 11;
    if ([_orderInfo onlyOneRecharge] == NO) {
        height = CellHeight + SubviewBottomMargin + SubviewTopMargin + 40 + 11;
    }
    
    return height;
}

- (CGFloat)collertPrizeCellHeight
{
    CGFloat height = CellHeight + SubviewBottomMargin + SubviewTopMargin + 146;
    return height;
}

// 灰色背景，显示一行文字
- (UIView *)subviewWithString:(NSString *)str
{
    float width = [self subviewWidth];
    float height = 39;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SubviewLeftMargin, SubviewTopMargin + CellHeight, width, height)];
    view.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
    
    float leftMargin = SubviewLeftMargin;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin - 8, 0, width - leftMargin, view.height)];
    label.textColor = [UIColor colorFromHexString:@"474747"];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    
    [view addSubview:label];
    
    return view;
}

// 灰色背景，显示一行文字
- (UIView *)subviewWithButton:(NSString *)str
{
    float width = [self subviewWidth];
    float height = 39;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SubviewLeftMargin, SubviewTopMargin + CellHeight, width, height)];
    view.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
    
    float leftMargin = SubviewLeftMargin;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin - 8, 0, width - leftMargin, view.height)];
    label.textColor = [UIColor colorFromHexString:@"474747"];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.size = CGSizeMake(200, 30);
    button.contentMode = UIViewContentModeRight;
    [button setTitle:@"查看卡密信息" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button sizeToFit];
    button.centerY = view.height/2;
    button.right = width - 8;
    [button addTarget:self action:@selector(reviewRechargeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:label];
    [view addSubview:button];
    
    return view;
}

- (int)indexOfCurrentProgress
{
    int index = 2;
    
    NSString *stauts = [_orderInfo goodsStatus];
    
    if ([stauts isEqualToString:@"待发货"]) {
        index = 2;
    } else if ([stauts isEqualToString:@"等待商品派发"]) {
        index = 3;
    } else if ([stauts isEqualToString:@"已兑换小米"]) {
        index = 4;
    } else if ([stauts isEqualToString:@"卡密已派发"]) {
        index = 4;
    }
    
    return index;
}

- (void)showAlertView
{
    NSString *title = @"充值话费";
    NSString *message = @"移动充值卡\n拨打 10086 或者 13800138000 根据语音提示选择充值卡充值。\n\n联通充值卡\n拨打 10011 根据语音提示选择充值卡充值。\n\n电信充值卡\n拨打 11888输入18位密码充值。卡号只做备查使用，充值不需要输入卡号。";
    
    DLAVAlertView *alertView = [[DLAVAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    DLAVAlertViewTheme *theme = [DLAVAlertViewTheme defaultTheme];
    theme.messageAlignment = NSTextAlignmentLeft;
    [alertView applyTheme:theme];
    
    [alertView showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
    }];
}

@end
