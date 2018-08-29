//
//  PaySelectedController.h
//  DuoBao
//
//  Created by clove on 3/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaySelectedData.h"
#import "HomeGoodModel.h"
@interface PaySelectedController : UITableViewController


- (instancetype)initWithPurchaseGoods;

- (CGFloat)height;




- (PayCategory)selectedPayCategory;

// 最低充值金额。 微信支付宝不支持一元活动，为了规避微信支付宝检查，不得不禁止用户充值一块钱购买订单
// @"allow" 表示允许购买
- (NSString *)paymentPermission:(int)startPrice;


- (void)getOrderWithModel:(HomeGoodModel *)model
                      num:(NSString *)num
                     type:(NSString *)type
               completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)getZFBOrderWithModel:(HomeGoodModel *)model
                addressModel:(RecoverAddressListInfo *)addressModel
                         num:(NSString *)num
                        type:(NSString *)type
                  completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)getZXOrderWithModel:(HomeGoodModel *)model
               addressModel:(RecoverAddressListInfo *)addressModel
                        num:(NSString *)num
                       type:(NSString *)type
                 completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;
- (void)getABOrderWithModel:(HomeGoodModel *)model
               addressModel:(RecoverAddressListInfo *)addressModel
                        num:(NSString *)num
                       type:(NSString *)type
                 completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)getWXOrderWithModel:(HomeGoodModel *)model
               addressModel:(RecoverAddressListInfo *)addressModel
                        num:(NSString *)num
                       type:(NSString *)type
                 completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;

- (void)getMustOrderWithModel:(HomeGoodModel *)model
                 addressModel:(RecoverAddressListInfo *)addressModel
                          num:(NSString *)num
                         type:(NSString *)type
                   completion:(void (^)(BOOL result, NSString *description, NSDictionary *dict))completion;
@end
