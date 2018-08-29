//
//  GoodsDetailInfoViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListInfo.h"


@interface GoodsDetailInfoViewController : UIViewController


@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *is_sixeight;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *joinBotton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *shopCartButton;
@property (weak, nonatomic) IBOutlet UILabel *shopCartNumLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;

- (IBAction)clickJoinButtonAction:(id)sender;
- (IBAction)clickAddButtonButtonAction:(id)sender;
- (IBAction)clickJShopCartButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *xjLabel;

@property (weak, nonatomic) IBOutlet UIView *jiexiaoView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

- (IBAction)clickGoButtonAction:(id)sender;

@end
