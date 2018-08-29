//
//  SearchGoodsViewController.h
//  YCSH
//
//  Created by linqsh on 16/1/4.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGoodsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *searchBgView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *cannelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableBottom;

- (IBAction)clickCannelButtonAction:(id)sender;

@end
