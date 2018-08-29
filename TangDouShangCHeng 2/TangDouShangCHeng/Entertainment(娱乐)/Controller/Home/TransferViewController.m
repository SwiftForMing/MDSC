//
//  TransferViewController.m
//  DuoBao
//
//  Created by 黎应明 on 2017/7/25.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "TransferViewController.h"

@interface TransferViewController (){
    
    NSString *num;
    NSString *iphone;
}

@property (weak, nonatomic) IBOutlet UILabel *IdLabel;
@end

@implementation TransferViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转让商品";
    num = @"";
    iphone = @"";
    NSString *defalutsId = [[NSUserDefaults standardUserDefaults] valueForKey:@"defaultsUserId"];
//    MLog(@"defalutsId%@",defalutsId);
    if (defalutsId != nil) {
        self.numTextView.text = defalutsId;
         [self getUserId];
    }
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];

}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doCommitClick:(id)sender {
    
    
    if (_goodInfo == nil&&self.order_type==nil){
        
        return;
    }
    //点击提交然后发送数据，发送数据成功后自动返回上一个页面，然后隐藏上一个页面的转让按钮
    
    NSString *order_id = @"";
    if (_goodInfo) {
        order_id = _goodInfo.order_id;
    }else{
        order_id = _orders_id;
    }
//    UITextView
    [HttpHelper sendRecordWithUserid:[ShareManager shareInstance].userinfo.id order_id:order_id order_type:self.order_type receive_tel:self.numTextView.text success:^(NSDictionary *resultDic) {

        if ([resultDic[@"status"] isEqualToString:@"0"]) {
            [Tool showPromptContent:@"转让成功" onView:self.view];
            
            NSString *defalutsId = [[NSUserDefaults standardUserDefaults] valueForKey:@"defaultsUserId"];
            
            if(defalutsId != self.numTextView.text||defalutsId==nil){
                MLog(@"defalutsId???????");
                [[NSUserDefaults standardUserDefaults] setValue:self.numTextView.text forKey:@"defaultsUserId"];
               
            }
            
            self->_goodInfo.get_type = @"转赠";
            self->_goodInfo.order_status = @"待发货";
            self->_goodInfo.consignee_tel = self->_numTextView.text;
            
            [self.delegate sendInfo:self->_goodInfo];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [Tool showPromptContent:@"转让失败" onView:self.view];
        }
    } fail:^(NSString *description) {
       
         [Tool showPromptContent:description onView:self.view];
    }];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    textView.text = @"";
    return  YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
     textView.textColor = [UIColor blackColor];
    
    MLog(@"%@",textView.text);
    if (textView.text.length == ShareManager.shareInstance.userinfo.id.length) {
        [self getUserId];
        //将在这里通过电话号码获取用户信息。 获取成功之后才能点击提交操作，否则提示用户
    }
    
}



-(void)getUserId{
    
    __weak TransferViewController *weakSelf = self;
    [HttpHelper getUserInfoWithTell:_numTextView.text
                            success:^(NSDictionary *resultDic) {
                                MLog(@"resultDic%@",resultDic);
                                if ([resultDic[@"status"] isEqualToString:@"0"]) {
                                    NSDictionary *data = resultDic[@"data"];
                                    [weakSelf handleloadUserInfoResult:data];
                                    
                                }else{
                                     [Tool showPromptContent:@"获取用户信息失败" onView:self.view];
                                }
    
                            } fail:^(NSString *description) {
                                [Tool showPromptContent:@"获取用户信息失败" onView:self.view];
                            }];
    
    
}

- (void)handleloadUserInfoResult:(NSDictionary *)resultDic
{
    NSDictionary *dic = resultDic[@"receiveUser"];
    _IdLabel.text = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
    _goodInfo.consignee_name = [NSString stringWithFormat:@"%@",dic[@"nick_name"]];
    MLog(@"dic%@",dic);
   
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
    }
    if ([textView.text length]==[[ShareManager shareInstance].userinfo.id length]) {
        num = textView.text;
    }
    if ([textView.text length]>[[ShareManager shareInstance].userinfo.id length]) {
        textView.text = num;

    }
    return YES;
}
@end
