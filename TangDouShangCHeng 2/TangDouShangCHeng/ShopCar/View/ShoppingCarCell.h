//
//  ShoppingCarCell.h
//  ShoppingCarDemo
//
//  Created by huanglianglei on 15/11/5.
//  Copyright © 2015年 huanglianglei. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShoppingModel.h"

#import "AddNumberView.h"
#import "LineLabel.h"
#import "GoodsListInfo.h"
#import "ShopCartInfo.h"
@protocol ShoppingCarCellDelegate;
@interface ShoppingCarCell : UITableViewCell<AddNumberViewDelegate>


@property (nonatomic, assign) int buynum;

@property (nonatomic,strong) UIImageView *checkImg;

@property (nonatomic,strong) UIImageView *shopImageView;

@property (nonatomic,strong) UILabel *shopNameLab;

@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) LineLabel *oldPriceLab;//原价

@property (nonatomic, strong)  LDProgressView *lefeNewProcess;

@property (nonatomic,strong) UILabel *shopTypeLab;//商品型号

@property (nonatomic,strong) UIButton *jianBtn;//减数量按钮

@property (nonatomic,strong) UIButton *addBtn;//加数量按钮

@property (nonatomic,strong) UILabel *numberLab;//显示数量
@property (nonatomic,strong) UILabel *line;//显示数量
//@property (nonatomic,strong) ShoppingModel *shoppingModel;

@property (nonatomic,strong) ShopCartInfo *shoplistModel;

@property (assign,nonatomic) BOOL selectState;//选中状态

@property (nonatomic,assign) id<ShoppingCarCellDelegate>delegate;

@property (nonatomic,strong) AddNumberView *addNumberView;

@end

@protocol ShoppingCarCellDelegate

-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag andNum:(int)num;

@end
