//
//  UserInfoViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/19.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoHeadTableViewCell.h"
#import "UesrInfoListTableViewCell.h"
#import "ReciverAddressViewController.h"
#import "ModifyDetailInfoViewController.h"
#import "ALiPayBangViewController.h"
#import "UserLevelDetailViewController.h"
#import "JSONKit.h"

@interface UserInfoViewController ()<ModifyDetailInfoViewControllerDelegate>

@end

@implementation UserInfoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    bgImage.image = [UIImage imageNamed:@"nav"];
//    self.myTableView.backgroundView = bgImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"个人资料";
   
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


- (void)clickUpdateHeadImage:(id)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    UserInfoHeadTableViewCell *cell = [_myTableView cellForRowAtIndexPath:index];
    [[ShareManager shareInstance] selectPictureFromDevice:self isReduce:YES isSelect:YES isEdit:YES block:^(UIImage * image,NSString* imageName){
        cell.codeImage.image = image;
        [self httpUpdateImage:image];
    }];
}


#pragma mark -http

- (void)httpUpdateImage:(UIImage*)image
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"数据提交中...";
    
    __weak UserInfoViewController *weakSelf = self;
    [HttpHelper postImageHttpWithImage:image
                           success:^(NSDictionary *dict){
                               
                               [HUD hide:YES];
                               if ([[dict objectForKey:@"status"] integerValue] == 0) {
                                   [weakSelf handleloadPostImageResult:dict];
                               }else
                               {
                                   [Tool showPromptContent:[dict objectForKey:@"desc"] onView:self.view];
                               }
                               
                           }fail:^(NSString *decretion){
                               [HUD hide:YES];
                               [Tool showPromptContent:@"网络出错了" onView:self.view];
                           }];
    
}

- (void)handleloadPostImageResult:(NSDictionary *)resultDic
{
    NSString *imageUrlStr = [resultDic objectForKey:@"data"];
    [self UpdateUserInfoWithHeadImage:imageUrlStr];
}

- (void)UpdateUserInfoWithHeadImage:(NSString *)imageUrlStr
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"数据提交中...";
    
    __weak UserInfoViewController *weakSelf = self;
    [HttpHelper changeUserInfoWithUserId:[ShareManager shareInstance].userinfo.id
                           fieldName:@"user_header"
                      fieldNameValue:imageUrlStr
                  updateFieldNameNum:@"1"
                             success:^(NSDictionary *resultDic){
                                 [HUD hide:YES];
                                 if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     [weakSelf handleloadResult:resultDic];
                                 }else
                                 {
                                     [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                 }
                                 
                             }fail:^(NSString *decretion){
                                 [HUD hide:YES];
                                 [Tool showPromptContent:@"网络出错了" onView:self.view];
                             }];
    
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"修改成功" onView:self.view];
    [Tool getUserInfo];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 5;
    }
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 145;
    }else{
        return 45;
    }
    
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UserInfoHeadTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoHeadTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserInfoHeadTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        cell.shareButton.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
        cell.shareButton.layer.borderWidth = 1.0f;
        cell.shareButton.layer.masksToBounds =YES;
        cell.shareButton.layer.cornerRadius = 5;
        
        cell.codeImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        cell.codeImage.layer.borderWidth = 4;
        
        cell.codeImage.layer.masksToBounds =YES;
        cell.codeImage.layer.cornerRadius = cell.codeImage.frame.size.height/2;
        [cell.shareButton addTarget:self action:@selector(clickUpdateHeadImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.codeImage sd_setImageWithURL:[NSURL URLWithString:[ShareManager shareInstance].userinfo.user_header] placeholderImage:PublicImage(@"default_head")];
//        cell.backgroundColor = [UIColor clearColor];
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UesrInfoListTableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"UesrInfoListTableViewCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UesrInfoListTableViewCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        
        cell.detailLabel.text = @"";
        cell.rightImage.hidden = NO;
        cell.lineLabel.hidden = NO;
        //设点点击选择的颜色(无)
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell.detailLabel.textColor  = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
        cell.rightImageWidth.constant = 14;
        
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"ID";
                cell.detailLabel.text = [ShareManager shareInstance].userinfo.id;
                cell.rightImage.hidden = YES;
                cell.detailLabel.textColor = [UIColor lightGrayColor];
                //设点点击选择的颜色(无)
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.rightImageWidth.constant = 0;
            }
                break;
            case 1:
            {
                cell.titleLabel.text = @"手机号码";
                cell.detailLabel.text = [ShareManager shareInstance].userinfo.user_tel;
                cell.rightImage.hidden = YES;
                cell.detailLabel.textColor = [UIColor lightGrayColor];
                cell.rightImageWidth.constant = 0;
            }
                break;
            case 2:
            {
                
                cell.titleLabel.text = @"昵称";
                if ([[ShareManager shareInstance].userinfo hasAlias] == NO) {
                    cell.detailLabel.text = @"未设置";
                    cell.detailLabel.textColor = [UIColor lightGrayColor];
                }else{
                    cell.detailLabel.text = [ShareManager shareInstance].userinfo.nick_name;
                    cell.detailLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1];
                }
                
            }
                break;
//            case 3:
//            {
//                
//                cell.titleLabel.text = @"我的等级";
//                cell.detailLabel.text = [ShareManager shareInstance].userinfo.level_name;
//                
//            }
//                break;
            case 3:
            {
                cell.titleLabel.text = @"地址管理";
                cell.detailLabel.text = @"";
            }
                break;
            case 4:
            {
                cell.titleLabel.text = @"绑定支付宝";
                cell.detailLabel.text = @"";
                cell.lineLabel.hidden = YES;
            }
                break;
            default:
                break;
        }
        
        return cell;

    }
    
    return nil;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (indexPath.section  == 0) {
        return;
    }
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            ModifyDetailInfoViewController *vc = [[ModifyDetailInfoViewController alloc]initWithNibName:@"ModifyDetailInfoViewController" bundle:nil];
            vc.delegate = self;
            if ([[ShareManager shareInstance].userinfo.nick_name isEqualToString:@"<null>"]) {
                vc.contentStr = @"";
            }else{
                vc.contentStr = [ShareManager shareInstance].userinfo.nick_name;
            }
            
//             
    [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 3:
//        {
//            UserLevelDetailViewController *vc = [[UserLevelDetailViewController alloc]initWithNibName:@"UserLevelDetailViewController" bundle:nil];
//             
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
//        }
//            break;
        case 3:
        {
            ReciverAddressViewController *vc = [[ReciverAddressViewController alloc]initWithNibName:@"ReciverAddressViewController" bundle:nil];
//             
    [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            ALiPayBangViewController *vc = [[ALiPayBangViewController alloc]initWithNibName:@"ALiPayBangViewController" bundle:nil];
//             
    [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return  50;
    }else{
        return 0.001;
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *footer = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, ScreenHeight))];
        UILabel *quitLabel = [[UILabel alloc]initWithFrame:(CGRectMake(50, 10,ScreenWidth-100,40))];
        quitLabel.text = @"退出登录";
        quitLabel.textAlignment = NSTextAlignmentCenter;
        quitLabel.textColor = [UIColor whiteColor];
        quitLabel.font = [UIFont systemFontOfSize:14];
        quitLabel.layer.masksToBounds = YES;
        quitLabel.layer.cornerRadius = 5;
        quitLabel.backgroundColor = [UIColor colorFromHexString:@"5ad485"];
        [quitLabel whenTapped:^{
            [ShareManager shareInstance].userinfo = nil;
            [Tool loginWithAnimated:YES viewController:nil];
        }];
        [footer addSubview:quitLabel];
        return footer;
    }else{
        return  nil;
    }
    
}

#pragma mark -ModifyDetailInfoViewControllerDelegate

- (void)modiftyUserInfoSuccesss
{
    [_myTableView reloadData];
}
@end
