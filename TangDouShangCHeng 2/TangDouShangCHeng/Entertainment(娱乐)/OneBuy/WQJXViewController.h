//
//  WQJXViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQJXViewController : UIViewController

@property (strong, nonatomic) NSString *goodId;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UITextField *textFiled;

@property (weak, nonatomic) IBOutlet UIButton *seeButton;

- (IBAction)clicSeeButtonAction:(id)sender;
@end
