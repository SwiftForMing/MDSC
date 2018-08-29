//
//  PayManager.h
//  DuoBao
//
//  Created by clove on 2/4/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayManager : NSObject

- (void)payWithOrderNo:(NSString *)orderNo
            order_type:(NSString *)order_type
                 money:(int)all_price
               payType:(PayType)spayType
            completion:(void (^)(BOOL result, NSString *description,  NSDictionary *dict))completion;

@end
