//
//  BaseTabBarViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "NewMyViewController.h"
#import "ClassifyViewController.h"
#import "NewHomeViewController.h"
#import "CouponViewController.h"
#import "BaseNavViewController.h"
#import "BaseTableViewController.h"
#import "CalerderViewController.h"
#import "NewHomeViewController.h"
#import "ShoppingCarVC.h"
@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"5AD485"];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    NSString *tabBarImageNameNormal = @"default_tab_icon_home";
    NSString *tabBarImageNameSelected = @"select_tab_icon_home";
    NSString *title = @"首页";
//    NewShopHomeViewController
    NewHomeViewController *homeVC = [[NewHomeViewController alloc] initWithTableViewStyle:1];
//    NewShopHomeViewController *homeVC = [[NewShopHomeViewController alloc] initWithTableViewStyle:1];
    BaseNavViewController *homeNav = [[BaseNavViewController alloc] initWithRootViewController:homeVC];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    homeVC.tabBarItem = tabBarItem;
    
    
    NewClassifyViewController *classifyVC = [NewClassifyViewController alloc];
    BaseNavViewController *classifyNav = [[BaseNavViewController alloc] initWithRootViewController:classifyVC];
    tabBarImageNameNormal = @"default_tab_icon_classificatition";
    tabBarImageNameSelected = @"select_tab_icon_classificatition";
    title = @"分类";
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    classifyVC.tabBarItem = tabBarItem;
    
//    CalerderViewController *Calerdervc = [[CalerderViewController alloc] init];
//     ShoppingCarVC *Calerdervc = [[ShoppingCarVC alloc] init];
    NewCalerderViewController *Calerdervc = [[NewCalerderViewController alloc]initWithNibName:@"NewCalerderViewController" bundle:nil];
    BaseNavViewController *calerNav = [[BaseNavViewController alloc] initWithRootViewController:Calerdervc];
    tabBarImageNameNormal = @"tab_index";
    tabBarImageNameSelected = @"tab_index_selected";
    title = @"签到";
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    Calerdervc.tabBarItem = tabBarItem;
    
    
    
//    CouponViewController *couponVC = [[CouponViewController alloc]initWithTableViewStyle:1];
//    BaseNavViewController *couponNav = [[BaseNavViewController alloc] initWithRootViewController:couponVC];
//    tabBarImageNameNormal = @"default_tab_icon_coupon";
//    tabBarImageNameSelected = @"select_tab_icon_coupon";
//    title = @"优惠劵";
//    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
//    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
//    couponVC.tabBarItem = tabBarItem;
//NewShopMyOrderViewController
//    NewMyViewController *myVC = [[NewMyViewController alloc]initWithTableViewStyle:1];
     NewShopMyViewController *myVC = [[NewShopMyViewController alloc]initWithTableViewStyle:1];
    BaseNavViewController *myNav = [[BaseNavViewController alloc] initWithRootViewController:myVC];
    tabBarImageNameNormal = @"default_tab_icon_me";
    tabBarImageNameSelected = @"select_tab_icon_me";
    title = @"我的";
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:tabBarImageNameNormal] selectedImage:[UIImage imageNamed:tabBarImageNameSelected]];
//    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
    tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    myVC.tabBarItem = tabBarItem;
    
    NSArray *navArray = [NSArray arrayWithObjects:homeNav,classifyNav,myNav, nil];
    [self setViewControllers:navArray];
   
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{

    if ([item.title isEqualToString:@"优惠劵"]) {
        if (![Tool islogin]) {
            [Tool loginWithAnimated:YES viewController:nil];
             MLog(@"tabbar%@",item.title);
        }
    }
   
   
    
    
}


@end
