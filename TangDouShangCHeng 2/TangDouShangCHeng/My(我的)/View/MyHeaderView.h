//
//  MyHeaderView.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/31.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
@interface MyHeaderView : UIView
//@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//@property (weak, nonatomic) IBOutlet UIView *bgView;
//@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong,nonatomic) UserInfo *userInfo;
@end
