//
//  PaySelectedData.m
//  DuoBao
//
//  Created by clove on 3/12/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySelectedData.h"

@implementation PaySelectedData

- (PayCategory)payCategory
{
    PayCategory type = PayCategoryNone;
    
    NSString *str = _pay_channer_code;
    if ([str containsString:@"zhifubao"]) {
        type = PayCategoryMustpay;
    } else if ([str containsString:@"zhongxing"]) {
        type = PayCategorySpay;
    }
    
    return type;
}

- (PayType)payType
{
    PayType type = PayTypeAlipay;
    
#if DEBUG
    
    type = PayTypeAlipay;
#endif
    
    return type;
}

- (NSString *)title
{
    return _pay_channel_name;
}

- (NSString *)imagePath
{
    return _pay_img;
}

- (NSString *)paymentPermissionAtStartPrice:(int)startPrice
{
    NSString *str = @"allow";
    
    int limitPrice = [_pay_limit intValue];
    if (startPrice < limitPrice && limitPrice != 0) {
        str = [NSString stringWithFormat:@"最低充值金额为%d，请见谅～", limitPrice];
    }
    
    return str;
}

- (UIImage *)image
{
    UIImage *image = [UIImage imageNamed:@"icon_alipay"];
    
    NSString *description = _pay_channer_desc;
    
    if ([description isEqualToString:@"onechanel"]) {
        image = [UIImage imageNamed:@"icon_wechat"];
    }
    if ([description isEqualToString:@"weixin_zhongxin"]) {
        image = [UIImage imageNamed:@"icon_alipay"];
    }
    if ([description isEqualToString:@"alipay_zhongxin"]) {
        image = [UIImage imageNamed:@"icon_alipay"];
    }
    
    return image;
}

@end
