//
//  PaySuccessTableViewController.h
//  DuoBao
//
//  Created by clove on 4/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaySuccessTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *data;

+ (PaySuccessTableViewController *)createWithData:(NSDictionary *)dictionary;

@end
