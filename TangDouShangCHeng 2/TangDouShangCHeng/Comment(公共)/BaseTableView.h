//
//  BaseTableView.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BaseTableViewDelegate <UITableViewDelegate>

@optional
- (UIView *)emptyViewForTableView:(UITableView *)tableView;

@end
@interface BaseTableView : UITableView

@end
