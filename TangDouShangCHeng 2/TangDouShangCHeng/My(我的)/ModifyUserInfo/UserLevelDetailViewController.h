//
//  UserLevelDetailViewController.h
//  DuoBao
//
//  Created by 林奇生 on 16/3/23.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLevelDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabelWidth;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end


@interface MyLevelInfo : NSObject

@property (nonatomic, strong) NSString *differ_score;
@property (nonatomic, strong) NSString *level_order;
@property (nonatomic, strong) NSString *user_score_all;
@property (nonatomic, strong) NSString *is_max_score;

@end

@interface LevelRulesInfo : NSObject

@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *img;

@property (nonatomic, strong) NSString *is_open;
@property (nonatomic, strong) NSString *level_id;
@property (nonatomic, strong) NSString *order_by_id;
@property (nonatomic, strong) NSString *remark;

@end