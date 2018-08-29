//
//  GetRMBGoodViewController.h
//  DuoBao
//
//  Created by 黎应明 on 2017/7/27.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJRecordListInfo.h"

@interface GetRMBGoodViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) ZJRecordListInfo *orderInfo;
@property (strong, nonatomic) NSString *order_type;
@end
