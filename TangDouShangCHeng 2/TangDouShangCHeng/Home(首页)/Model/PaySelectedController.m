
//
//  PaySelectedController.m
//  DuoBao
//
//  Created by clove on 3/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySelectedController.h"
#import "PaySelectedCell.h"
#import "SPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACSignal+Operations.h>
#import "YYKitMacro.h"
#import "HomeGoodModel.h"
#import "RecoverAddressListInfo.h"
#import "ReciverAddressViewController.h"
@interface PaySelectedController ()

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic) BOOL purchaseFlag; // 包含小米购买选项
@property (nonatomic, strong) SPayManager *spayManager;
@property (nonatomic, strong) RACSignal *racSignal;

@end

@implementation PaySelectedController

- (void)dealloc
{
   MLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithPurchaseGoods
{
    self = [self initWithNibName:@"PaySelectedController" bundle:nil];
    if (self) {
        _purchaseFlag = YES;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configurePaySelectedData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Tool httpAddressList];
    self.tableView.separatorColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    
    UINib *nib = [UINib nibWithNibName:@"PaySelectedCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PaySelectedCell"];
    self.view.backgroundColor = [UIColor clearColor];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 13)];
//    imageView.backgroundColor = [UIColor whiteColor];
//    self.tableView.tableFooterView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurePaySelectedData
{
    NSArray *configureArray = [ShareManager shareInstance].configureArray;
    
   
    _array = [NSMutableArray array];
    if (configureArray.count > 0) {
        _array = [NSMutableArray arrayWithArray:configureArray];
    }

    // App store审核期间隐藏支付
//    if ([ShareManager shareInstance].isInReview == YES) {
//        [_array removeAllObjects];
//    }
    
    if (_purchaseFlag == YES) {
        
        double allUserMoney = [ShareManager shareInstance].userinfo.user_money;
        
        PaySelectedData *data = [[PaySelectedData alloc] init];
        data.pay_channel_name = [NSString stringWithFormat:@"支付（账户余额: %.0f）", allUserMoney];
        data.isSelected = YES;
        [_array insertObject:data atIndex:0];
    }
    
    // 清除所有已选项，默认选择第一个支付方式
    [self cleanSelected];
    PaySelectedData *firstObject = [_array firstObject];
    firstObject.isSelected = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = _array.count * 44;
    self.tableView.width = ScreenWidth;
    self.tableView.height = height;
    
    // App store审核期间隐藏支付
//    if ([ShareManager shareInstance].isInReview == YES) {
//        self.tableView.height = 0;
//        height = 0;
//    }
}

- (CGFloat)height
{
    CGFloat height = _array.count * 44;
    
//    // App store审核期间隐藏支付
//    if ([ShareManager shareInstance].isInReview == YES) {
//        self.tableView.height = 0;
//        height = 0;
//    }
    
    return height;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PaySelectedCell *cell = (PaySelectedCell *)[tableView dequeueReusableCellWithIdentifier:@"PaySelectedCell" forIndexPath:indexPath];
    
    PaySelectedData *data = [_array objectAtIndex:indexPath.row];
    
    [cell relaodWithData:data];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self cleanSelected];
    
    PaySelectedData *data = [_array objectAtIndex:indexPath.row];
    data.isSelected = YES;
    MLog(@"PaySelectedData%@",data.pay_channel_name);
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


#pragma mark - Pay
- (void)getOrderWithModel:(HomeGoodModel *)model
                      num:(NSString *)num
                     type:(NSString *)type
                      completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self buyGood:model orderType:type num:num completion:completion];
}
#pragma zx
- (void)getZXOrderWithModel:(HomeGoodModel *)model
                addressModel:(RecoverAddressListInfo *)addressModel
                         num:(NSString *)num
                        type:(NSString *)type
                  completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self zfbBuyGood:model addressModel:addressModel orderType:type num:num payType:@"zx" completion:completion];
}

#pragma AB
- (void)getABOrderWithModel:(HomeGoodModel *)model
               addressModel:(RecoverAddressListInfo *)addressModel
                        num:(NSString *)num
                       type:(NSString *)type
                 completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self zfbBuyGood:model addressModel:addressModel orderType:type num:num payType:@"ab" completion:completion];
}
#pragma WX
- (void)getWXOrderWithModel:(HomeGoodModel *)model
               addressModel:(RecoverAddressListInfo *)addressModel
                        num:(NSString *)num
                       type:(NSString *)type
                 completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self zfbBuyGood:model addressModel:addressModel orderType:type num:num payType:@"wx" completion:completion];
}

- (void)getMustOrderWithModel:(HomeGoodModel *)model
               addressModel:(RecoverAddressListInfo *)addressModel
                        num:(NSString *)num
                       type:(NSString *)type
                 completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self zfbBuyGood:model addressModel:addressModel orderType:type num:num payType:@"must" completion:completion];
}
#pragma zifubao
- (void)getZFBOrderWithModel:(HomeGoodModel *)model
                addressModel:(RecoverAddressListInfo *)addressModel
                      num:(NSString *)num
                     type:(NSString *)type
               completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    [self zfbBuyGood:model addressModel:addressModel orderType:type num:num payType:@"zfb" completion:completion];
}

- (void)zfbBuyGood:(HomeGoodModel *)model
      addressModel:(RecoverAddressListInfo*)addressmodel
      orderType:(NSString *)order_type
            num:(NSString *)num
           payType:(NSString *)pay
     completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    __block BOOL hasRetured = NO;
    __block typeof(self) wself = self;
     NSString *address = [NSString stringWithFormat:@"%@%@",addressmodel.address,addressmodel.detail_address];
    
    if (!addressmodel) {
        address = @"";
    }
    
    MLog(@"PaySelectedController[ShareManager shareInstance].userinfo.id%@",[ShareManager shareInstance].userinfo.id);
    [HttpHelper getOrderWithOrderType:@"b" goods_id:model.id buy_num:num coupons_ids:@[model.coupons_id] type:order_type user_id:[ShareManager shareInstance].userinfo.id consignee_name:[ShareManager shareInstance].userinfo.nick_name consignee_tel:[ShareManager shareInstance].userinfo.user_tel consignee_address:address remark:@"" express_id:@"0" success:^(NSDictionary *dictionary) {
        MLog(@"获取订单：>>>>>dictionary%@",dictionary);
        NSString *status = [dictionary objectForKey:@"status"];
        NSString *description = [dictionary objectForKey:@"desc"];
        NSDictionary *orderNo = [dictionary objectForKey:@"data"];
        NSString *orderID = orderNo[@"orderid"];
        NSString *price = orderNo[@"all_price"];
          MLog(@"获取订单：>>>>>%@",orderID);
        if (![status isEqualToString:@"0"]) {
            
            if (completion) {
                NSDictionary *dict = [wself dictionaryWithKeyValue:description description:description data:nil];
                completion(NO, description, dict);
            }
        } else {
            @weakify(self);
            RACSignal *payChannelSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);

                if ([pay isEqualToString:@"zfb"]) {
                    
                _spayManager = [[SPayManager alloc] initWithViewController:self];
                [_spayManager payWithZFBOrderNo:orderID order_type:@"米花糖支付" money:[price intValue] payType:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
                    MLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                    
                    if (result) {
                        
                        [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                            
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }];
                        
                        NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                        [subscriber sendNext:dict];
                        //                                                      [subscriber sendCompleted];
                    } else {
                        NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                        [subscriber sendNext:dict];
                        [subscriber sendCompleted];
                    }
                }];
                }else if ([pay isEqualToString:@"zx"]){
                    _spayManager = [[SPayManager alloc] initWithViewController:self];
                    [_spayManager payWithZXOrderNo:orderID order_type:@"米花糖支付" money:[price intValue] payType:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
                        MLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                        
                        if (result) {
                            
                            [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                                
                                NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                                [subscriber sendNext:dict];
                                [subscriber sendCompleted];
                            }];
                            
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            //                                                      [subscriber sendCompleted];
                        } else {
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }
                    }];
                    
                }else if ([pay isEqualToString:@"ab"]){
                    _spayManager = [[SPayManager alloc] initWithViewController:self];
                    [_spayManager payWithABOrderNo:orderID order_type:@"米花糖支付" money:[price intValue] payType:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
                        MLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                        
                        if (result) {
                            
                            [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                                
                                NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                                [subscriber sendNext:dict];
                                [subscriber sendCompleted];
                            }];
                            
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            //                                                      [subscriber sendCompleted];
                        } else {
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }
                    }];
                }else if([pay isEqualToString:@"wx"]){
                    _spayManager = [[SPayManager alloc] initWithViewController:self];
                    [_spayManager payWithWXOrderNo:orderID order_type:@"米花糖支付" money:[price intValue] payType:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
                        MLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                        
                        if (result) {
                            
                            [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                                
                                NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                                [subscriber sendNext:dict];
                                [subscriber sendCompleted];
                            }];
                            
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            //                                                      [subscriber sendCompleted];
                        } else {
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }
                    }];
                }else if ([pay isEqualToString:@"must"]){
                     MLog(@"must支付");
                    _spayManager = [[SPayManager alloc] initWithViewController:self];
                    [_spayManager payWithMustOrderNo:orderID order_type:@"米花糖支付" money:[price intValue] payType:@"a" completion:^(BOOL result, NSString *description, NSDictionary *dict) {
                        MLog(@"must支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                        
                        if (result) {
                            
                            [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                                
                                NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                                [subscriber sendNext:dict];
                                [subscriber sendCompleted];
                            }];
                            
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            //                                                      [subscriber sendCompleted];
                        } else {
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }
                    }];
                }
                
                return nil;
            }];
       
            RACSignal *serverPayNofitySignal =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
                
                [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPayNotification object:nil] subscribeNext:^(NSNotification *notify) {
                    
                    MLog(@"rac notify %@", [notify.userInfo my_description]);
                    NSDictionary *dict = [notify userInfo];
                    if (dict) {
                        NSDictionary *data = [dict objectForKey:@"data"];
                        NSString *status = [dict objectForKey:@"status"];
                        
                        if ([status isEqualToString:@"0"] && data) {
                            
                            NSString *returnedOrderID = [data objectForKey:@"order_id"];
                            if (orderNo != nil && [returnedOrderID isEqualToString:orderID]) {
                                NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器返回充值结果" description:nil data:data];
                                [subscriber sendNext:dict];
                                [subscriber sendCompleted];
                            }
                        }
                    }
                }];
                
                return nil;
            }];
            
            RACSignal *signUpActiveSignal = [RACSignal  merge:@[payChannelSignal, serverPayNofitySignal]];
            
            [signUpActiveSignal subscribeNext:^(NSDictionary *dictionary) {
                
                MLog(@"finally = %@", [dictionary my_description]);
                
                NSString *str = [dictionary objectForKey:@"key"];
                
                if ([str isEqualToString:@"服务器返回充值结果"]) {
                    
                    if (hasRetured == NO) {
                        completion(YES, str, dictionary);
                    }
                    hasRetured = YES;
                }
                if ([str isEqualToString:@"超时"]) {
                    
                    if (hasRetured == NO) {
                        completion(NO, str, dictionary);
                    }
                    hasRetured = YES;
                }
                if ([str isEqualToString:@"支付渠道返回充值成功"]) {
                    
                    
                }
                if ([str isEqualToString:@"支付渠道充值失败"]) {
                    
                    if (hasRetured == NO) {
                        completion(NO, str, dictionary);
                    }
                    hasRetured = YES;
                }
            }];
            
//            _racSignal = signUpActiveSignal;
            
        }
        
    } failure:^(NSString *description) {
        
        if (completion) {
//            NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器生成订单失败" description:description data:nil];
//            completion(NO, description, dict);
        }
        
        MLog(@"%@", description);
    }];
    
}



- (void)buyGood:(HomeGoodModel *)model
           orderType:(NSString *)order_type
            num:(NSString *)num
          completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion
{
    

    __block BOOL hasRetured = NO;
    __block typeof(self) wself = self;
    
    if (![ShareManager shareInstance].addressModel.address) {
        ReciverAddressViewController *vc = [[ReciverAddressViewController alloc]initWithNibName:@"ReciverAddressViewController" bundle:nil];
//         
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    NSString *address = [NSString stringWithFormat:@"%@%@",[ShareManager shareInstance].addressModel.address,[ShareManager shareInstance].addressModel.detail_address];
    
    [HttpHelper getOrderWithOrderType:@"b" goods_id:model.id buy_num:num coupons_ids:@[] type:order_type user_id:[ShareManager shareInstance].userinfo.id consignee_name:[ShareManager shareInstance].userinfo.nick_name consignee_tel:[ShareManager shareInstance].userinfo.user_tel consignee_address:address remark:@"" express_id:@"0" success:^(NSDictionary *dictionary) {
        MLog(@"data%@",dictionary);
        NSString *status = [dictionary objectForKey:@"status"];
        NSString *description = [dictionary objectForKey:@"desc"];
        NSDictionary *orderNo = [dictionary objectForKey:@"data"];
        NSString *orderID = orderNo[@"orderid"];
        NSString *price = orderNo[@"all_price"];
        if (![status isEqualToString:@"0"]) {
            
            if (completion) {
                NSDictionary *dict = [wself dictionaryWithKeyValue:description description:description data:nil];
                completion(NO, description, dict);
            }
        } else {
            @weakify(self);
            RACSignal *payChannelSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                @strongify(self);
             _spayManager = [[SPayManager alloc] initWithViewController:self];
             PayType type = [self.selectedTheWayOfPayment payType];
            
            [_spayManager payWithOrderNo:orderID order_type:@"米花糖支付" money:[price intValue] payType:type completion:^(BOOL result, NSString *description, NSDictionary *dict) {
                MLog(@"支付 result = %d, description = %@, \n%@", result, description, [dictionary my_description]);
                
                if (result) {
                    
                    [[[RACSignal interval:30 onScheduler:[RACScheduler mainThreadScheduler]] take:1] subscribeNext:^(id x) {
                        
                        NSDictionary *dict = [self dictionaryWithKeyValue:@"超时" description:description data:dictionary];
                        [subscriber sendNext:dict];
                        [subscriber sendCompleted];
                    }];
                    
                    NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值成功" description:description data:dictionary];
                    [subscriber sendNext:dict];
                    //                                                      [subscriber sendCompleted];
                } else {
                    NSDictionary *dict = [self dictionaryWithKeyValue:@"支付渠道充值失败" description:description data:dictionary];
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                        }
            }];
            
            return nil;
        }];
        
        RACSignal *serverPayNofitySignal =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            
            [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kPayNotification object:nil] subscribeNext:^(NSNotification *notify) {
                
                MLog(@"rac notify %@", [notify.userInfo my_description]);
                NSDictionary *dict = [notify userInfo];
                if (dict) {
                    NSDictionary *data = [dict objectForKey:@"data"];
                    NSString *status = [dict objectForKey:@"status"];
                    
                    if ([status isEqualToString:@"0"] && data) {
                        
                        NSString *returnedOrderID = [data objectForKey:@"order_id"];
                        if (orderNo != nil && [returnedOrderID isEqualToString:orderID]) {
                            NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器返回充值结果" description:nil data:data];
                            [subscriber sendNext:dict];
                            [subscriber sendCompleted];
                        }
                    }
                }
            }];
            
            return nil;
        }];
        
        RACSignal *signUpActiveSignal = [RACSignal  merge:@[payChannelSignal, serverPayNofitySignal]];
        
        [signUpActiveSignal subscribeNext:^(NSDictionary *dictionary) {
            
           MLog(@"finally = %@", [dictionary my_description]);
            
            NSString *str = [dictionary objectForKey:@"key"];
            
            if ([str isEqualToString:@"服务器返回充值结果"]) {
                
                if (hasRetured == NO) {
                    completion(YES, str, dictionary);
                }
                hasRetured = YES;
            }
            if ([str isEqualToString:@"超时"]) {
                
                if (hasRetured == NO) {
                    completion(NO, str, dictionary);
                }
                hasRetured = YES;
            }
            if ([str isEqualToString:@"支付渠道返回充值成功"]) {
                
                
            }
            if ([str isEqualToString:@"支付渠道充值失败"]) {
                
                if (hasRetured == NO) {
                    completion(NO, str, dictionary);
                }
                hasRetured = YES;
            }
        }];
        
        _racSignal = signUpActiveSignal;
        
    }
     
     } failure:^(NSString *description) {
         
         if (completion) {
             NSDictionary *dict = [self dictionaryWithKeyValue:@"服务器生成订单失败" description:description data:nil];
             completion(NO, description, dict);
         }
         
         MLog(@"%@", description);
     }];

}

//- (PayManager *)selectedPayManager
//{
//
//    PayCategory payCategory = [self selectedPayCategory];
//    SPayManager *payManager = _spayManager;
//
//    switch (payCategory) {
//        case PayCategoryMustpay:
//        {
////            _mustpayManager = [[PayManager alloc] init];
////            payManager = _mustpayManager;
//        }
//            break;
//        case PayCategorySpay:
//        {
//            _spayManager = [[SPayManager alloc] initWithViewController:self];
//            payManager = _spayManager;
//
//            break;
//        }
//
//        default:
//            break;
//    }
//
//    return payManager;
//}


- (PaySelectedData *)selectedTheWayOfPayment
{
    PaySelectedData *data = nil;
    for (PaySelectedData *object in _array) {
        if (object.isSelected) {
            data = object;
            break;
        }
    }
    
    return data;
}

- (void)cleanSelected
{
    for (PaySelectedData *object in _array) {
        object.isSelected = NO;
    }
}

- (PayCategory)selectedPayCategory
{
    PaySelectedData *selectedPayment = [self selectedTheWayOfPayment];
    return selectedPayment.payCategory;
}

- (NSString *)paymentPermission:(int)startPrice
{
    NSString *str = @"";
    
    PaySelectedData *selectedPayment = [self selectedTheWayOfPayment];
    if (selectedPayment) {
        str = [selectedPayment paymentPermissionAtStartPrice:startPrice];
    }
    
    return str;
}

- (NSDictionary *)dictionaryWithKeyValue:(NSString *)keyValue description:(NSString *)description data:(NSDictionary *)dictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (keyValue) {
        [dict setObject:keyValue forKey:@"key"];
    }
    if (dictionary) {
        [dict setObject:dictionary forKey:@"data"];
    }
    if (description) {
        [dict setObject:description forKey:@"description"];
    }
    
    return dict;
}

@end
