//
//  OrderDetialViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "OrderDetialViewController.h"
#import "ReciverAddressViewController.h"
#import "ProvinceInfo.h"
#import "EditAddressCell.h"
#import "SimGoodCell.h"
#import "OrderDetialNomCell.h"
#import "OrderDetialHeaderCell.h"
@interface OrderDetialViewController (){

    NSMutableArray *dataSoureArray;
}

@end

@implementation OrderDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}



#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3) {
        return 4;
    }else{
    
        return  1;
    }
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 1:
        {
                EditAddressCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell"];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditAddressCell" owner:nil options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            cell.orderModel = _orderModel;
                return cell;
        }
            break;
        case 2:
        {
            SimGoodCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimGoodCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimGoodCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.orderModel = _orderModel;
            return cell;
        }
            break;
        case 3:
        { OrderDetialNomCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetialNomCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderDetialNomCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 0) {
                cell.leftLabel.text = @"商品金额";
                cell.rightLabel.text = [NSString stringWithFormat:@"¥%@",_orderModel.good_price];
                cell.lineLabel.hidden = YES;
            }
            if (indexPath.row == 1) {
                cell.leftLabel.text = @"优惠券";
                cell.rightLabel.text = [NSString stringWithFormat:@"-¥%@",_orderModel.coupons_price];
                cell.lineLabel.hidden = YES;
            }
            if (indexPath.row == 2) {
                cell.leftLabel.text = @"运费";
                cell.rightLabel.text = [NSString stringWithFormat:@"¥%@",_orderModel.express_price];
                cell.lineLabel.hidden = YES;
            }
            if (indexPath.row == 3) {
                cell.leftLabel.text = @"实付款";
                cell.rightLabel.text = [NSString stringWithFormat:@"¥%@",_orderModel.pay_money];
                cell.rightLabel.textColor = [UIColor redColor];
                cell.lineLabel.hidden = NO;
            }
            return cell;
        }
            break;
            default:
        {
            OrderDetialHeaderCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetialHeaderCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderDetialHeaderCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.statesLabel.text = _orderModel.status;
            
            if ([_orderModel.status isEqualToString:@"待发货"]) {
                cell.ExpNumLabel.hidden = YES;
            }else{
                 cell.ExpNumLabel.text = [NSString stringWithFormat:@"快递单号:%@",_orderModel.courier_id];
            }
           
            return cell;
        }
            break;
            
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 80;
            break;
        case 1:
            return 120;
            break;
        case 2:
            return 100;
            break;
        case 3:
            return 40;
            break;
        default:
            return 44;
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 100;
    }else{
        return 0.001;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 3) {
        UIView *footerView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, 100))];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *payBtn = [[UIButton alloc]initWithFrame:(CGRectMake(30, 30, ScreenWidth-60, 40))];
        payBtn.backgroundColor = [UIColor greenColor];
        [payBtn setTitle:@"申请售后" forState:0];
        [payBtn setTitleColor:[UIColor whiteColor] forState:0];
        payBtn.layer.masksToBounds = YES;
        payBtn.layer.cornerRadius = 5;
        [payBtn addTarget:self action:@selector(applyForAfterSale) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:payBtn];
        return footerView;

    }else{
        return nil;
    }

}

-(void)applyForAfterSale{
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    userID = userID ? userID : @"";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *versionString = [NSString stringWithFormat:@"iOS %@", version];
    NSString *alias = [ShareManager shareInstance].userinfo.nick_name;
    NSString *telephone = userInfo.user_tel ?:@"";
    //                NSString *mqID = [userID stringByAppendingFormat:@"_%@", alias];
    MQChatViewConfig *chatViewConfig = [MQChatViewConfig sharedConfig];
    
    MQChatViewController *chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    [chatViewConfig setEnableOutgoingAvatar:false];
    [chatViewConfig setEnableRoundAvatar:YES];
    chatViewConfig.navTitleColor = [UIColor whiteColor];
    chatViewConfig.navBarTintColor = [UIColor whiteColor];
    [chatViewConfig setStatusBarStyle:UIStatusBarStyleLightContent];
//    chatViewController.title = @"客服";
//    [chatViewConfig setNavTitleText:@"客服"];
    [chatViewConfig setCustomizedId:userID];
    [chatViewConfig setEnableEvaluationButton:NO];
//    [chatViewConfig setAgentName:@"客服"];
    [chatViewConfig setClientInfo:@{@"name":alias, @"version": versionString, @"identify": userID, @"telephone": telephone}];
    [chatViewConfig setUpdateClientInfoUseOverride:YES];
    [chatViewConfig setRecordMode:MQRecordModeDuckOther];
    [chatViewConfig setPlayMode:MQPlayModeMixWithOther];
    [self.navigationController pushViewController:chatViewController animated:YES];
//    
//    [self.navigationController pushViewController:chatViewController animated:YES transition:magicMove];

    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    chatViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)clickLeftControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
