//
//  DuoBaoRecordViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DuoBaoRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//@property (weak, nonatomic) IBOutlet UIButton *allButton;
//@property (weak, nonatomic) IBOutlet UIButton *jxzButton;
//@property (weak, nonatomic) IBOutlet UIButton *yjxButton;
@property (weak, nonatomic) IBOutlet UILabel *allLine;
@property (weak, nonatomic) IBOutlet UILabel *jxzLine;
@property (weak, nonatomic) IBOutlet UILabel *yjxLine;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headIconWidth;
//
//- (IBAction)clickAllButtonAction:(id)sender;
//- (IBAction)clickJXZButtonAction:(id)sender;
//- (IBAction)clickYJXButtonAction:(id)sender;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *flag;
@end
