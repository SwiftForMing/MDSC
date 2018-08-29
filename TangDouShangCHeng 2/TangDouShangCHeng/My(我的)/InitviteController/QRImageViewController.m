//
//  QRImageViewController.m
//  DuoBao
//
//  Created by clove on 12/18/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "QRImageViewController.h"

@interface QRImageViewController ()

@end

@implementation QRImageViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的二维码";
    
    float width = 240 * UIAdapteRate;
    
    NSString *link = [Tool inviteFriendToRegisterAddress:[ShareManager userID]];
    UIImage *image = [Tool encodeQRImageWithContent:link size:CGSizeMake(width, width)];
    //    UIImage *image = PublicImage(@"defaultImage");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.left = (ScreenWidth - width) / 2;
    imageView.top = 100 * UIAdapteRate;
    
    [self.view addSubview:imageView];

    [self setLeftBarButtonItemArrow];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
