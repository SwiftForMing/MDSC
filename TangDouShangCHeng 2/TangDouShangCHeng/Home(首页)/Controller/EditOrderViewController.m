//
//  EditOrderViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "EditOrderViewController.h"
#import "EditAddressCell.h"
#import "SimGoodCell.h"
#import "HaveCouponCell.h"
#import "GoodPriceCell.h"
#import "AddAddressViewController.h"
#import "ReciverAddressViewController.h"


#import "ExpressModel.h"
#import "BuyCouponModel.h"
#import "BuyGoodModel.h"
#import "MyOrderListViewController.h"
#import "OrderAddressModel.h"
#import "PaySelectedController.h"
#import "AgreementCheckbox.h"
@interface EditOrderViewController ()<ReciverAddressViewControllerDelegate,paySelectDelegate>{
    int payNum;
    NSMutableArray *dataSoureArray;
    NSMutableArray *addressArray;//地址
    NSMutableArray *proviceArray;
    NSMutableArray *expressArray; //快递
    NSMutableArray *couponArray;//优惠券
    NSMutableArray *goodsArray;//优惠券
    NSString *price;
    UIActivityIndicatorView* activityIndicator;
    
}

@property (strong,nonatomic)UILabel *moneyLabel;
@property (nonatomic, strong) PaySelectedController *paySelectedController;
@property (nonatomic, strong) AgreementCheckbox *agreementCheckbox;
@end

@implementation EditOrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [activityIndicator stopAnimating];
    [self getOrderDetial];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    payNum = 1;
    dataSoureArray = [NSMutableArray array];
    proviceArray = [NSMutableArray array];
    addressArray = [NSMutableArray array];
    expressArray = [NSMutableArray array];
    couponArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    
    self.title = @"填写订单";
//    self.tableView.backgroundColor =  [[UIColor alloc]initWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
     self.tableView.backgroundColor =  [UIColor whiteColor];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
   
    [self.view addSubview:activityIndicator];
    [self setFootViewForPay];
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithNibName:@"PaySelectedController" bundle:nil];
    _paySelectedController = tableViewController;
    
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

#pragma mark 支付结果处理逻辑
- (void)payNotifi:(NSNotification *)notification{
    
    [activityIndicator stopAnimating];
    NSDictionary * infoDic = [notification object];
    NSString *states = infoDic[@"resultStatue"];
    // 这样就得到了我们在发送通知时候传入的字典了
    NSString *message = nil;
    if ([states isEqualToString:@"9000"]) {
            [Tool getUserInfo];
            MyOrderListViewController *vc = [[MyOrderListViewController alloc]initWithTableViewStyle:1];
//             
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([states isEqualToString:@"8000"]) {
        [Tool getUserInfo];
        message =  @"正在处理中,请稍候查看！";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
    }
}

-(void)getOrderDetial{
    __weak EditOrderViewController *weakSelf = self;
    [HttpHelper getDetialOrderWithGoodId:_goodModel.id type:@"b" buyNum:@"1" userId:[ShareManager shareInstance].userinfo.id success:^(NSDictionary *resultDic) {
         [activityIndicator stopAnimating];
        MLog(@"sharID%@,%@",[ShareManager shareInstance].userinfo.id,_goodModel.id);
        
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            [weakSelf handleloadResult:resultDic];
           
        }else
        {
            [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
        }
     }fail:^(NSString *decretion){
         [activityIndicator stopAnimating];
        [Tool showPromptContent:@"网络出错了" onView:self.view];
    }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    NSString *needMoney= [[resultDic objectForKey:@"data"] objectForKey:@"all_price"];
    price = needMoney;
    _moneyLabel.textColor = [UIColor whiteColor];
     _moneyLabel.text = [NSString stringWithFormat:@"应付：¥%.2f",[price floatValue]];
    NSDictionary *address= [[resultDic objectForKey:@"data"] objectForKey:@"defaultAddress"];
    if (address)
    {
        MLog(@"address%@",address);
        if (addressArray.count > 0) {
            [addressArray removeAllObjects];
        }
        
        if ([address objectForKey:@"detail_address"]) {
            
            RecoverAddressListInfo *info = [address objectByClass:[RecoverAddressListInfo class]];
                [addressArray addObject:info];
        }
       
    }
    
    
    NSArray *exArray = [[resultDic objectForKey:@"data"] objectForKey:@"express_List"];
    if (exArray && exArray.count > 0)
    {
        if (expressArray.count > 0) {
            [expressArray removeAllObjects];
        }
        for (NSDictionary *dic in exArray)
        {
            ExpressModel *info = [dic objectByClass:[ExpressModel class]];
            [expressArray addObject:info];
            
        }
    }
    
    NSArray *couArray = [[resultDic objectForKey:@"data"] objectForKey:@"coupons_own_List"];
    if (couArray && couArray.count > 0)
    {
        if (couponArray.count > 0) {
            [couponArray removeAllObjects];
        }
        for (NSDictionary *dic in couArray)
        {
            BuyCouponModel *info = [dic objectByClass:[BuyCouponModel class]];
            [couponArray addObject:info];
        }
    }
    
    NSArray *gdArray = [[resultDic objectForKey:@"data"] objectForKey:@"goods_buy_List"];
    if (gdArray && gdArray.count > 0)
    {
        if (goodsArray.count > 0) {
            [goodsArray removeAllObjects];
        }
        for (NSDictionary *dic in gdArray)
        {
            BuyGoodModel *info = [dic objectByClass:[BuyGoodModel class]];
            [goodsArray addObject:info];
            
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 创建底部视图
-(void)setFootViewForPay{
    UIImageView *buyFooterView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, ScreenHeight-64-60, ScreenWidth, 60))];
    buyFooterView.userInteractionEnabled = YES;
    buyFooterView.image = [UIImage imageNamed:@"nav"];
//    if (@available(iOS 11.0, *)) {
//        buyFooterView.frame = CGRectMake(0,  ScreenHeight-64-60-40, ScreenWidth, 60);
//    }
    _moneyLabel = [[UILabel alloc]initWithFrame:(CGRectMake(10, 5, ScreenWidth -130, 50))];
    _moneyLabel.text = [NSString stringWithFormat:@"应付：¥%.2f",[price floatValue]];
    [buyFooterView addSubview:_moneyLabel];
//    buyFooterView.backgroundColor = [UIColor whiteColor];
    _moneyLabel.textColor = [UIColor whiteColor];
    
    UIButton *goPayBtn = [[UIButton alloc]initWithFrame:(CGRectMake(ScreenWidth -130, 0, 130, 60))];
    [goPayBtn setTitle:@"去付款" forState:0];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:0];
//    goPayBtn.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
    [goPayBtn setBackgroundImage:[UIImage imageNamed:@"nav"] forState:0];
    [goPayBtn addTarget: self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [buyFooterView addSubview:goPayBtn];
    [self.view addSubview:buyFooterView];
    
}

#pragma mark -跳转到付款页面
-(void)goPay{
    
     [activityIndicator startAnimating];
    
    if (addressArray.count==0) {
        
        [Tool showPromptContent:@"请设置收货地址" onView:self.view];
        [activityIndicator stopAnimating];
        return;
    }
    
    NewPaySelectViewController *paySelectVC = [[NewPaySelectViewController alloc]init];
    NSString *str = [NSString stringWithFormat:@"应付：¥%.2f",[price floatValue]];
    paySelectVC.mustPayMoney = str;
    paySelectVC.payDelegate = self;
    [self.navigationController pushViewController:paySelectVC animated:true];

   
    
}

-(void)zfbPay{
    RecoverAddressListInfo *info = [addressArray objectAtIndex:0];
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"b"];
        MLog(@"utl%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.good_price integerValue]) {
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:@"1" coupons_ids:@[] type:@"b" user_id:[ShareManager shareInstance].userinfo.id consignee_name:info.user_name consignee_tel:info.user_tel consignee_address:[NSString stringWithFormat:@"%@%@",info.address,info.detail_address] remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                MyOrderListViewController *vc = [[MyOrderListViewController alloc]initWithTableViewStyle:1];
//                 
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
        
    }else{
        [activityIndicator stopAnimating];
        [_paySelectedController getZFBOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"b" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            MLog(@"_paySelectedController%@",dict);
            [activityIndicator stopAnimating];
            if (result) {
                [activityIndicator stopAnimating];
            } else {
                [activityIndicator stopAnimating];
                [Tool showPromptContent:description onView:self.view];
            }
        }];
        
    }
}


-(void)zxPay{
    RecoverAddressListInfo *info = [addressArray objectAtIndex:0];
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"b"];
        MLog(@"utl%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.good_price integerValue]) {
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:@"1" coupons_ids:@[] type:@"b" user_id:[ShareManager shareInstance].userinfo.id consignee_name:info.user_name consignee_tel:info.user_tel consignee_address:[NSString stringWithFormat:@"%@%@",info.address,info.detail_address] remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                MyOrderListViewController *vc = [[MyOrderListViewController alloc]initWithTableViewStyle:1];
//                 
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
        
    }else{
        [activityIndicator stopAnimating];
        [_paySelectedController getZXOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"b" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            [activityIndicator stopAnimating];
            if (result) {
                [activityIndicator stopAnimating];
            } else {
                [activityIndicator stopAnimating];
                [Tool showPromptContent:description onView:self.view];
            }
        }];
        
    }
}


-(void)abPay{
    RecoverAddressListInfo *info = [addressArray objectAtIndex:0];
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"b"];
        MLog(@"utl%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.good_price integerValue]) {
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:@"1" coupons_ids:@[] type:@"b" user_id:[ShareManager shareInstance].userinfo.id consignee_name:info.user_name consignee_tel:info.user_tel consignee_address:[NSString stringWithFormat:@"%@%@",info.address,info.detail_address] remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                MyOrderListViewController *vc = [[MyOrderListViewController alloc]initWithTableViewStyle:1];
//                 
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
        
    }else{
        [activityIndicator stopAnimating];
        [_paySelectedController getABOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"b" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            [activityIndicator stopAnimating];
            if (result) {
                [activityIndicator stopAnimating];
            } else {
                [activityIndicator stopAnimating];
                [Tool showPromptContent:description onView:self.view];
            }
        }];
        
    }
}


-(void)wxPay{
    RecoverAddressListInfo *info = [addressArray objectAtIndex:0];
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"b"];
        MLog(@"utl%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.good_price integerValue]) {
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:@"1" coupons_ids:@[] type:@"b" user_id:[ShareManager shareInstance].userinfo.id consignee_name:info.user_name consignee_tel:info.user_tel consignee_address:[NSString stringWithFormat:@"%@%@",info.address,info.detail_address] remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                MyOrderListViewController *vc = [[MyOrderListViewController alloc]initWithTableViewStyle:1];
//                 
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
        
    }else{
        [activityIndicator stopAnimating];
        [_paySelectedController getWXOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"b" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            [activityIndicator stopAnimating];
            if (result) {
                [activityIndicator stopAnimating];
            } else {
                [activityIndicator stopAnimating];
                [Tool showPromptContent:description onView:self.view];
            }
        }];
        
    }
}


-(void)mustPay{
    RecoverAddressListInfo *info = [addressArray objectAtIndex:0];
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, _goodModel.id,@"5",@"n",@"b"];
        MLog(@"utl%@",url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    if ([ShareManager shareInstance].userinfo.user_balance>[_goodModel.good_price integerValue]) {
        
        [HttpHelper buyGoodForMyMoneyWithGoodId:_goodModel.id buy_num:@"1" coupons_ids:@[] type:@"b" user_id:[ShareManager shareInstance].userinfo.id consignee_name:info.user_name consignee_tel:info.user_tel consignee_address:[NSString stringWithFormat:@"%@%@",info.address,info.detail_address] remark:@"" express_id:@"" success:^(NSDictionary *data) {
            NSString *status = [data objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                [activityIndicator stopAnimating];
                [Tool getUserInfo];
                MyOrderListViewController *vc = [[MyOrderListViewController alloc]initWithTableViewStyle:1];
                //
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [activityIndicator stopAnimating];
                [Tool showPromptContent:@"购买失败" onView:self.view];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:description onView:self.view];
        }];
        
    }else{
        [activityIndicator stopAnimating];
        [_paySelectedController getMustOrderWithModel:_goodModel addressModel:info num:[NSString stringWithFormat:@"%d",payNum] type:@"b" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
            [activityIndicator stopAnimating];
            if (result) {
                [activityIndicator stopAnimating];
            } else {
                [activityIndicator stopAnimating];
                [Tool showPromptContent:description onView:self.view];
            }
        }];
        
    }
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return goodsArray.count;
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (addressArray.count>0) {
                EditAddressCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell"];
                if (cell == nil)
                {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditAddressCell" owner:nil options:nil];
                    cell = [nib objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                RecoverAddressListInfo *info = [addressArray objectAtIndex:0];
                cell.addressModel = info;
                return cell;
            }else{
                UITableViewCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 20, ScreenWidth, 40))];
                
                label.text = @"添加地址";
                label.font = [UIFont systemFontOfSize:20];
                label.textColor = [[UIColor alloc]initWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor whiteColor];
                [cell addSubview:label];
                return cell;
            }
        }
            break;
        case 1:
        {
            SimGoodCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"SimGoodCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimGoodCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.buyModel = [goodsArray objectAtIndex:0];
            return cell;
        }
            break;
        case 2:
        {
            HaveCouponCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"HaveCouponCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HaveCouponCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (couponArray.count>0) {
                BuyCouponModel *model = [couponArray objectAtIndex:0];
                cell.buyCouponModel = model;
                _goodModel.coupons_id = model.id;
            }else{
            
            }
            cell.arrowImageView.hidden = YES;
            return cell;
        }
            break;
        case 3:{
            GoodPriceCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"GoodPriceCell"];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoodPriceCell" owner:nil options:nil];
                cell = [nib objectAtIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.goodModel = _goodModel;
            return cell;
        }
            break;
        default:
        {
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
    
            UITableViewCell *cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:@"ruler"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ruler"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.backgroundColor = [UIColor clearColor];
            [cell addSubview:view];
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
            return 145;
            break;
        case 2:
            return 50;
            break;
        case 3:
            return 30;
            break;
        case 4:
            return 30;
            break;
        default:
            return 140;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ReciverAddressViewController *vc = [[ReciverAddressViewController alloc]init];
        vc.isSelectAddress = YES;
        vc.delegate = self;
//         
    [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)selectAddressWithInfo:(RecoverAddressListInfo *)info{

    [addressArray insertObject:info atIndex:0];
    [self.tableView reloadData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}




@end
