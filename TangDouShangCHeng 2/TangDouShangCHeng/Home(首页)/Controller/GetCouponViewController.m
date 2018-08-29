//
//  GetCouponViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "GetCouponViewController.h"
#import "HomeGoodModel.h"
#import "GetCouponOneCell.h"
#import "GetCouponTwoCell.h"
#import "EditOrderViewController.h"

#import "PaySelectedController.h"
#import "RecoverAddressListInfo.h"
#import "AgreementCheckbox.h"



@interface GetCouponViewController()<paySelectDelegate>
{
    int payNum;
     UIActivityIndicatorView* activityIndicator;
    UIWebView *vWebView;

}
@property (strong,nonatomic)UILabel *moneyLabel;
@property (nonatomic, strong) PaySelectedController *paySelectedController;
@property (nonatomic, strong) AgreementCheckbox *agreementCheckbox;
@end

@implementation GetCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    payNum = 1;
    self.title = @"领券";
    self.tableView.backgroundColor =  [[UIColor alloc]initWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    [self setFootViewForPay];
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithNibName:@"PaySelectedController" bundle:nil];
    
    _paySelectedController = tableViewController;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    [self.view addSubview:activityIndicator];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(payNotifi:)
                                                name:kPaySuccess
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(paySucess:)
                                                name:kWXPaySuccess
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(paySucess:)
                                                name:kPayNotification
                                              object:nil];
}
#pragma mark 支付结果处理逻辑
- (void)paySucess:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)payNotifi:(NSNotification *)notification{
    
    [activityIndicator stopAnimating];
    NSDictionary * infoDic = [notification object];
    NSString *states = infoDic[@"resultStatue"];
    // 这样就得到了我们在发送通知时候传入的字典了
    NSString *message = nil;
    if ([states isEqualToString:@"9000"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([states isEqualToString:@"8000"]) {
        message =  @"正在处理中,请稍候查看！";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
    }
}


#pragma mark - 创建底部视图
-(void)setFootViewForPay{
    UIImageView *buyFooterView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, ScreenHeight-64-44, ScreenWidth, 44))];
    buyFooterView.userInteractionEnabled = YES;
//    if (@available(iOS 11.0, *)) {
//        buyFooterView.frame = CGRectMake(0,  ScreenHeight-64-44-40, ScreenWidth, 44);
//    }
    buyFooterView.image = [UIImage imageNamed:@"nav"];
    _moneyLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 0, ScreenWidth -130, 44))];
    _moneyLabel.text = [NSString stringWithFormat:@"应付：¥%@",[NSString stringWithFormat:@"%.2f",[_goodModel.coupons_price floatValue]*payNum]];
    _moneyLabel.textColor = [UIColor blackColor];
    [buyFooterView addSubview:_moneyLabel];
    
    UIButton *goPayBtn = [[UIButton alloc]initWithFrame:(CGRectMake(ScreenWidth -130, 0, 130, 44))];
    [goPayBtn setTitle:@"去付款" forState:0];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:0];
//    goPayBtn.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
    [goPayBtn setBackgroundImage:[UIImage imageNamed:@"nav"] forState:0];
//     MLog(@"_agreementCheckbox>>>>>%i",_agreementCheckbox.isSelected);
    
    [goPayBtn addTarget: self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [buyFooterView addSubview:goPayBtn];
    [self.view addSubview:buyFooterView];
}



#pragma mark -跳转到付款页面
-(void)goPay{
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    MLog(@"放开我 我要去付钱");

    
    if ([ShareManager shareInstance].isInReview == YES) {
         [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"a"];
        MLog(@"utl%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    NewPaySelectViewController *paySelectVC = [[NewPaySelectViewController alloc]init];
     NSString *str = [NSString stringWithFormat:@"应付: ¥%d.00",payNum*[_goodModel.coupons_price intValue]];
     paySelectVC.mustPayMoney = str;
    paySelectVC.payDelegate = self;
    [self.navigationController pushViewController:paySelectVC animated:true];
    
//   [self.navigationController hh_pushViewController:paySelectVC style:AnimationStyleCube];
}

-(void)zfbPay
{
    RecoverAddressListInfo *info = nil;
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.coupons_price integerValue]) {
        
        NSString *num = [NSString stringWithFormat:@"%d",payNum];
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:num coupons_ids:@[] type:@"a" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
    }else{
        [_paySelectedController getZFBOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            
            [activityIndicator stopAnimating];
            if (result) {
                
            } else {
                [Tool showPromptContent:description onView:self.view];
            }
        }];
    }
}

-(void)zxPay
{
    RecoverAddressListInfo *info = nil;
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.coupons_price integerValue]) {
        
        NSString *num = [NSString stringWithFormat:@"%d",payNum];
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:num coupons_ids:@[] type:@"a" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
    }else{
        [_paySelectedController getZXOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            
            [activityIndicator stopAnimating];
            if (result) {
                
            } else {
                [Tool showPromptContent:description onView:self.view];
            }
        }];
    }
}



-(void)abPay{
    RecoverAddressListInfo *info = nil;
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.coupons_price integerValue]) {
        
        NSString *num = [NSString stringWithFormat:@"%d",payNum];
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:num coupons_ids:@[] type:@"a" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
    }else{
        [_paySelectedController getABOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            
            [activityIndicator stopAnimating];
            if (result) {
                
            } else {
                [Tool showPromptContent:description onView:self.view];
            }
        }];
    }
}

-(void)mustPay{
    RecoverAddressListInfo *info = nil;
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.coupons_price integerValue]) {
        
        NSString *num = [NSString stringWithFormat:@"%d",payNum];
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:num coupons_ids:@[] type:@"a" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
    }else{
        [_paySelectedController getMustOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            
            [activityIndicator stopAnimating];
            if (result) {
                
            } else {
                [Tool showPromptContent:description onView:self.view];
            }
        }];
    }
}
-(void)wxPay{
    RecoverAddressListInfo *info = nil;
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.coupons_price integerValue]) {
        
        NSString *num = [NSString stringWithFormat:@"%d",payNum];
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:num coupons_ids:@[] type:@"a" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
    }else{
        [_paySelectedController getWXOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            
            [activityIndicator stopAnimating];
            if (result) {
                
            } else {
                [Tool showPromptContent:description onView:self.view];
            }
        }];
    }
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}
//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            GetCouponOneCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GetCouponOneCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GetCouponOneCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }
            cell.goodModel = _goodModel;
            return cell;
        }
            break;
        case 1:
        {
            {
                GetCouponTwoCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:@"GetCouponTwoCell"];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GetCouponTwoCell" owner:nil options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.numLabel.text = [NSString stringWithFormat:@"%d",payNum];
                cell.subBtn.tag = 100;
                [cell.subBtn addTarget:self action:@selector(payNumSelect:) forControlEvents:UIControlEventTouchUpInside];
                cell.addBtn.tag = 101;
                [cell.addBtn addTarget:self action:@selector(payNumSelect:) forControlEvents:UIControlEventTouchUpInside];
                int money = [_goodModel.coupons_price intValue];
                cell.beanNumLabel.text = [NSString stringWithFormat:@"赠%d小米",payNum*money*BeanExchangeRate];
                return cell;
            }
            break;
        default:
            return nil;
            break;
        }
            
            
    }

}
#pragma mark - 购买数量
-(void)payNumSelect:(UIButton *)btn{
    
    if (btn.tag == 100) {
        if (payNum == 0) {
            payNum = 0;
            _moneyLabel.text = @"应付: ¥0.00";
        }else{
            payNum--;
            NSString *str = [NSString stringWithFormat:@"应付: ¥%d.00",payNum*[_goodModel.coupons_price intValue]];
             _moneyLabel.text = str;
        }
    }else{
        payNum++;
        NSString *str = [NSString stringWithFormat:@"应付: ¥%d.00",payNum*[_goodModel.coupons_price intValue]];
        _moneyLabel.text = str;
    }
    //刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
           return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    if (section == 1) {
        return 30;
    }else{
    
        return 0.0001;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = nil;
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        separationLine.backgroundColor = [UIColor defaultTableViewSeparationColor];
        // 服务协议
        if (_agreementCheckbox == nil) {
            _agreementCheckbox = [[AgreementCheckbox alloc] initWithController:self];
        }
        AgreementCheckbox *checkboxView = _agreementCheckbox;
        checkboxView.centerX = view.width / 2;
        checkboxView.top = 0;
        [view addSubview:_agreementCheckbox];
        return view;
    }else{
        
        return nil;
    }

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
        UIView *headerView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, 30))];
        headerView.backgroundColor = [[UIColor alloc]initWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
        return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            return 130;
        }
            break;
        case 1:
        {
            return 80;
        }
            break;
 
        default:
            return 0;
            break;
    }
    
}


@end
