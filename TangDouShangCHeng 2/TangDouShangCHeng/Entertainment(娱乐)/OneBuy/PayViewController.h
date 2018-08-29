//
//  PayViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayViewControllerDelegate <NSObject>
@optional
- (void)payForBuyGoodsSuccess;
@end

@interface PayViewController : UIViewController

@property (assign, nonatomic) double moneyNum;
@property (strong, nonatomic) NSString *goodsIds;
@property (strong, nonatomic) NSString *goods_buy_nums;
@property (assign, nonatomic) BOOL isShopCart;

@property (nonatomic, assign) id<PayViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *payAllMoney;

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;

@property (weak, nonatomic) IBOutlet UILabel *djbLabel;

@property (weak, nonatomic) IBOutlet UIImageView *djbImage;
@property (weak, nonatomic) IBOutlet UIImageView *zfbImage;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImage;

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paySelectHeight;
@property (weak, nonatomic) IBOutlet UILabel *moneyShortcutContainer;

@property (weak, nonatomic) IBOutlet UIView *payView;

- (IBAction)clickGoodsNumAction:(id)sender;
- (IBAction)clickPayButtonAction:(id)sender;
- (IBAction)clickCouponsAction:(id)sender;

- (IBAction)clickDJBAction:(id)sender;
- (IBAction)clickZFBAction:(id)sender;
- (IBAction)clickWeiXinAction:(id)sender;

@end
