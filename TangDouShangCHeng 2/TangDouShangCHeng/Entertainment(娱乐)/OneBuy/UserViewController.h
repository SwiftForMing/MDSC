//
//  UserViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/16.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (strong, nonatomic) NSString *userId;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabelWidth;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *levelLabelWidth;

@property (weak, nonatomic) IBOutlet UIButton *dbButton;
@property (weak, nonatomic) IBOutlet UIButton *zjButton;
@property (weak, nonatomic) IBOutlet UIButton *sdButton;
@property (weak, nonatomic) IBOutlet UILabel *dbLine;
@property (weak, nonatomic) IBOutlet UILabel *zjLine;
@property (weak, nonatomic) IBOutlet UILabel *sdLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

- (IBAction)clickDBButtonAction:(id)sender;
- (IBAction)clickZJButtonAction:(id)sender;
- (IBAction)clickSDButtonAction:(id)sender;

@end
