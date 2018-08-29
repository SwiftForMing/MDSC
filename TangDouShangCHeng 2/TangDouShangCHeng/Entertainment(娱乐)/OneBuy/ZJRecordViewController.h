//
//  ZJRecordViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *is_happybean_goods;
@end
