//
//  ReciverAddressViewController.m
//  YiDaMerchant
//
//  Created by linqsh on 15/9/27.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "ReciverAddressViewController.h"
#import "ReciverAddressListTableViewCell.h"
#import "AddReciverViewController.h"
#import "ProvinceInfo.h"

@interface ReciverAddressViewController ()<AddReciverViewControllerDelegate>
{
    NSMutableArray *dataSoureArray;
    NSInteger selectIndex;
    NSInteger deleteIndex;
    NSMutableArray *proviceArray;
}

@end

@implementation ReciverAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
    [self leftNavigationItem];
    [self rightItemView];
    [self setTabelViewRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable
{
    self.title = @"地址管理";
    dataSoureArray = [NSMutableArray array];
    proviceArray = [NSMutableArray array];
    selectIndex = -1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}


- (void)rightItemView
{
    UIView *rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, 40, 40)];
    rightItemView.backgroundColor = [UIColor clearColor];
    
    UIButton *btnRightItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 2, 40, rightItemView.frame.size.height)];
//    [btnRightItem setImage:PublicImage(@"icon_96") forState:UIControlStateNormal];
//    [btnRightItem setImage:PublicImage(@"icon_96") forState:UIControlStateHighlighted];
    [btnRightItem setTitle:@"添加" forState:UIControlStateNormal];
    btnRightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRightItem setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 15)];
    [btnRightItem addTarget:self action:@selector(clickRightItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnRightItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

#pragma mark - Http

- (void)httpAddressList
{
   
    __weak ReciverAddressViewController *weakSelf = self;
    [HttpHelper receiveAddressListWithUserId:[ShareManager shareInstance].userinfo.id
                                    success:^(NSDictionary *resultDic){
                                        [self hideRefresh];
                                        if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                            [weakSelf handleloadAddAddressResult:resultDic];
                                        }else
                                        {
                                            [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                        }
                                    }fail:^(NSString *decretion){
                                        [self hideRefresh];
                                        [Tool showPromptContent:@"网络出错了" onView:self.view];
                                    }];
}

- (void)handleloadAddAddressResult:(NSDictionary *)resultDic
{
    
    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"addressList"];
    if (resourceArray && resourceArray.count > 0)
    {
    
        if (dataSoureArray.count > 0) {
            [dataSoureArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray)
        {
            RecoverAddressListInfo *info = [dic objectByClass:[RecoverAddressListInfo class]];
            [dataSoureArray addObject:info];
        }
    }else{
        [dataSoureArray removeAllObjects];
        [Tool showPromptContent:@"暂无数据" onView:self.view];
    }
    [_myTableView reloadData];
    
    NSArray *resourceArray1 = [[resultDic objectForKey:@"data"] objectForKey:@"provinceList"];
    if (resourceArray1 && resourceArray1.count > 0)
    {
        
        if (proviceArray.count > 0) {
            [proviceArray removeAllObjects];
        }
        for (NSDictionary *dic in resourceArray1)
        {
            ProvinceInfo *info = [dic objectByClass:[ProvinceInfo class]];
            [proviceArray addObject:info];
        }
    }
    
    
    
}

- (void)httpDeleteAddress:(NSString *)addressId
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"删除中...";

    __weak ReciverAddressViewController *weakSelf = self;
    [HttpHelper deleteAddressWithAddressId:addressId
                               success:^(NSDictionary *resultDic){
                                   [HUD hide:YES];
                                   if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                       [weakSelf handleloadDeleteAddressResult:resultDic];
                                   }else
                                   {
                                       [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                   }
                               }fail:^(NSString *decretion){
                                   [HUD hide:YES];
                                   [Tool showPromptContent:@"网络出错了" onView:self.view];
                               }];
    
}

- (void)handleloadDeleteAddressResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"删除成功" onView:self.view];
    [_myTableView.mj_header beginRefreshing];
}



- (void)httpModifyAddressInfo:(NSInteger)index
{
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"提交中...";
    
    RecoverAddressListInfo *info = [dataSoureArray objectAtIndexedSubscript:index];
    
    __weak ReciverAddressViewController *weakSelf = self;
    [HttpHelper changeDefaultAddressWithUserId:[ShareManager shareInstance].userinfo.id
                                 addressId:info.id
                                   success:^(NSDictionary *resultDic){
                                       [HUD hide:YES];
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           [weakSelf handleloadModifyAddressInfoResult:resultDic];
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                   }fail:^(NSString *decretion){
                                       [HUD hide:YES];
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
}


- (void)handleloadModifyAddressInfoResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"设置成功" onView:self.view];
    [Tool httpAddressList];
     [_myTableView.mj_header beginRefreshing];
}



#pragma mark - Action

- (void)clickLeftControlAction:(id)sender{
    
    if (_isSelectAddress) {
        for (RecoverAddressListInfo *info in dataSoureArray) {
            if ([info.is_default isEqualToString:@"y"]) {
                
                if([self.delegate respondsToSelector:@selector(selectAddressWithInfo:)])
                {
                    [self.delegate selectAddressWithInfo:info];
                }
                break;
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemButtonAction:(id)sender{
    
    AddReciverViewController *vc = [[AddReciverViewController alloc]initWithNibName:@"AddReciverViewController" bundle:nil];
    vc.delegate = self;
    vc.proviceArray = proviceArray;
    vc.title = @"添加收货地址";
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickDeleteButtonAction:(UIButton*)btn
{
    deleteIndex = btn.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除" message:@"确认删除该地址？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
    
}

- (void)clickEditAddressButton:(UIButton*)btn
{
    RecoverAddressListInfo *info = [dataSoureArray objectAtIndex:btn.tag];
    AddReciverViewController *vc = [[AddReciverViewController alloc]initWithNibName:@"AddReciverViewController" bundle:nil];
    vc.delegate = self;
    vc.addressInfo = info;
    vc.proviceArray = proviceArray;
    vc.title = @"修改地址";
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickSetAddressButton:(UIButton*)btn
{
    [self httpModifyAddressInfo:btn.tag];

    if (_isSelectAddress) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        ReciverAddressListTableViewCell *cell = (ReciverAddressListTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath];
        [cell.setAddressButton setImage:[UIImage imageNamed:@"icon_301"] forState:UIControlStateNormal];
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForItem:0 inSection:btn.tag];
        ReciverAddressListTableViewCell *cell1 = (ReciverAddressListTableViewCell *)[_myTableView cellForRowAtIndexPath:indexPath1];
        [cell1.setAddressButton setImage:[UIImage imageNamed:@"icon_251"] forState:UIControlStateNormal];
        
        RecoverAddressListInfo *info = [dataSoureArray objectAtIndexedSubscript:btn.tag];
        if([self.delegate respondsToSelector:@selector(selectAddressWithInfo:)])
        {
            [self.delegate selectAddressWithInfo:info];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        RecoverAddressListInfo *info = [dataSoureArray objectAtIndex:deleteIndex];
        [self httpDeleteAddress:info.id];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSoureArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    return 5;
}

//设置cell的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只创建一个cell用作测量高度
    static ReciverAddressListTableViewCell *cell = nil;
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReciverAddressListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    [self loadAddressCellContent:cell indexPath:indexPath];
    return [self getCellHeight:cell];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReciverAddressListTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ReciverAddressListTableViewCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReciverAddressListTableViewCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.bgView.layer.masksToBounds =YES;
    cell.bgView.layer.cornerRadius = 5;
    
    cell.deleButton.tag = indexPath.section;
    [cell.deleButton addTarget:self action:@selector(clickDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.editButton.tag = indexPath.section;
    [cell.editButton addTarget:self action:@selector(clickEditAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.setAddressButton.tag = indexPath.section;
    [cell.setAddressButton addTarget:self action:@selector(clickSetAddressButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadAddressCellContent:cell indexPath:indexPath];
   
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(FullScreen.size.width - 62, CGFLOAT_MAX);
    CGSize newSize = [cell.addressLabel sizeThatFits:maxSize];
    NSLog(@"hight = %f",newSize.height);
    
    if(newSize.height > 25)
    {
        cell.addressLabelHeight.constant = newSize.height;
    }else{
        cell.addressLabelHeight.constant = 25;
    }

    
    //设点点击选择的颜色(无)
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)loadAddressCellContent:(ReciverAddressListTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {

    RecoverAddressListInfo *info = [dataSoureArray objectAtIndexedSubscript:indexPath.section];
    cell.nameLabel.text = info.user_name;
    cell.phoneLabel.text = info.user_tel;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",info.province_name,info.city_name,info.detail_address];
    
    if (_isSelectAddress) {
        [cell.setAddressButton setTitle:@"使用该地址" forState:UIControlStateNormal];
        if ([info.is_default isEqualToString:@"y"]) {
            [cell.setAddressButton setImage:[UIImage imageNamed:@"icon_251"] forState:UIControlStateNormal];
        }else{
            [cell.setAddressButton setImage:[UIImage imageNamed:@"icon_301"] forState:UIControlStateNormal];
        }
    }else{
        if ([info.is_default isEqualToString:@"y"]) {
            [cell.setAddressButton setTitle:@"默认地址" forState:UIControlStateNormal];
            [cell.setAddressButton setImage:[UIImage imageNamed:@"icon_251"] forState:UIControlStateNormal];
        }else{
            [cell.setAddressButton setImage:[UIImage imageNamed:@"icon_301"] forState:UIControlStateNormal];
            [cell.setAddressButton setTitle:@"设为默认" forState:UIControlStateNormal];
        }
    
    }
}

- (CGFloat)getCellHeight:(ReciverAddressListTableViewCell*)cell
{
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(FullScreen.size.width - 62, CGFLOAT_MAX);
    CGSize newSize = [cell.addressLabel sizeThatFits:maxSize];
    NSLog(@"hight = %f",newSize.height);
    
    float hegiht = 0;
    if(newSize.height > 25)
    {
        hegiht = newSize.height;
    }else{
        hegiht = 25;
    }
    return 155+hegiht;
}

#pragma mark - tableview 上下拉刷新

- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.myTableView;
    __weak __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf httpAddressList];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    
}

- (void)hideRefresh
{
    
    if([_myTableView.mj_footer isRefreshing])
    {
        [_myTableView.mj_footer endRefreshing];
    }
    if([_myTableView.mj_header isRefreshing])
    {
        [_myTableView.mj_header endRefreshing];
    }
}

#pragma mark -  AddReciverViewControllerDelegate
- (void)addAction
{
    [_myTableView.mj_header beginRefreshing];
}

@end
