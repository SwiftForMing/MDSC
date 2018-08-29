//
//  EntBuyViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "EntBuyViewController.h"
#import "CouponModel.h"
#import "EntBuyCouPonCell.h"
#import "EditOrderViewController.h"
#import "SPayClient.h"
#import "SafariViewController.h"
#import "EntHomeCell.h"

@interface EntBuyViewController ()<paySelectDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>{
    
    NSMutableArray *dataArray;
    NSMutableArray *goodsArray;
     NSMutableArray *tabArray;
    NSMutableArray *payNumArray;
    NSMutableArray *goodsID;
    NSString *couponID;
    int page;
    int price;
//    int selectTag;
    UIActivityIndicatorView* activityIndicator;
}

@property (nonatomic, strong) PaySelectedController *paySelectedController;
@property (strong,nonatomic)UILabel *priceLabel;
@property (strong,nonatomic)UILabel *liftVauleLabel;
@property (strong,nonatomic)UILabel *pliftLabel;
@property (nonatomic, assign) NSInteger selectTag;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowlayout;
@property(nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic, copy) NSString *lift;
@end

@implementation EntBuyViewController


-(UICollectionView *)collectionview{
    if (!_collectionview) {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
        _flowlayout.itemSize = CGSizeMake((ScreenWidth-100)/3, 40);
        _flowlayout.minimumLineSpacing = 10;
        _flowlayout.minimumInteritemSpacing = 10;
//        _flowlayout.headerReferenceSize=CGSizeMake(ScreenWidth, 170*UIAdapteRate); //设置collectionView头视图的大小
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 160) collectionViewLayout:_flowlayout];
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.scrollEnabled = NO;
        _collectionview.backgroundColor = [UIColor whiteColor];
    }
    return _collectionview;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count-1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MoneyValueCell";
    
    MoneyValueCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell= [[[NSBundle  mainBundle]  loadNibNamed:@"MoneyValueCell" owner:self options:nil]  firstObject];
    }
    if (_selectTag == indexPath.row) {
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        cell.PriceLabel.backgroundColor = [UIColor colorFromHexString:@"8c42f0"];
        cell.PriceLabel.textColor = [UIColor whiteColor];
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.layer.borderWidth = 1;
    }else{
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        cell.PriceLabel.backgroundColor = [UIColor whiteColor];
        cell.PriceLabel.textColor = [UIColor blackColor];
        cell.layer.borderColor = [UIColor colorFromHexString:@"8c42f0"].CGColor;
        cell.layer.borderWidth = 1;
    }
    CouponModel *model = [dataArray objectAtIndex:indexPath.row];
    cell.PriceLabel.text = [NSString stringWithFormat:@"¥%@",model.coupons_price];
    cell.addLiftLabel.text = [NSString stringWithFormat:@"+%0.2f幸运值",[model.coupons_price floatValue]*5/1000];
    return cell;
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _selectTag = indexPath.row;
    [tabArray removeAllObjects];
    [tabArray addObject:dataArray[_selectTag]];
    [self.tableView reloadData];
    [collectionView reloadData];
   
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 20, 20);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [self getLiftData];
    [activityIndicator stopAnimating];
}


-(void)getLiftData{
    [HttpHelper getCurrentLiftInfoWithUserId:[ShareManager shareInstance].userinfo.id success:^(NSDictionary *resultDic) {
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            NSDictionary *dic = [resultDic objectForKey:@"data"];
            NSString *lift = dic[@"CurrentLift"];
            self.liftVauleLabel.text = [NSString stringWithFormat:@"%0.2f",[lift doubleValue]];
            self.pliftLabel.text = [NSString stringWithFormat:@"%0.2f%@",[lift doubleValue]/10,@"%"];
            
        }else{
            [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
        }
    } fail:^(NSString *description) {
        [Tool showPromptContent:description];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    price = 0;
   
    couponID = @"";
    dataArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    payNumArray = [NSMutableArray array];
    tabArray = [NSMutableArray array];
    goodsID = [NSMutableArray array];
  

    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 20)];
    titLabel.text = @"选择充值金额";
    titLabel.textColor = [UIColor colorFromHexString:@"A4A4A4"];
    titLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [self.view addSubview:titLabel];
    
    
    
    [self.view addSubview:self.collectionview];
    UIView *headeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.collectionview.bottom, ScreenWidth, 62)];
  
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, 62)];
    bgImage.contentMode = UIViewContentModeScaleAspectFit;
    bgImage.image = [UIImage imageNamed:@"liftBG"];
    UIImageView *bgImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15,ScreenWidth-40, 30)];
    bgImage1.image = [UIImage imageNamed:@"liftJxBG"];
    bgImage1.contentMode = UIViewContentModeScaleToFill;
    UIImageView *bgImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5,30, 30)];
    bgImage2.image = [UIImage imageNamed:@"liftJp"];
    bgImage2.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *bgImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(bgImage2.right, bgImage1.top,80, 30)];
    bgImage3.image = [UIImage imageNamed:@"liftLabel"];
    bgImage3.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *liftLabel = [[UILabel alloc]initWithFrame:CGRectMake(bgImage3.right+5, bgImage3.top, 50, 30)];
    liftLabel.font = [UIFont boldSystemFontOfSize:18];
    liftLabel.textColor = [UIColor colorFromHexString:@"CD2A2A"];
    liftLabel.text = @"0";
    self.liftVauleLabel = liftLabel;
   
    UIImageView *bgImage4 = [[UIImageView alloc]initWithFrame:CGRectMake(liftLabel.right, bgImage1.top,ScreenWidth-80-liftLabel.right, 30)];
    bgImage4.image = [UIImage imageNamed:@"liftZj"];
    bgImage4.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *liftLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(bgImage4.right+5, bgImage3.top, 80, 30)];
    liftLabel1.font = [UIFont boldSystemFontOfSize:16];
    liftLabel1.textColor = [UIColor colorFromHexString:@"CD2A2A"];
    liftLabel1.text = @"0%";
    self.pliftLabel = liftLabel1;
    [headeView addSubview:bgImage];
    [headeView addSubview:bgImage1];
    [headeView addSubview:bgImage2];
    [headeView addSubview:bgImage3];
    [headeView addSubview:liftLabel];
    [headeView addSubview:bgImage4];
    [headeView addSubview:liftLabel1];
    [self.view addSubview:headeView];
    
    
    
    self.tableView.frame = CGRectMake(0, self.collectionview.bottom+20+82, ScreenWidth, 130);
    self.tableView.scrollEnabled = NO;
    [self.collectionview registerNib:[UINib nibWithNibName:@"MoneyValueCell" bundle:nil]  forCellWithReuseIdentifier:@"MoneyValueCell"];
    

    UILabel *selLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, self.tableView.bottom-20, ScreenWidth-40, 20)];
    selLabel.text = @"选择充值方式";
    selLabel.textColor = [UIColor colorFromHexString:@"A4A4A4"];
    selLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [self.view addSubview:selLabel];
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithNibName:@"PaySelectedController" bundle:nil];
    tableViewController.tableView.top = selLabel.bottom;
    [self.view addSubview:tableViewController.tableView];
    [self addChildViewController:tableViewController];
    _paySelectedController = tableViewController;
    
    
    UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, ScreenHeight-60-64, ScreenWidth-60, 45)];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"goPayBG"] forState:0];
    [payBtn setTitle:@"立即充值" forState:0];
    [payBtn whenTapped:^{
        [self paySelect];
    }];
    [payBtn setTitleColor:[UIColor whiteColor] forState:0];
    payBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];

    [self.view addSubview:payBtn];
    
    [self setTabelViewRefresh];

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


-(void)paySelect{
    MLog(@"paySelect%@",couponID);
    for (PaySelectedData *data in [ShareManager shareInstance].configureArray) {
        if (data.isSelected) {
            if ([data.pay_channer_desc isEqualToString:@"alipay"]) {
                [self zfbPay];
            }
            if ([data.pay_channer_desc isEqualToString:@"weixin_zhongxin"]) {
                 [self zxPay];
            }
            if ([data.pay_channer_desc isEqualToString:@"iapppay_h5"]) {
                 [self abPay];
            }
            if ([data.pay_channer_desc isEqualToString:@"wechat_pay"]) {
                 [self wxPay];
            }
            if ([data.pay_channer_desc isEqualToString:@"alipay_zhongxin"]) {
                 [self wxPay];
            }
            if ([data.pay_channer_desc isEqualToString:@"onechanel"]) {
                 [self mustPay];
            }
        }
    }
}



#pragma mark 支付结果处理逻辑
- (void)paySucess:(NSNotification *)notification{
    [self.navigationController popViewControllerAnimated:true];
    }


#pragma mark 获取历表数据
-(void)getListData{
    __weak EntBuyViewController *weakSelf = self;
    
    [HttpHelper getEntCouponListDataWithPageNum:[NSString stringWithFormat:@"%d",page] limitNum:@"20" success:^(NSDictionary *resultDic) {
        [weakSelf hideRefresh];
        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
            
            [weakSelf handleloadListResult:resultDic];
        }
        
    } fail:^(NSString *description) {
        [weakSelf hideRefresh];
        [Tool showPromptContent:@"网络出错了" onView:weakSelf.view];
    }];
}

- (void)handleloadListResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = [resultDic objectForKey:@"data"];
    MLog(@"handleloadListResult%@",dic);
    
    NSArray *goodArray = [dic objectForKey:@"rechargeGoodsList"];
    if (goodArray && goodArray.count > 0) {
        if (dataArray.count > 0&&page==1) {
            [dataArray removeAllObjects];
            [goodsArray removeAllObjects];
        }
        for (NSDictionary *dic in goodArray)
        {
            MLog(@"dic???%@",dic);
            CouponModel *info = [dic objectByClass:[CouponModel class]];
            [dataArray addObject:info];
            HomeGoodModel *model = [dic objectByClass:[HomeGoodModel class]];
            [goodsArray addObject:model];
        }
    }
    
    if (goodArray.count < 100) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    page++;
    
    //刷新
    _selectTag = 0;
    [tabArray removeAllObjects];
    [tabArray addObject:dataArray[_selectTag]];
    [self.tableView reloadData];
    [self.collectionview reloadData];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([states isEqualToString:@"8000"]) {
        [Tool getUserInfo];
        message =  @"正在处理中,请稍候查看！";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alter show];
    }
}


-(void)setFootViewForPay{
     UIView *buyFooterView = [[UIView alloc]initWithFrame:(CGRectMake(0, ScreenHeight-64-52, ScreenWidth, 52))];
    
//    if (@available(iOS 11.0, *)) {
//        buyFooterView.frame = CGRectMake(0,  ScreenHeight-64-52-40, ScreenWidth, 52);
//    }
   
    buyFooterView.backgroundColor = [UIColor whiteColor];
    UILabel *line = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, 1))];
    line.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [buyFooterView addSubview:line];
    
    _priceLabel = [[UILabel alloc]initWithFrame:(CGRectMake(0, 2, ScreenWidth/2, 50))];
    _priceLabel.text = [NSString stringWithFormat:@"共计:¥0.0"];
    _priceLabel.font = [UIFont systemFontOfSize:20];
    _priceLabel.backgroundColor = [UIColor colorFromHexString:@"ffa0a2"];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor whiteColor];
    [buyFooterView addSubview:_priceLabel];
    
    UIButton *goPayBtn = [[UIButton alloc]initWithFrame:(CGRectMake(ScreenWidth/2, 2, ScreenWidth/2, 50))];
    [goPayBtn setTitle:@"立即购买" forState:0];
    [goPayBtn setTitleColor:[UIColor whiteColor] forState:0];
    [Tool getColorWithView:goPayBtn leftColor:@"ff4e2a" rightColor:@"ff044e"];
    [goPayBtn addTarget: self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [buyFooterView addSubview:goPayBtn];
//    [self.view addSubview:buyFooterView];
}

-(void)goPay{
    
    [activityIndicator startAnimating];
    
    if (![Tool islogin]) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    if (goodsID.count == 0) {
        [Tool showPromptContent:@"请选择优惠券数量" onView:self.view];
        [activityIndicator stopAnimating];
        return;
    }
    
    NewPaySelectViewController *vc = [[NewPaySelectViewController alloc]init];

    vc.mustPayMoney = [NSString stringWithFormat:@"共计: ¥ %d",price];
    vc.payDelegate = self;
   [self.navigationController pushViewController:vc animated:true];

    
}


-(void)zfbPay{
    NSString *ids=couponID;
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, ids,@"5",@"n",@"a"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        MLog(@"buyUserId%@",[ShareManager shareInstance].userinfo.id);
        [HttpHelper getOrderWithOrderType:@"b" goods_id:ids buy_num:@"1" coupons_ids:@[] type:@"d" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *dictionary) {
            [activityIndicator stopAnimating];
            NSString *status = [dictionary objectForKey:@"status"];
            NSDictionary *order = [dictionary objectForKey:@"data"];
            NSString *orderNo = order[@"orderid"];
            MLog(@"orderNo%@",orderNo);
            NSString *price = [NSString stringWithFormat:@"%@",order[@"all_price"]];
            if (![status isEqualToString:@"0"]) {
                [Tool showPromptContent:@"网络错误" onView:self.view];
            }else{
                MLog(@"开始支付");
                [self payWith:orderNo price:price type:@"米花糖支付"];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:@"生成订单失败" onView:self.view];
        }];
        
    }
    
}

-(void)zxPay{
    NSString *ids=couponID;
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, ids,@"5",@"n",@"a"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        MLog(@"buyUserId%@",[ShareManager shareInstance].userinfo.id);
        [HttpHelper getOrderWithOrderType:@"b" goods_id:ids buy_num:@"1" coupons_ids:@[] type:@"d" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *dictionary) {
            [self->activityIndicator stopAnimating];
            NSString *status = [dictionary objectForKey:@"status"];
            NSDictionary *order = [dictionary objectForKey:@"data"];
            NSString *orderNo = order[@"orderid"];
            MLog(@"orderNo%@",orderNo);
            NSString *price = [NSString stringWithFormat:@"%@",order[@"all_price"]];
            if (![status isEqualToString:@"0"]) {
                [Tool showPromptContent:@"网络错误" onView:self.view];
            }else{
                MLog(@"开始支付");
               [self payZXWith:orderNo price:price type:@"米花糖支付"];
            }
        } failure:^(NSString *description) {
            [self->activityIndicator stopAnimating];
            [Tool showPromptContent:@"生成订单失败" onView:self.view];
        }];
        
    }
    
}


-(void)abPay{
    NSString *ids=couponID;
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, ids,@"5",@"n",@"a"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        MLog(@"buyUserId%@",[ShareManager shareInstance].userinfo.id);
        [HttpHelper getOrderWithOrderType:@"b" goods_id:ids buy_num:@"1" coupons_ids:@[] type:@"d" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *dictionary) {
            [activityIndicator stopAnimating];
            NSString *status = [dictionary objectForKey:@"status"];
            NSDictionary *order = [dictionary objectForKey:@"data"];
            NSString *orderNo = order[@"orderid"];
            MLog(@"orderNodictionary%@",dictionary);
            NSString *price = [NSString stringWithFormat:@"%@",order[@"all_price"]];
            if (![status isEqualToString:@"0"]) {
                [Tool showPromptContent:@"网络错误" onView:self.view];
            }else{
                MLog(@"开始支付");
                [self payABWith:orderNo price:price type:@"米花糖支付"];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:@"生成订单失败" onView:self.view];
        }];
        
    }
    
}


-(void)wxPay{
    NSString *ids=couponID;
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, ids,@"5",@"n",@"a"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        MLog(@"buyUserId%@",[ShareManager shareInstance].userinfo.id);
        [HttpHelper getOrderWithOrderType:@"b" goods_id:ids buy_num:@"1" coupons_ids:@[] type:@"d" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *dictionary) {
            [activityIndicator stopAnimating];
            NSString *status = [dictionary objectForKey:@"status"];
            NSDictionary *order = [dictionary objectForKey:@"data"];
            NSString *orderNo = order[@"orderid"];
            MLog(@"orderNo%@",orderNo);
            NSString *price = [NSString stringWithFormat:@"%@",order[@"all_price"]];
            if (![status isEqualToString:@"0"]) {
                [Tool showPromptContent:@"网络错误" onView:self.view];
            }else{
                MLog(@"开始支付");
                [self payWXWith:orderNo price:price type:@"米花糖支付"];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:@"生成订单失败" onView:self.view];
        }];
        
    }
    
}


-(void)mustPay{
    NSString *ids=couponID;
    if ([ShareManager shareInstance].isInReview == YES) {
        [activityIndicator stopAnimating];
        NSString *url = [NSString stringWithFormat:@"%@%@user_id=%@&goods_id=%@&goods_buy_nums=%@&is_shop_cart=%@&type=%@",URL_Server,Wap_PayMoneyView,[ShareManager shareInstance].userinfo.id, ids,@"5",@"n",@"a"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        
        MLog(@"buyUserId%@",[ShareManager shareInstance].userinfo.id);
        [HttpHelper getOrderWithOrderType:@"b" goods_id:ids buy_num:@"1" coupons_ids:@[] type:@"d" user_id:[ShareManager shareInstance].userinfo.id consignee_name:@"" consignee_tel:@"" consignee_address:@"" remark:@"" express_id:@"" success:^(NSDictionary *dictionary) {
            [activityIndicator stopAnimating];
            NSString *status = [dictionary objectForKey:@"status"];
            NSDictionary *order = [dictionary objectForKey:@"data"];
            NSString *orderNo = order[@"orderid"];
            MLog(@"orderNo%@",orderNo);
            NSString *price = [NSString stringWithFormat:@"%@",order[@"all_price"]];
            if (![status isEqualToString:@"0"]) {
                [Tool showPromptContent:@"网络错误" onView:self.view];
            }else{
                MLog(@"开始支付");
                [self payMustWith:orderNo price:price type:@"米花糖支付"];
            }
        } failure:^(NSString *description) {
            [activityIndicator stopAnimating];
            [Tool showPromptContent:@"生成订单失败" onView:self.view];
        }];
        
    }
    
}
-(void)payWith:(NSString*)orderNo price:(NSString *)allPriceStr type:(NSString *)order_type{
    
    [HttpHelper getZFBInfoWithOrderNo:orderNo
                            total_fee:allPriceStr
                     spbill_create_ip:@"127.0.0.1"
                                 body:order_type
                               detail:@"充值支付"
                              success:^(NSDictionary *resultDic){
                                  NSString *status = [resultDic objectForKey:@"status"];
                                  NSDictionary *data = [resultDic objectForKey:@"data"];
                                  NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                  BOOL result = [status isEqualToString:@"0"];
                                  if (result) {
                                      //调用支付宝支付接口
                                      [[AlipaySDK defaultService] payOrder:transaction_id fromScheme:@"TaoPiao" callback:^(NSDictionary *resultDic) {
                                          MLog(@"resultDic%@",resultDic);
                                      }];
                                  }

                              }fail:^(NSString * description){
                                  [Tool showPromptContent:description onView:self.view];
                              }];
    
}

-(void)payZXWith:(NSString*)orderNo price:(NSString *)allPriceStr type:(NSString *)order_type{
    
    [HttpHelper getSpayInfoWithOrderNo:orderNo
                            total_fee:allPriceStr
                     spbill_create_ip:@"127.0.0.1"
                                 body:order_type
                               detail:@"充值支付"
                              success:^(NSDictionary *resultDic){
                                  NSString *status = [resultDic objectForKey:@"status"];
                                  NSString *data = [resultDic objectForKey:@"data"];
//                                  NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                  MLog(@"data%@",data);
                                  BOOL result = [status isEqualToString:@"0"];
                                  if (result) {
                                      [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:data]];
                                  }
                                  
                              }fail:^(NSString * description){
                                  [Tool showPromptContent:description onView:self.view];
                              }];
    
}


-(void)payABWith:(NSString*)orderNo price:(NSString *)allPriceStr type:(NSString *)order_type{
    
    [HttpHelper getABpayInfoWithOrderNo:orderNo
                             total_fee:allPriceStr
                      spbill_create_ip:@"127.0.0.1"
                                  body:order_type
                                detail:@"充值支付"
                               success:^(NSDictionary *resultDic){
                                   NSString *status = [resultDic objectForKey:@"status"];
                                   NSString *data = [resultDic objectForKey:@"data"];
                                   //                                  NSString *transaction_id = [data objectForKey:@"orderInfo"];
                                   MLog(@"data%@",data);
                                   BOOL result = [status isEqualToString:@"0"];
                                   if (result) {
                                       [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:data]];
                                   }
                                   
                               }fail:^(NSString * description){
                                   [Tool showPromptContent:description onView:self.view];
                               }];
    
}

-(void)payWXWith:(NSString*)orderNo price:(NSString *)allPriceStr type:(NSString *)order_type{
    
    [HttpHelper getWXInfoWithOrderNo:orderNo
                              total_fee:allPriceStr
                       spbill_create_ip:@"127.0.0.1"
                                   body:order_type
                                 detail:@"充值支付"
                                success:^(NSDictionary *resultDic){
                                    NSString *status = [resultDic objectForKey:@"status"];
                                    NSString *data = [resultDic objectForKey:@"data"];
                                   
                                    MLog(@"getWXInfoWithOrderNodata%@",data);
                                    BOOL result = [status isEqualToString:@"0"];
                                    if (result) {
//                                        [Tool jumpToWeiXinPay:resultDic];
                                        [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:data]];
                                    }
                                    
                                }fail:^(NSString * description){
                                    [Tool showPromptContent:description onView:self.view];
                                }];
    
}


-(void)payMustWith:(NSString*)orderNo price:(NSString *)allPriceStr type:(NSString *)order_type{
    
    [HttpHelper getMustpayInfoWithOrderNo:orderNo
                           total_fee:allPriceStr
                    spbill_create_ip:@"127.0.0.1"
                                body:order_type
                              detail:@"充值支付"
                             success:^(NSDictionary *resultDic){
                                 NSString *status = [resultDic objectForKey:@"status"];
                                 NSString *data = [resultDic objectForKey:@"data"];
                                 
                                 MLog(@"getWXInfoWithOrderNodata%@",data);
                                 BOOL result = [status isEqualToString:@"0"];
                                 if (result) {
                                     //                                        [Tool jumpToWeiXinPay:resultDic];
                                     [[UIApplication sharedApplication]openURL:[[NSURL alloc]initWithString:data]];
                                 }
                                 
                             }fail:^(NSString * description){
                                 [Tool showPromptContent:description onView:self.view];
                             }];
    
}


- (void)spayOrderNo:(NSString *)orderNo priceStr:(NSString *)priceStr type:(PayType)payType
{
    NSNumber *amount = [NSNumber numberWithInt:[priceStr intValue]];
    NSString *payTypeStr = [self stringWithPayType:payType];
    
    [[SPayClient sharedInstance] pay:self
                              amount:amount
                   spayTokenIDString:orderNo
                   payServicesString:payTypeStr
                              finish:^(SPayClientPayStateModel *payStateModel,
                                       SPayClientPaySuccessDetailModel *paySuccessDetailModel) {
                                  
                                  if (payStateModel.payState == SPayClientConstEnumPaySuccess) {
                                      
//                                      if (_completionBlock) {
//                                          _completionBlock(YES, @"支付成功", nil);
//                                      }
                                      
                                      NSLog(@"支付成功");
                                      NSLog(@"支付订单详情-->>\n%@",[paySuccessDetailModel description]);
                                  }else{
                                      
//                                      if (_completionBlock) {
//                                          _completionBlock(NO, @"支付失败", nil);
//                                      }
                                      
                                      NSLog(@"支付失败，错误号:%d = %@",payStateModel.payState, payStateModel.messageString);
                                  }
                              }];
}


- (NSString *)stringWithPayType:(PayType)payType
{
    NSString *str = @"pay.weixin.app";
    
    if (payType == PayTypeWeChat) {
        str = @"pay.weixin.app";
    } else if (payType == PayTypeAlipay) {
        str = @"pay.alipay.native.towap";
    } else if (payType == PayTypeQQ) {
        str = @"pay.qq.app";
    }
    
    return str;
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tabArray.count;
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntBuyCouPonCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"EntBuyCouPonCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EntBuyCouPonCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    CouponModel *model = [tabArray objectAtIndex:indexPath.row];
    cell.couponModel = model;
    couponID = model.id;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CouponModel *model = [dataArray objectAtIndex:indexPath.row];
//    NewPaySelectViewController *vc = [[NewPaySelectViewController alloc]init];
//    couponID = model.id;
//    vc.mustPayMoney = [NSString stringWithFormat:@"共计: ¥ %@",model.coupons_price];
//    vc.payDelegate = self;
//    [self.navigationController pushViewController:vc animated:true];
}


//
//- (void)sendValue:(int)value Model:(CouponModel *)model{
//
//    if (value<0) {
//        MLog(@"hahah%@",model.good_name);
//        if ([goodsID containsObject:model.id]) {
//            [goodsID removeObject:model.id];
//        }
//    }
//    if (value>0) {
//        [goodsID addObject:model.id];
//    }
//
//    price += value;
//    MLog(@"钱钱钱%d",value);
//    _priceLabel.text = [NSString stringWithFormat:@"共计:¥ %d",price];
//
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
}

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
//        price = 0;
//        _priceLabel.text = [NSString stringWithFormat:@"¥ %d",0];
        [weakSelf getListData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getListData];
        
    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([self.tableView.mj_footer isRefreshing])
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if([self.tableView.mj_header isRefreshing])
    {
        [self.tableView.mj_header endRefreshing];
    }
}

@end
