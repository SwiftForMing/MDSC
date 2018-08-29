//
//  EditAddressViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/20.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "EditAddressViewController.h"
#import "ReciverAddressViewController.h"

@interface EditAddressViewController ()

@end

@implementation EditAddressViewController

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
    self.title = @"修改地址";
    
    _nameText.text =  _orderInfo.consignee_name;
    _phoneText.text = _orderInfo.consignee_tel;
    _detailTextView.text = _orderInfo.consignee_address;
    
    _sureButton.layer.masksToBounds =YES;
    _sureButton.layer.cornerRadius = 4;
    
    _messageView.layer.masksToBounds =YES;
    _messageView.layer.cornerRadius = 6;
    
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)clickGoButtonAction:(id)sender
{
    ReciverAddressViewController *vc = [[ReciverAddressViewController alloc]initWithNibName:@"ReciverAddressViewController" bundle:nil];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickSureButtonAction:(id)sender
{
    [Tool hideAllKeyboard];
    
    if (_nameText.text.length < 1) {
        [Tool showPromptContent:@"请输入联系人姓名" onView:self.view];
        return;
    }
    
    if ( _phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号" onView:self.view];
        return;
    }
    
    if(![Tool validateMobile:_phoneText.text] )
    {
        [Tool showPromptContent:@"请输入正确手机号" onView:self.view];
        return;
    }
    
    if (_detailTextView.text.length < 1) {
        [Tool showPromptContent:@"请输入详细地址" onView:self.view];
        return;
    }
    
    [self httpChangeOrderAddress];
}

#pragma mark - http

- (void)httpChangeOrderAddress
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中...";
//    HttpHelper *helper = [HttpHelper helper];
    __weak EditAddressViewController *weakSelf = self;
    [HttpHelper changeOrderAddressWithOrderId:_orderInfo.order_id
                           consignee_name:_nameText.text
                            consignee_tel:_phoneText.text
                        consignee_address:_detailTextView.text
                               order_type:self.oeder_type
                                  success:^(NSDictionary *resultDic){
                                      [HUD hide:YES];
                                      if ([[resultDic objectForKey:@"status"] integerValue] == 0)
                                      {
                                          [weakSelf handleloadResult:[resultDic objectForKey:@"data"]];
                                      }else{
                                          [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                      }

                                  }fail:^(NSString *decretion){
                                      [HUD hide:YES];
                                      [Tool showPromptContent:@"网络出错了" onView:self.view];
                                  }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    
    _orderInfo.consignee_name = _nameText.text;
    _orderInfo.consignee_tel = _phoneText.text;
    _orderInfo.consignee_address = _detailTextView.text;
    
    if([self.delegate respondsToSelector:@selector(editAddressSuccess)])
    {
        [self.delegate editAddressSuccess];
    }
    [Tool showPromptContent:@"提交成功" onView:self.view];
    [self performSelector:@selector(clickLeftItemAction:) withObject:nil afterDelay:1.5];
}


@end
