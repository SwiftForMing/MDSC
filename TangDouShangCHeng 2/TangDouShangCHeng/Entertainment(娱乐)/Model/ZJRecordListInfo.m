//
//  ZJRecordListInfo.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ZJRecordListInfo.h"

@implementation ZJRecordListInfo

- (NSString *)nick_name
{
    NSString *name = _nick_name;
    
    if (name.length == 0 || [name isEqualToString:@"<null>"]) {
        name = @"匿名";
    }
    
    UserInfo *userInfo = [ShareManager shareInstance].userinfo;
    if ([_win_user_id isEqualToString:userInfo.id ?:@""]) {
        name = userInfo.nick_name;
    }
    
    return name;
}

- (BOOL)isVirtualGoods
{
    BOOL result = NO;
    
    NSString *goodsName = _good_name;
    result = [goodsName containsString:@"虚拟物品"] || [goodsName containsString:@"充值卡"] || [_goods_type containsString:@"虚拟商品"] || [_goods_type containsString:@"虚拟"];

    return result;
}

- (NSString *)courier_name
{
    NSString *str = _courier_name;
    
    if ([str isEqualToString:@"<null>"]) {
        str = nil;
    }
    
    return str;
}

- (NSString *)win_num
{
    NSString *str = _win_num;
    
    if ([str isEqualToString:@"<null>"]) {
        str = @"";
    }
    
    return str;
}

- (NSString *)courier_id
{
    NSString *str = _courier_id;
    
    if ([str isEqualToString:@"<null>"]) {
        str = nil;
    }
    
    return str;
}

- (NSString *)goodsStatus
{
    NSString *str = _order_status;
    
    if ([self isVirtualGoods]) {
        
        if ([self hasWinCrowdfunding]) {

            str = _order_status;

            if ([_get_type isEqualToString:@"dbb"] || [_get_type isEqualToString:@"兑换夺宝币"]) {
                str = @"已兑换小米";
            } else if ([_get_type isEqualToString:@"czk"] || [_get_type isEqualToString:@"兑换充值卡"]) {
                str = @"卡密已派发";
                if (_rechargeList.count == 0) {
                    if ([_get_type isEqual:@"转赠"]) {
                        
                        if ([_order_status isEqual:@"已转赠"]){
                            
                            str = @"已转让";
                        }else{
                            str = @"等待对方确认";
                        }
//                       str = @"等待对方确认";
                    
                    }else{
                    
//                     str = @"卡密已派发";
                        
                        str = _order_status;
                    }
                }
            } else {
                if ([_get_type isEqual:@"转赠"]) {
                    if ([str  isEqual: @"待发货"]){
                        if ([_order_status isEqual:@"已转赠"]){
                            str = @"已转让";
                        }else{
                            str = @"等待对方确认";
                        }
                    }else{
                         str = @"已转让";
                    }
                }
               
            }
        }else {
//            str = _thriceOrderStatus;

            if ([self hasWinThrice]) {
                str = @"仅三赔中奖";
            } else {
                if ([_get_type isEqual:@"转赠"]) {
                    if ([str  isEqual: @"待发货"]){
                            str = @"等待对方确认";
                    }else{
                         str = @"已转让";
                    }
                
                }else{
                    
                    if ([_get_type isEqualToString:@"dbb"] || [_get_type isEqualToString:@"兑换夺宝币"]) {
                        str = @"已兑换小米";
                    } else if ([_get_type isEqualToString:@"czk"] || [_get_type isEqualToString:@"兑换充值卡"]) {
                        if ([_order_status isEqualToString:@"已发货"]) {
                            str = @"卡密已派发";
                        }else{
                            str = _order_status;
                        }
                        
                    }else{
                        str = @"待发货";
                    }
                
                }
               
            }
        }
    } else {
        
        if ([self hasWinCrowdfunding]) {
            
            str = _order_status;
            
            if ([_confirm_adress isEqualToString:@"y"] == NO) {
                if ([_get_type isEqual:@"转赠"]) {
                    if ([_order_status isEqual:@"已转赠"]){
                        
                        str = @"已转让";
                    }else{
                        str = @"等待对方确认";
                    }
//                     str = @"等待对方确认";
                }else{
                     str = @"请确认收货地址";
                }
               
            } else {
                
                if ([self.courier_name isEqualToString:@"订单开始处理,请耐心等待"]) {
                    str = @"正在出库，请耐心等待物流订单";
                } else {
                    if (self.courier_name.length == 0) {
                        if ([_get_type isEqual:@"转赠"]) {
                            if ([_order_status isEqual:@"已转赠"]){
                            
                                 str = @"转让成功";
                            }else{
                                str = @"等待对方确认";
                            }
                
                        }else{
                        
                         str = @"等待商品派发";
                        }

                        
//                        str = @"等待商品派发";
                    } else {
                        
                        if ([_get_type isEqual:@"转赠"]) {
                            
                            str = @"已转让";
                            
                        }else{
                            
                            str = @"已发货";
                        }
//                        str = @"已发货";
                    }
                }
            }
        } else {
            
            str = _thriceOrderStatus;

            if ([self hasWinThrice]) {
                str = @"仅三赔中奖";
            } else {
                
                if ([_get_type isEqual:@"转赠"]) {
                    if ([_order_status isEqual:@"已转赠"]){
                        
                        str = @"转让成功";
                    }else{
                        str = @"等待对方确认";
                    }
//                        str = @"等待对方确认";
                    
                }else{
                    str = _order_status;
                    
                    if ([_confirm_adress isEqualToString:@"y"] == NO) {
                        
                        str = @"请确认收货地址";
                    } else {
                        
                        if ([self.courier_name isEqualToString:@"订单开始处理,请耐心等待"]) {
                            str = @"正在出库，请耐心等待物流订单";
                        } else {
                            if (self.courier_name.length == 0) {
                                if ([_get_type isEqual:@"转赠"]) {
                                    if ([_order_status isEqual:@"已转赠"]){
                                        
                                        str = @"转让成功";
                                    }else{
                                        str = @"等待对方确认";
                                    }
                                    
                                }else{
                                    
                                    str = @"等待商品派发";
                                }
                                
                                
                                //                        str = @"等待商品派发";
                            } else {
                                
                                if ([_get_type isEqual:@"转赠"]) {
                                    
                                    str = @"已转让";
                                    
                                }else{
                                    
                                    str = @"已发货";
                                }
                                //                        str = @"已发货";
                            }
                        }
                    }
                }

                
//                str = @"别人的中奖列表";
            }
        }
    }
    
    return str;
}

- (BOOL)onlyOneRecharge
{
    BOOL result = YES;
    
    if (_rechargeList.count > 1) {
        result = NO;
    }
    
    return result;
}

- (int)cardCount
{
    int m = [_goodvalues intValue];
    
    // 每张卡面额100
    int number = m / 10000;
    
    return number;
}

- (NSString *)firstCardNumber
{
    NSDictionary *dict = [_rechargeList firstObject];
    NSString *str = [dict objectForKey:@"card_number"];
    return str;
}

- (NSString *)firstCardPassword
{
    NSDictionary *dict = [_rechargeList firstObject];
    NSString *str = [dict objectForKey:@"card_pass"];
    return str;
}

- (BOOL)isThriceGoods
{
    BOOL result = NO;
    
    if ([_part_sanpei isEqualToString:@"y"]) {
        result = YES;
    }
    
    return result;
}

- (NSString *)thriceOrderID
{
    NSString *str = _thriceOrderID;
    
    if (str.length == 0) {
        str = _order_id;
    }
    
    return str;
}

//- (void)setThriceOrderStatus:(NSString *)thriceOrderStatus
//{
//    // 三赔中了，一元购没中，_order_status描述的是三赔，领取小米后数据发生变化手动修改订单状态
//    if (_thriceOrderStatus.length == 0) {
//        _order_status = thriceOrderStatus;
//    } else {
//        _thriceOrderStatus = thriceOrderStatus;
//    }
//}

- (NSString *)thricePrizeNumber
{
    NSString *win_num = _win_num;
    NSString *str = [win_num substringFromIndex:win_num.length - 1];
    return str;
}

- (BOOL)hasBettingThrice
{
    BOOL result = NO;
    if (_sanpeiRecordList.count > 0) {
        result = YES;
    }
    
    return result;
}

- (BOOL)hasWinThrice
{
    BOOL result = NO;
    
    NSArray *array = _sanpeiRecordList;
    if (array.count > 0) {
        NSString *prizeNumber = [self thricePrizeNumber];
        if ([prizeNumber isEqualToString:@"1"] || [prizeNumber isEqualToString:@"4"] || [prizeNumber isEqualToString:@"7"] ) {
            prizeNumber = @"1";
        }
        if ([prizeNumber isEqualToString:@"2"] || [prizeNumber isEqualToString:@"5"] || [prizeNumber isEqualToString:@"8"] ) {
            prizeNumber = @"2";
        }
        if ([prizeNumber isEqualToString:@"3"] || [prizeNumber isEqualToString:@"6"] || [prizeNumber isEqualToString:@"9"] ) {
            prizeNumber = @"3";
        }
        if ([prizeNumber isEqualToString:@"0"]) {
            prizeNumber = @"0";
        }
        
        int prizeType = [prizeNumber intValue];
        NSArray *thriceBettingArray = [ServerProtocol thriceBettingArrayWithData:array];
        
        for (NSDictionary *bettingDict in thriceBettingArray) {
            NSString *str = [bettingDict objectForKey:@"type"];
            int type = [str intValue];
            if (type == prizeType) {
                result = YES;
                break;
            }
        }
    }
    
    return result;
}

- (BOOL)hasWinCrowdfunding
{
    BOOL result = NO;
    
    NSString *userID = [ShareManager shareInstance].userinfo.id;
    userID = userID?:@"xx";
    
    if ([_win_user_id isEqualToString:userID]) {
        result = YES;
    }
    
    return result;
}

- (BOOL)hasAcceptWinningThirceCoin
{
    BOOL result = NO;
    BOOL hasWinThrice = [self hasWinThrice];
    NSString *status = _thriceOrderStatus;
    
//    // 没有发生都一元购，三赔都中奖
//    if (_thriceOrderStatus.length > 0) {
//        status = _thriceOrderStatus;
//    }
    
    // 只中了三赔
    if (hasWinThrice == YES && [status isEqualToString:@"已发货"]) {
        result = YES;
    }
    
    return result;
}

@end
