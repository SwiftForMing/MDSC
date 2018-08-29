//
//  AddAddressViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/12.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "AddAddressViewController.h"
#import "EditAddressCell.h"
#import "AddReciverViewController.h"
#import "ReciverAddressViewController.h"
@interface AddAddressViewController ()

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    
    [self setRightBarButtonItem:@"添加"];
    self.tableView.backgroundColor =  [[UIColor alloc]initWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
}
#pragma mark - 实现rightBar点击方法
- (void)rightBarButtonItemAction:(id)sender
{
    MLog(@"放开我死胖子，我要去添加地址");
    ReciverAddressViewController *vc = [[ReciverAddressViewController alloc]init];
//     
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    EditAddressCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"EditAddressCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditAddressCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.changeBtn.hidden = NO;

    return cell;
        }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

@end
