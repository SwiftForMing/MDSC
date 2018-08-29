//
//  AddReciverViewController.m
//  YiDaMerchant
//
//  Created by linqsh on 15/10/3.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "AddReciverViewController.h"
#import "RefundReasonViewController.h"
#import "ProvinceInfo.h"

@interface AddReciverViewController ()<RefundReasonViewControllerDelegate>
{
    BOOL _keyboardIsVisible;
    NSString *_cityId;
    NSString *_cityName;
    NSString *_proviceId;
    NSString *_proviceName;
    BOOL isSelectProvice;
    NSMutableArray *cityInfoArray;
}



@end

@implementation AddReciverViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _bgViewWidth.constant = FullScreen.size.width;
    _bgViewHeight.constant = FullScreen.size.height-64;
    
    _unitView.layer.masksToBounds = YES;
    _unitView.layer.cornerRadius = 10;
    
    _addButton.layer.masksToBounds = YES;
    _addButton.layer.cornerRadius = _addButton.frame.size.height/2;
    cityInfoArray = [NSMutableArray array];
    
    if (_addressInfo) {
        
        _cityId = _addressInfo.city_id;
        _cityName = _addressInfo.city_name;
        _proviceId = _addressInfo.province_id;
        _proviceName = _addressInfo.province_name;
        
        _nameText.text = _addressInfo.user_name;
        _phoneText.text = _addressInfo.user_tel;
        [_cityButton setTitle:_addressInfo.city_name forState:UIControlStateNormal];
        [_quButton setTitle:_addressInfo.province_name forState:UIControlStateNormal];
        _detailAddressTextView.text = _addressInfo.detail_address;
        _detailAddressTextView.textColor = [UIColor blackColor];
        
        if([_addressInfo.is_default isEqualToString:@"y"])
        {
            [_switchButton setOn:YES];
        }else{
            [_switchButton setOn:NO];
        }
        [_addButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
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

#pragma mark - Http


- (void)httpAddOrModifyAddress
{
    NSString *status = @"n";
    if (_switchButton.isOn) {
        status = @"y";
    }
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中...";
    
    
    __weak AddReciverViewController *weakSelf = self;
    
    NSString *addressId = _addressInfo.id;
    if ([_addressInfo.id length]==0) {
        addressId = @"NUL";
        MLog(@"AddReciverViewController");
    }
    
    [HttpHelper addAddressWithUserId:[ShareManager shareInstance].userinfo.id
                       addressId:addressId
                        user_tel:_phoneText.text
                       user_name:_nameText.text
                     province_id:_proviceId
                         city_id:_cityId
                  detail_address:_detailAddressTextView.text
                      is_default:status
                         success:^(NSDictionary *resultDic){
                             [HUD hide:YES];
                             if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                 [weakSelf handleloadAddAddressResult:resultDic];
                             }else
                             {
                                 [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                             }
                         }fail:^(NSString *decretion){
                             [HUD hide:YES];
                             [Tool showPromptContent:@"网络出错了" onView:self.view];
                         }];
    
}

- (void)handleloadAddAddressResult:(NSDictionary *)resultDic
{
    if([self.delegate respondsToSelector:@selector(addAction)])
    {
        [self.delegate addAction];
        [Tool httpAddressList];
    }
    [Tool showPromptContent:@"操作成功" onView:self.view];
    [self performSelector:@selector(clickLeftControlAction:) withObject:nil afterDelay:1.5];
}

- (void)httpGetCityInfo:(NSString *)proviceId
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中...";
    
    __weak AddReciverViewController *weakSelf = self;
    [HttpHelper getCityInfoWithProvinceId:proviceId
                              success:^(NSDictionary *resultDic){
                                   [HUD hide:YES];
                                   if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                       [weakSelf handleloadGetCityInfoResult:resultDic];
                                   }else
                                   {
                                       [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                   }
                               }fail:^(NSString *decretion){
                                   [HUD hide:YES];
                                   [Tool showPromptContent:@"网络出错了" onView:self.view];
                               }];
}


- (void)handleloadGetCityInfoResult:(NSDictionary *)resultDic
{
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"cityList"];
    if (resourceArray && resourceArray.count > 0)
    {
        if (cityInfoArray.count > 0) {
            [cityInfoArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            ProvinceInfo *info = [dic objectByClass:[ProvinceInfo class]];
            [cityInfoArray addObject:info];
        }
    }else{
        [cityInfoArray removeAllObjects];
        [Tool showPromptContent:@"暂无城市数据" onView:self.view];
    }
  
}

#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickCityButton:(id)sender
{
    [Tool hideAllKeyboard];
    if (_proviceArray.count < 1) {
        [Tool showPromptContent:@"获取省份信息失败" onView:self.view];
        return;
    }
    isSelectProvice = YES;
    
    RefundReasonViewController *vc = [[RefundReasonViewController alloc]initWithNibName:@"RefundReasonViewController" bundle:nil];
    vc.contentArray = _proviceArray;
    vc.delegate = self;
    self.definesPresentationContext = YES;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];

}

- (IBAction)clickQuButton:(id)sender
{
    
    [Tool hideAllKeyboard];
    if (!_proviceId) {
        [Tool showPromptContent:@"请先选择省份信息" onView:self.view];
        return;
    }
    if (cityInfoArray.count < 1) {
        [Tool showPromptContent:@"获取城市信息失败" onView:self.view];
        return;
    }
    isSelectProvice = NO;
    RefundReasonViewController *vc = [[RefundReasonViewController alloc]initWithNibName:@"RefundReasonViewController" bundle:nil];
    vc.contentArray = cityInfoArray;
    vc.delegate = self;
    self.definesPresentationContext = YES;
    vc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;//半透明全靠这句了
    }
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController presentViewController:vc animated:YES completion:nil];

}

- (IBAction)clickSuccessButton:(id)sender
{
    [Tool hideAllKeyboard];
    if (_nameText.text.length < 1) {
        [Tool showPromptContent:@"请输入联系人" onView:self.view];
        return;
    }
    if (_phoneText.text.length < 1) {
        [Tool showPromptContent:@"请输入手机号码" onView:self.view];
        return;
    }
    if (![Tool validateMobile:_phoneText.text] ) {
        [Tool showPromptContent:@"请输入正确的手机号码" onView:self.view];
        return;
    }
    if (_cityButton.titleLabel.text.length < 1) {
        [Tool showPromptContent:@"请选择所在省份" onView:self.view];
        return;
    }
    if (_quButton.titleLabel.text.length < 1) {
        [Tool showPromptContent:@"请选择所在城市" onView:self.view];
        return;
    }
    if (_detailAddressTextView.text.length < 1 || [_detailAddressTextView.text isEqualToString:@"详细地址(街道门牌号)"]) {
        [Tool showPromptContent:@"详细地址(街道门牌号)" onView:self.view];
        return;
    }
    [Tool hideAllKeyboard];
    
    [self httpAddOrModifyAddress];
   
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"详细地址(街道门牌号)"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <= 0) {
        
        textView.text = @"详细地址(街道门牌号)";
        textView.textColor = [UIColor lightGrayColor];
    }
}


#pragma mark - RefundReasonViewControllerDelegate

- (void)selectOverWithId:(NSString *)typeIs typeName:(NSString *)typeName
{
    if(isSelectProvice)
    {
        [_cityButton setTitle:typeName forState:UIControlStateNormal];
        _proviceId = typeIs;
        _proviceName = typeName;
        [_quButton setTitle:@"" forState:UIControlStateNormal];
        _cityId = nil;
        _cityName = nil;
        [self httpGetCityInfo:typeIs];
        
    }else{
        [_quButton setTitle:typeName forState:UIControlStateNormal];
        _cityId = typeIs;
        _cityName = typeName;
        
    }
    
}
@end
