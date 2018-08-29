//
//  SelectCouponsViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/23.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SelectCouponsViewController.h"
#import "SelectCouponsListTableViewCell.h"
#import "CouponsListInfo.h"

@interface SelectCouponsViewController ()

@end

@implementation SelectCouponsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.myTableView reloadData];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Button Action


- (IBAction)clickClearButtonAction:(id)sender
{
    _couponsId = nil;
    [_myTableView reloadData];
    
    if([self.delegate respondsToSelector:@selector(selectCouponsWithID:couponsName:value:)])
    {
        [self.delegate selectCouponsWithID:nil couponsName:nil value:0];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)clickSureButtonAction:(id)sender
{
    if (!_couponsId) {
        [self clickClearButtonAction:nil];
        return;
    }
    
    NSString *name = nil;
    CouponsListInfo *selectedCoupon = nil;
    double ticketsValue = 0;
    for (CouponsListInfo *info in _dataSourceArray) {
        if ([_couponsId isEqualToString:info.id]) {
            name = [NSString stringWithFormat:@"%@(满%.1f减%.1f元)",info.ticket_name,info.ticket_condition,info.ticket_value];
            ticketsValue = info.ticket_value;
            selectedCoupon = info;
            break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(selectCouponsWithID:couponsName: value:)])
    {
        [self.delegate selectCouponsWithID:_couponsId couponsName:name value:ticketsValue];
    }
    
    
    if([self.delegate respondsToSelector:@selector(didSelectCoupon:)])
    {
        [self.delegate didSelectCoupon:selectedCoupon];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
    
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//创建并显示每行的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectCouponsListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCouponsListTableViewCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectCouponsListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CouponsListInfo *info = [_dataSourceArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@(满%.1f减%.1f元)",info.ticket_name,info.ticket_condition,info.ticket_value];
    
    if ([_couponsId isEqualToString:info.id]) {
        cell.statueImage.image = [UIImage imageNamed:@"cont_slected.png"];
    }else{
        cell.statueImage.image = [UIImage imageNamed:@"cont_noslected.png"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     CouponsListInfo *info = [_dataSourceArray objectAtIndex:indexPath.row];
    _couponsId = info.id;
    [_myTableView reloadData];
}

@end
