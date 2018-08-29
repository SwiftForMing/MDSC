//
//  BaseViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)dealloc
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), NSStringFromClass([self class]));
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftBarButtonItemArrow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;   
}




- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:title
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(rightBarButtonItemAction:)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)setLeftBarButtonItem:(NSString *)title
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithTitle:title
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(leftBarButtonItemAction:)];
    self.navigationItem.leftBarButtonItem = button;
}

- (void)setRightBarButtonItemMore
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"header_icon_more"]
             style:UIBarButtonItemStyleBordered
            target:self
            action:@selector(rightBarButtonItemAction:)];
    
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)setRightBarButtonItemEdit
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pdi_bottom_edit"]
            style:UIBarButtonItemStyleBordered
           target:self action:@selector(rightBarButtonItemAction:)];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"pdi_bottom_edit_pressed"]
                          forState:UIControlStateHighlighted
                        barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)setLeftBarButtonItemArrow
{
    if (self.navigationController == nil) {
        return;
    }
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}
-(void)hidenLeftBarButton{
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)leftBarButtonItemAction:(id)sender
{
    
}

- (void)rightBarButtonItemAction:(id)sender
{
    
}

- (void)hiddenWithTitle:(NSString *)title
{
    [self hiddenWithTitle:title detail:nil];
}

- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail
{
    [self hiddenWithTitle:title detail:detail afterDelay:2.0];
}

- (void)hiddenWithTitle:(NSString *)title detail:(NSString *)detail afterDelay:(NSTimeInterval)time
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    HUD.labelText = title;
    HUD.detailsLabelText = detail;
    HUD.mode = MBProgressHUDModeText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:time];
}

- (void)hiddenWithCheckMark:(NSString *)title
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:HUD];
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = title;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:2];
}

- (MBProgressHUD *)showLoading
{
    return [self showLoadingWithTitle:@"加载"];
}

- (MBProgressHUD *)showLoadingWithTitle:(NSString *)title
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = title;
    [HUD show:YES];
    return HUD;
}

- (UIButton *)createButtonWithLeftMargin:(CGFloat)left top:(CGFloat)top height:(CGFloat)height title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.height = height;
    button.width =  [UIScreen mainScreen].bounds.size.width - 2*left;
    button.left = left;
    button.top = top;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2;
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)footerButtonAction
{
    
}


@end
