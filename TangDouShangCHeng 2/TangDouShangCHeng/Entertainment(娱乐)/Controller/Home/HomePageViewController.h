//
//  HomePageViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VCChangeSelectBlock)(BOOL isMK);

@interface HomePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, copy) VCChangeSelectBlock ChangeBlock;
// 点击首页tab，刷新间隔30秒，自动刷新
- (void)autorefresh;

@end
