//
//  EntOrderViewController.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/26.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "BaseTableViewController.h"

@interface EntOrderViewController : BaseTableViewController
@property (nonatomic, copy) NSDictionary *data;
+ (EntOrderViewController *)createWithData:(NSDictionary *)data;
@end
