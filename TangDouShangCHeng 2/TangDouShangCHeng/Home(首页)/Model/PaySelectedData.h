//
//  PaySelectedData.h
//  DuoBao
//
//  Created by clove on 3/12/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PayCategoryNone,
    PayCategoryMustpay,
    PayCategorySpay
} PayCategory;

@interface PaySelectedData : NSObject
@property (nonatomic, copy) NSString *pay_channel_name;
@property (nonatomic, copy) NSString *pay_channer_code;
@property (nonatomic, copy) NSString *pay_channer_desc;
@property (nonatomic, copy) NSString *pay_img;
@property (nonatomic, copy) NSString *pay_prior;
@property (nonatomic, copy) NSString *pay_limit;        // 最低充值金额。 微信支付宝不支持一元活动，为了规避微信支付宝检查，不得不禁止用户充值一块钱购买订单

@property (nonatomic) BOOL isSelected;

- (PayCategory)payCategory;
- (PayType)payType;
- (NSString *)title;
- (NSString *)imagePath;
- (NSString *)paymentPermissionAtStartPrice:(int)startPrice;

- (UIImage *)image;

@end
