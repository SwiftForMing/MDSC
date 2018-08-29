//
//  ZJRecordViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "CollectGoodsPrizeViewController.h"
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
#import "ReciverAddressViewController.h"

#import "DLAVAlertView.h"
#import "DLAVAlertViewTheme.h"
#import "DLAVAlertViewTextFieldTheme.h"
#import "DLAVAlertViewButtonTheme.h"

#import "TransferViewController.h"
#define SubviewLeftMargin 16
#define SubviewTopMargin 8
#define SubviewBottomMargin -11
#define CellHeight 44
#define GrayBackgroundColor [UIColor colorWithWhite:0.9686 alpha:1.0]



@interface CollectGoodsPrizeViewController ()<WantToSDViewControllerDelegate, ReciverAddressViewControllerDelegate>
{
    int pageNum;
    NSMutableArray *dataSourceArray;
}

@end

@implementation CollectGoodsPrizeViewController

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
    if ([_orderInfo.goodsStatus isEqualToString:@"待发货"]) {
      self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemControl];
    }
    
}

-(void)setGiftToOther:(UIButton*)btn{
    
    TransferViewController *vc = [[TransferViewController alloc]init];
    vc.order_type = @"donor";
    vc.goodInfo = _orderInfo;
//     
    [self.navigationController pushViewController:vc animated:YES];
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
            
            if ([stauts isEqualToString:@"请确认收货地址"]) {
                height = [self heightForChooseAddress:indexPath.row];
            } else if ([stauts isEqualToString:@"等待商品派发"]) {
                height = [self heightForWaitCustomerService:indexPath.row];
            } else if ([stauts isEqualToString:@"正在出库，请耐心等待物流订单"]) {
                height = [self heightForWaitGoodsOrder:indexPath.row];
            } else if ([stauts isEqualToString:@"已发货"]) {
                height = [self heightForReview:indexPath.row];
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

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZJRecordListInfo *orderInfo = _orderInfo;
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CollertPrizeCellHeader" owner:nil options:nil];
        CollertPrizeCellHeader *object = [nib objectAtIndex:0];
        [object.goodsImageView sd_setImageWithURL:[NSURL URLWithString:orderInfo.good_header] placeholderImage:PublicImage(@"defaultImage")];
        object.goodsTitleLabel.text = [NSString stringWithFormat:@"[第%@期]%@", orderInfo.win_num, orderInfo.good_name];
        object.buyRecords.text = [NSString stringWithFormat:@"转出ID：%@", orderInfo.win_user_id];
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
            
            if ([stauts isEqualToString:@"请确认收货地址"]) {
                cell = [self cellForChooseAddress:indexPath.row];
            } else if ([stauts isEqualToString:@"等待商品派发"]) {
                cell = [self cellForWaitCustomerService:indexPath.row];
            } else if ([stauts isEqualToString:@"正在出库，请耐心等待物流订单"]) {
                cell = [self cellForWaitGoodsOrder:indexPath.row];
            } else if ([stauts isEqualToString:@"已发货"]) {
                cell = [self cellForReview:indexPath.row];
            } else {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                MLog(@"%@ %@ cell out", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
            }
            
            // 设置timeline 状态
            if ([self indexOfCurrentProgress] > indexPath.row) {
                [(CollertPrizeCellTimeLine *)cell setTimeLineState:TimeLineStateNormal];
            } else if ([self indexOfCurrentProgress] == indexPath.row) {
                [(CollertPrizeCellTimeLine *)cell setTimeLineState:TimeLineStateHighlighted];
            } else {
                [(CollertPrizeCellTimeLine *)cell setTimeLineState:TimeLineStateEmpty];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        ReciverAddressViewController *vc = [[ReciverAddressViewController alloc] initWithNibName:@"ReciverAddressViewController" bundle:nil];
        vc.isSelectAddress = YES;
        vc.delegate = self;
//         
    [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Action

// 去晒单
- (void)rightBottomButtonAction
{
    WantToSDViewController *vc = [[WantToSDViewController alloc]initWithNibName:@"WantToSDViewController" bundle:nil];
    vc.detailInfo = _orderInfo;
    vc.delegate = self;
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

#pragma mark -  EditAddressViewControllerDelegate

- (void)editAddressSuccess
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -  WantToSDViewControllerDelegate

- (void)shaidanSuccess
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSDButtonAction:(UIButton *)btn
{
    
}

#pragma mark - 正在出库，请耐心等待

// 等待商品派发 cell height
- (CGFloat)heightForWaitGoodsOrder:(NSInteger)index
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
            NSString *str = _orderInfo.consignee_address;
            UIView *subview = [self subviewWithString:str];
            
            height = [self heightForCellWithSubview:subview.height];
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

- (UITableViewCell *)cellForWaitGoodsOrder:(NSInteger)index
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
            cell.timeLineTitle.text = @"收货地址";
            cell.trailingLabel.hidden = YES;
            
            NSString *str = _orderInfo.consignee_address;
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self heightForCellWithSubview:subview.height];
            [cell.contentView addSubview:subview];
        }
            break;
        case 3:
        {
            cell.timeLineTitle.text = @"正在出库，请耐心等待物流订单出现";
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

#pragma mark - 请选择收货地址
// 等待商品派发 cell height
- (CGFloat)heightForChooseAddress:(NSInteger)index
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
            height = 44;
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

- (UITableViewCell *)cellForChooseAddress:(NSInteger)index
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
            cell.trailingLabel.hidden = NO;
            cell.hasDisclosureIndicator = YES;
            cell.timeLineTitle.text = @"请确认收货地址";
            cell.trailingLabel.text = @"选择地址";
          
           
            
            cell.trailingLabel.textColor = [UIColor defaultRedColor];
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

#pragma mark - 请等待客服人员处理发货

// 等待商品派发 cell height
- (CGFloat)heightForWaitCustomerService:(NSInteger)index
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
//            height = 44;
            NSString *str = _orderInfo.consignee_address;
            UIView *subview = [self subviewWithString:str];
            
            height = [self heightForCellWithSubview:subview.height];
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

// 请等待客服处理发货 cell configure
- (UITableViewCell *)cellForWaitCustomerService:(NSInteger)index
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
            cell.timeLineTitle.text = @"请确认收货地址";
            cell.trailingLabel.text = @"修改地址";
            cell.trailingLabel.hidden = NO;
            cell.hasDisclosureIndicator = YES;
            
            NSString *str = _orderInfo.consignee_address;
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self heightForCellWithSubview:subview.height];
            [cell.contentView addSubview:subview];
            
            cell.trailingLabel.textColor = [UIColor defaultTintBlueColor];
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

#pragma mark - 晒单
// 晒单
- (CGFloat)heightForReview:(NSInteger)index
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
            NSString *str = _orderInfo.consignee_address;
            UIView *subview = [self subviewWithString:str];
            
            height = [self heightForCellWithSubview:subview.height];
        }
            break;
        case 3:
        {
            NSString *str = @"四川省成都市高新西区天\n目路保利新天地15栋2单元210";
            UIView *subview = [self subviewWithString:str];
            
            height = [self heightForCellWithSubview:subview.height];
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
- (UITableViewCell *)cellForReview:(NSInteger)index
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
            cell.timeLineTitle.text = @"收货地址";
            cell.trailingLabel.hidden = YES;
            
            NSString *str = _orderInfo.consignee_address;
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self heightForCellWithSubview:subview.height];
            [cell.contentView addSubview:subview];
        }
            break;
        case 3:
        {
            cell.timeLineTitle.text = @"已发货";
            cell.trailingLabel.hidden = YES;
            
            NSString *courier_id = _orderInfo.courier_id; // 物流订单号
            NSString *courier_name = _orderInfo.courier_name;   // 物流公司
            NSString *str = [NSString stringWithFormat:@"物流单号: %@\n快递名称: %@", courier_id?:@"", courier_name?:@""];
            UIView *subview = [self subviewWithString:str];
            
            cell.height = [self heightForCellWithSubview:subview.height];
            [cell.contentView addSubview:subview];
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

#pragma mark - ReciverAddressViewControllerDelegate

- (void)selectAddressWithInfo:(RecoverAddressListInfo *)info
{
    NSString *consignee_name = info.user_name;
    NSString *consignee_tel = info.user_tel;
    NSString *consignee_address = [info address];
    
    ZJRecordListInfo *data = _orderInfo;

    __weak typeof(self) weakSelf = self;
//    HttpHelper *helper = [HttpHelper helper];
    [HttpHelper changeOrderAddressWithOrderId:data.order_id
                           consignee_name:consignee_name
                            consignee_tel:consignee_tel
                        consignee_address:consignee_address
                                order_type:@"donor"
                                  success:^(NSDictionary *resultDic) {
                                      NSLog(@"resultDic%@",resultDic);
                                      NSString *status = [resultDic objectForKey:@"status"];

                                      if ([status isEqualToString:@"0"]) {
                                          
                                          data.consignee_address = consignee_address;
                                          data.consignee_name = consignee_name;
                                          data.consignee_tel = consignee_tel;
                                          data.confirm_adress = @"y";
                                          [weakSelf.tableView reloadData];
                                      }

                                  } fail:^(NSString *description) {
                                      
                                  }];

}

#pragma mark -

- (void)addBottomToolBar
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BottomToolBar" owner:nil options:nil];
    BottomToolBar *view = [nib lastObject];
    view.bottom = self.view.height;
    view.width = self.view.width;
    
    [view configureReviewButton];
    [view.rightButton addTarget:self action:@selector(rightBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    view.titleLabel.text = @"晒单就送小米，欢乐赚不停！";
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_thrice_coin_two"]];
    imageView.centerY = view.height/2;
    imageView.left = view.titleLabel.left;
    [view addSubview:imageView];
    
    view.titleLabelLeadingConstraint.constant += imageView.right - 10;
    
    [self.view addSubview:view];
    
    
    NSString *stauts = [_orderInfo goodsStatus];
    if ([stauts isEqualToString:@"已发货"] == NO) {
        view.rightButton.hidden = YES;
    }
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

- (CGFloat)heightForCellWithSubview:(CGFloat)subviewHeight
{
    CGFloat height = CellHeight + SubviewBottomMargin + SubviewTopMargin + subviewHeight;
    return height;
}

// 灰色背景，显示多行文字
- (UIView *)subviewWithString:(NSString *)str
{
    float width = [self subviewWidth];
    float height = 39;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SubviewLeftMargin, SubviewTopMargin + CellHeight - 5, width, height)];
    view.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
    
    float leftMargin = SubviewLeftMargin;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin - 8, 0, width - leftMargin, view.height)];
    label.textColor = [UIColor colorFromHexString:@"474747"];
    label.text = str;
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 9;
    [label sizeToFit];
    label.height += 20;   // label增加上下留白
    
    view.height = label.height;
    
    [view addSubview:label];
    
    return view;
}

- (int)indexOfCurrentProgress
{
    int index = 2;
    
    NSString *stauts = [_orderInfo goodsStatus];
    
    if ([stauts isEqualToString:@"请确认收货地址"]) {
        index = 2;
    } else if ([stauts isEqualToString:@"等待商品派发"]) {
        index = 3;
    } else if ([stauts isEqualToString:@"正在出库，请耐心等待物流订单"]) {
        index = 4;
    } else if ([stauts isEqualToString:@"已发货"]) {
        index = 4;
    }
    
    return index;
}

@end
