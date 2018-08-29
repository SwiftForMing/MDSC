//
//  ExpressModel.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/22.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressModel : NSObject

/*
 "express_name": "免邮",
 "id": 1001,
 "status": "y",
 "is_default": "y",
 "creaat_time": 1505466702000,
 "express_price": "0"
 
 
 "id": 1002,
 "express_price": "20",
 "creaat_time": 1506071520000,
 "is_default": "n",
 "express_name": "顺丰快递",
 "status": "y"
 
 */

@property (nonatomic, strong) NSString *express_price;
@property (nonatomic, strong) NSString *good_id;
@property (nonatomic, strong) NSString *is_default;
@property (nonatomic, strong) NSString *express_name;
@property (nonatomic, strong) NSString *id;
@property (strong, nonatomic) NSString *status;

@end
