//
//  LuxyTableViewController.h
//  Luxy
//
//  Created by justin on 3/2/15.
//  Copyright (c) 2015 robyzhou. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableView.h"
#import "RHRefreshControl.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource, BaseTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) BaseTableView *tableView;
@property (nonatomic, weak) id<UIScrollViewDelegate> scrollViewDelegate;
@property (nonatomic, strong) RHRefreshControl *refreshControl;
@property (nonatomic) BOOL isExtinct;

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic) int pageNumber;
@property (nonatomic) int countPerPage;
@property (nonatomic) int numOfSection;

@property (nonatomic) int hightForFooter;

- (instancetype)initWithTableViewStyleGrouped;
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;

- (void)initRefreshTopViewDefault;
- (void)initRefreshTopView;
- (void)initRefreshTopViewWithoutIcon;

- (void)setBottomRefreshStyleWithGrayBackground;
- (void)setBottomOpaque:(BOOL)opaque;

- (void)setRefreshTopUnenabled;
- (void)refreshBottomEnabled:(BOOL)enabled;
- (void)extinctBottomLoading;
- (void)resetBottomLoading;
- (void)refreshStopAnimatingBottom;
- (void)refreshStopAnimatingTop;
- (void)autoRefreshTop;

- (void)scrollViewDidScrollToTopBlock:(void (^)(UIScrollView *scrollView))block;

- (UIView *)footerViewWithTitle:(NSString *)title;
- (void)footerButtonAction;


- (void)reloadListArray:(NSArray *)array;
- (void)appendListArray:(NSArray *)array;


@end
