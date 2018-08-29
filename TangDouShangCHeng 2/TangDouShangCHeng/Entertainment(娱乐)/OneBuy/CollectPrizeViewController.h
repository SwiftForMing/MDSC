//
//  CollectPrizeViewController.h
//  DuoBao
//
//  Created by clove on 11/3/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJRecordListInfo.h"

@interface CollectPrizeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) ZJRecordListInfo *orderInfo;

@end
