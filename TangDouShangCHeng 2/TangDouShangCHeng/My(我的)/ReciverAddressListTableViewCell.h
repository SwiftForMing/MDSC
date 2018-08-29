//
//  ReciverAddressListTableViewCell.h
//  YiDaMerchant
//
//  Created by linqsh on 15/9/27.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReciverAddressListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabelHeight;
@property (weak, nonatomic) IBOutlet UILabel *bgView;

@property (weak, nonatomic) IBOutlet UIButton *setAddressButton;

@end
