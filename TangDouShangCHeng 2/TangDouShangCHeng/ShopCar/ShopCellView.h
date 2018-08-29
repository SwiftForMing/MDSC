//
//  SelectGoodsNumberView.h
//  DuoBao
//
//  Created by clove on 11/21/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailInfo.h"

@class GoodsFightModel;

@protocol SelectGoodsNumberViewDelegate <NSObject>

- (void)didSelectPurchaseNumber:(int)purchaseNumber;
- (void)cancelPurchase;

@end

@interface ShopCellView: UIView
@property (nonatomic, weak) id<SelectGoodsNumberViewDelegate> delegate;
@property (nonatomic) int buyNum;
@property (nonatomic, strong) GoodsDetailInfo *detailInfo;
@property (nonatomic, strong) GoodsFightModel *model;
@property (nonatomic) int purchaseCount;

- (void)dismissAnimation;

@end
