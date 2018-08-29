//
//  ModifyDetailInfoViewController.m
//  YCSH
//
//  Created by linqsh on 16/1/6.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ModifyDetailInfoViewController.h"

@interface ModifyDetailInfoViewController ()

@end

@implementation ModifyDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"修改昵称";
    _contentText.placeholder = @"请填写您的昵称";
    _contentText.text = _contentStr;
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftControlAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"保存" forState:UIControlStateNormal];
    
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,12)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}


#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    if (_contentText.text.length < 1) {
        [Tool showPromptContent:@"请输入内容" onView:self.view];
        return;
    }
    [self UpdateUserInfoWithName:_contentText.text];
}

#pragma mark - http

- (void)UpdateUserInfoWithName:(NSString *)nameStr
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"数据提交中...";
    
    __weak ModifyDetailInfoViewController *weakSelf = self;
    [HttpHelper changeUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                           fieldName:@"nick_name"
                      fieldNameValue:nameStr
                  updateFieldNameNum:@"1"
                             success:^(NSDictionary *resultDic){
                                 [HUD hide:YES];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadUpdateUserInfoResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }

                             }fail:^(NSString *decretion){
                                 [HUD hide:YES];
                                 [Tool showPromptContent:@"网络出错了" onView:self.view];
                             }];
    
}
- (void)handleloadUpdateUserInfoResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"修改成功" onView:self.view];
    
    [ShareManager shareInstance].userinfo.nick_name = _contentText.text;
    [Tool saveUserInfoToDB:YES];
    
    if([self.delegate respondsToSelector:@selector(modiftyUserInfoSuccesss)])
    {
        [self.delegate modiftyUserInfoSuccesss];
    }
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}


@end
