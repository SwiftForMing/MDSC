//
//  ALiPayBangViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "ALiPayBangViewController.h"

@interface ALiPayBangViewController ()

@end

@implementation ALiPayBangViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _sureButton.backgroundColor = [UIColor defaultRedButtonColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
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
    self.title = @"支付宝设置";
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = _sureButton.height/2;
    
    UserInfo *info = [ShareManager shareInstance].userinfo;
    if ([info.payment_id isEqualToString:@"<null>"]) {
        _accountText.text = @"";
    }else{
        _accountText.text = info.payment_id;
    }
    
    if ([info.payment_name isEqualToString:@"<null>"]) {
        _nameText.text = @"";
    }else{
        _nameText.text = info.payment_name;
    }
    
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

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    if (_accountText.text.length < 1) {
        [Tool showPromptContent:@"请输入支付宝账户" onView:self.view];
        return;
    }
    if (_nameText.text.length < 1) {
        [Tool showPromptContent:@"请输入您在支付宝的姓名" onView:self.view];
        return;
    }
    
    NSString *valueStr = [NSString stringWithFormat:@"%@,%@",_accountText.text,_nameText.text];
    [self updateUserInfoWithValue:valueStr];
}

#pragma mark - http

- (void)updateUserInfoWithValue:(NSString *)valueStr
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"数据提交中...";
    
    __weak ALiPayBangViewController *weakSelf = self;
    [HttpHelper changeUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                           fieldName:@"payment_id,payment_name"
                      fieldNameValue:valueStr
                  updateFieldNameNum:@"2"
                             success:^(NSDictionary *resultDic){
                                 [HUD hide:YES];
                                 if([[resultDic objectForKey:@"status"] integerValue] == 0)
                                 {
                                     [weakSelf handleloadUpdateUserInfoResult:resultDic];
                                 }
                                 else
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
    
    [ShareManager shareInstance].userinfo.payment_id = _accountText.text;
    [ShareManager shareInstance].userinfo.payment_name = _nameText.text;
    
    [Tool saveUserInfoToDB:YES];
    
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}



@end
