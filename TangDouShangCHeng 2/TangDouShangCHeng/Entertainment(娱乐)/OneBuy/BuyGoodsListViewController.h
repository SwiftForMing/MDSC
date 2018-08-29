//
//  BuyGoodsListViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/23.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyGoodsListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
