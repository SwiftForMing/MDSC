//
//  GoodsListViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (assign, nonatomic) BOOL isSearch;

@property (strong, nonatomic) NSString *typeId;
@property (strong, nonatomic) NSString *typeName;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
