//
//  QingDanViewController.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "QingDanViewController.h"
//#import "ShopCartListTableViewCell.h"
#import "GoodsDetailInfoViewController.h"
#import "PayViewController.h"
#import "ShopCartInfo.h"
#import "NoDateWarnView.h"

@interface QingDanViewController ()<UINavigationControllerDelegate,UITextFieldDelegate>
{
    NoDateWarnView *warnView;
    UIButton *btnMoreItem;
    NSMutableArray *dataSourceArray;
    NSMutableArray *selectArray;
    
}

@end


@implementation QingDanViewController
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachableNetworkStatusChange object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccess object:nil];
////    [[NSNotificationCenter defaultCenter] removeObserver:self name:kUpdateShopCartData object:nil];
//}
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self initParameter];
//    if (_isPush) {
//        [self leftNavigationItem];
//    }
//    [self rightItemView];
//    [self setTabelViewRefresh];
//    [self registerNotif];
//    //手势返回
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
//    backItem.title = @"";
//    self.navigationItem.leftBarButtonItem = backItem;
//
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)initParameter
//{
//    self.title = @"购物车";
//
//    dataSourceArray = [NSMutableArray array];
//    selectArray = [NSMutableArray array];
//
//    [_allButton setImage:[UIImage imageNamed:@"cont_noslected"] forState:UIControlStateNormal];
//    [_allButton setImage:[UIImage imageNamed:@"cont_slected"] forState:UIControlStateSelected];
//}
//
//- (void)leftNavigationItem
//{
//    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
//    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
//    back.image = [UIImage imageNamed:@"new_back"];
//    [leftItemControl addSubview:back];
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
//
//}
//
//- (void)rightItemView
//{
//    UIView *rightItemView;
//    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
//    rightItemView.backgroundColor = [UIColor clearColor];
//    btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, rightItemView.frame.size.height)];
//    [btnMoreItem setTitle:@"编辑" forState:UIControlStateNormal];
//    [btnMoreItem setTitle:@"完成" forState:UIControlStateSelected];
//    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,12)];
//    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
//    [rightItemView addSubview:btnMoreItem];
//
//    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
//
//
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                    target:nil
//                                                                                    action:nil];
//    negativeSpacer.width = -15;
//    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
//
//}
//
//- (void)updateDownView
//{
//    if (btnMoreItem.isSelected) {
//        _allButtonWidth.constant = 70;
//        _allButton.hidden = NO;
//        [_sureButton setTitle:@"删除" forState:UIControlStateNormal];
//    }else{
//        _allButtonWidth.constant = 0;
//        _allButton.hidden = YES;
//        [_sureButton setTitle:@"结算" forState:UIControlStateNormal];
//    }
//}
//
//#pragma mark - notif Action
//- (void)registerNotif
//{
//    /**
//     *  监听网络状态变化
//     */
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(checkNetworkStatus:)
//                                                 name:kReachableNetworkStatusChange
//                                               object:nil];
//
//    //登录通知
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(updatShopCarteData)
//                                                name:kLoginSuccess
//                                              object:nil];
//
//    //登录通知
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(updateShopCartsOfSelect)
//                                                name:kUpdateShopCartData
//                                              object:nil];
//}
//
////网络状态捕捉
//- (void)checkNetworkStatus:(NSNotification *)notif
//{
//    NSDictionary *userInfo = [notif userInfo];
//    if(userInfo)
//    {
//        [_myTableView.mj_header beginRefreshing];
//    }
//}
//
//- (void)updatShopCarteData
//{
//
//    [_myTableView.mj_header beginRefreshing];
//}
//
//- (void)updateShopCartsOfSelect
//{
//    [self httpGetShopCartList];
//}
//
//#pragma mark - action
//
//- (void)clickLeftItemAction:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)clickRightItemAction:(id)sender
//{
//    if (btnMoreItem.isSelected) {
//        [selectArray removeAllObjects];
//    }
//    [btnMoreItem setSelected:!btnMoreItem.isSelected];
//
//    [self updateDownView];
//    [_myTableView reloadData];
//}
//
//- (void)clickGoodsPhotoAction:(id)sender
//{
//    if (!btnMoreItem.isSelected) {
//
//        //用tag传值判断
//        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
//        UIImageView *imageView = (UIImageView *)tap.view;
//
//        ShopCartInfo *info = [dataSourceArray objectAtIndex:imageView.tag];
//        GoodsDetailInfoViewController *vc = [[GoodsDetailInfoViewController alloc]initWithNibName:@"GoodsDetailInfoViewController" bundle:nil];
//        vc.goodId = info.goods_fight_id;
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
//    }
//}
//
//- (void)clickSelectButtonAction:(id)sender
//{
//    UIButton *btn = (UIButton *)sender;
//
//    ShopCartInfo *info = [dataSourceArray objectAtIndex:btn.tag];
//
//    if (!btn.isSelected) {
//        [selectArray addObject:info.id];
//    }else{
//        [selectArray removeObject:info.id];
//    }
//
//    [btn setSelected:!btn.isSelected];
//
//    if (selectArray.count == dataSourceArray.count) {
//        [_allButton setSelected:YES];
//    }else{
//        [_allButton setSelected:NO];
//    }
//
//}
//
//- (void)clickAddButtonAction:(UIButton *)btn
//{
//    ShopCartListTableViewCell *cell = objc_getAssociatedObject(btn, "cell");
//    NSInteger numStr = [cell.joinNumText.text integerValue];
//
//    ShopCartInfo *info = [dataSourceArray objectAtIndex:btn.tag];
//
//    NSInteger _canBuyNum = info.need_people - info.now_people;
//
//    if (numStr+1 > _canBuyNum) {
//        return;
//    }
//    else{
//        numStr = numStr+1;
//    }
//    cell.joinNumText.text = [NSString stringWithFormat:@"%ld",(long)numStr];
//
//    info.goods_buy_num = cell.joinNumText.text;
//
//    [self httpUpdateShopCarInfoWithGoodsId:info.id goodsNum:cell.joinNumText.text];
//}
//
//- (void)clickDownButtonAction:(UIButton *)btn
//{
//    ShopCartListTableViewCell *cell = objc_getAssociatedObject(btn, "cell");
//    NSInteger numStr = [cell.joinNumText.text integerValue];
//
//    ShopCartInfo *info = [dataSourceArray objectAtIndex:btn.tag];
//
//    if (numStr - 1 <= 0) {
//        return;
//    }
//    else{
//        numStr = numStr-1;
//    }
//    cell.joinNumText.text = [NSString stringWithFormat:@"%ld",(long)numStr];
//
//    info.goods_buy_num = cell.joinNumText.text;
//
//    [self httpUpdateShopCarInfoWithGoodsId:info.id goodsNum:cell.joinNumText.text];
//}
//
//- (IBAction)clickSureButtonAction:(id)sender
//{
//    if (btnMoreItem.isSelected) {
//
//        if (selectArray.count < 1) {
//            [Tool showPromptContent:@"请选择要删除的物品" onView:self.view];
//            return;
//        }
//
//        NSString *goodsIds = nil;
//        for (NSString *str in  selectArray) {
//            if (!goodsIds) {
//                goodsIds = str;
//            }else{
//                goodsIds = [NSString stringWithFormat:@"%@,%@",goodsIds,str];
//            }
//        }
//        [self httpDeleyeShopCarInfoWithGoodsIds:goodsIds];
//    }else{
//        PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
//        vc.moneyNum = [_moneyLabel.text doubleValue];
//        NSString *goodsIds = nil;
//        for (ShopCartInfo *info in  dataSourceArray) {
//            if (!goodsIds) {
//                goodsIds = info.goods_fight_id;
//            }else{
//                goodsIds = [NSString stringWithFormat:@"%@,%@",goodsIds,info.goods_fight_id];
//            }
//        }
//        vc.goodsIds = goodsIds;
//
//        NSString *buyNum = nil;
//        for (ShopCartInfo *info in  dataSourceArray) {
//            if (!buyNum) {
//                buyNum = info.goods_buy_num;
//            }else{
//                buyNum = [NSString stringWithFormat:@"%@,%@",buyNum,info.goods_buy_num];
//            }
//        }
//        vc.goods_buy_nums = buyNum;
//
//        vc.isShopCart = YES;
//        vc.delegate = self;
//         
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
//    }
//}
//
//
//- (IBAction)clickAllButtonAction:(id)sender
//{
//    UIButton *btn = (UIButton *)sender;
//
//    if (!btn.isSelected) {
//        [selectArray removeAllObjects];
//        for (ShopCartInfo *info in dataSourceArray ) {
//            [selectArray addObject:info.id];
//        }
//    }else{
//        [selectArray removeAllObjects];
//    }
//
//    [btn setSelected:!btn.isSelected];
//
//    [_myTableView reloadData];
//}
//
//#pragma mark - http
//
//- (void)httpGetShopCartList
//{
//    HttpHelper *helper = [HttpHelper helper];
//    __weak QingDanViewController *weakSelf = self;
//    [helper getShopCartListWithUserId:[ShareManager shareInstance].userinfo.id
//                              success:^(NSDictionary *resultDic){
//                                  [self hideRefresh];
//                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
//                                      [weakSelf handleloadResult:resultDic];
//                                  }else
//                                  {
//                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                  }
//                              }fail:^(NSString *decretion){
//                                  [self hideRefresh];
//                                  [Tool showPromptContent:decretion onView:self.view];
//                              }];
//}
//
//- (void)handleloadResult:(NSDictionary *)resultDic
//{
//    if (dataSourceArray.count > 0) {
//        [dataSourceArray removeAllObjects];
//
//    }
//
//    NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"shopCartList"];
//    if (resourceArray && resourceArray.count > 0 )
//    {
//        if (warnView && [warnView isDescendantOfView:self.view]) {
//            [warnView removeFromSuperview];
//        }
//        for (NSDictionary *dic in resourceArray)
//        {
//            ShopCartInfo *info = [dic objectByClass:[ShopCartInfo class]];
//            [dataSourceArray addObject:info];
//        }
//
//        btnMoreItem.hidden = NO;
//        [_sureButton setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1]];
//        [_sureButton setUserInteractionEnabled:YES];
//
//
//    }else{
//
//        if (!warnView) {
//            warnView = [[NoDateWarnView alloc] initWithFrame:CGRectMake(0, 0, FullScreen.size.width, 150)  title:@"购物车空空如也，赶快去抢购吧!" image:@"icon_318"];
//            warnView.center = CGPointMake(self.view.center.x, self.view.center.y - 60);
//
//        }
//        if (![warnView isDescendantOfView:self.view]) {
//            [self.view addSubview:warnView];
//        }
//
//
//        [btnMoreItem setSelected:NO];
//        btnMoreItem.hidden = YES;
//        [self updateDownView];
//
//        [_sureButton setBackgroundColor:[UIColor lightGrayColor]];
//        [_sureButton setUserInteractionEnabled:NO];
//
//    }
//
//
//    _moneyLabel.text = [NSString stringWithFormat:@"%@",[[resultDic objectForKey:@"data"] objectForKey:@"all_price"]];
//    CGSize size = [_moneyLabel sizeThatFits:CGSizeMake(MAXFLOAT, 21)];
//    _moneyLabelWidth.constant = size.width;
//    [_myTableView reloadData];
//}
//
//- (void)httpUpdateShopCarInfoWithGoodsId:(NSString *)goodsId goodsNum:(NSString *)goodsNum
//{
//    HttpHelper *helper = [HttpHelper helper];
//    __weak QingDanViewController *weakSelf = self;
//    [helper changeShopCartListInfoWithGoodsId:goodsId
//                                     goodsNum:goodsNum
//                                      success:^(NSDictionary *resultDic){
//                                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
//                                              [weakSelf handleloadUpdateResult:resultDic];
//                                          }else
//                                          {
//                                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                          }
//                                      }fail:^(NSString *decretion){
//                                          [Tool showPromptContent:decretion onView:self.view];
//                                      }];
//}
//
//- (void)handleloadUpdateResult:(NSDictionary *)resultDic
//{
//    [self httpGetShopCartList];
//}
//
//
//- (void)httpDeleyeShopCarInfoWithGoodsIds:(NSString *)goodsIds
//{
//    MBProgressHUD * HUD = nil;
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"删除中...";
//    HttpHelper *helper = [HttpHelper helper];
//    __weak QingDanViewController *weakSelf = self;
//    [helper deleteShopCartListInfoWithGoodsId:goodsIds
//                                      success:^(NSDictionary *resultDic){
//                                          [HUD hide:YES];
//                                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
//                                              [weakSelf handleloadDeleteResult:resultDic];
//                                          }else
//                                          {
//                                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
//                                          }
//                                      }fail:^(NSString *decretion){
//                                          [HUD hide:YES];
//                                          [Tool showPromptContent:decretion onView:self.view];
//                                      }];
//}
//
//- (void)handleloadDeleteResult:(NSDictionary *)resultDic
//{
//    [Tool showPromptContent:@"删除成功" onView:self.view];
//    [selectArray removeAllObjects];
//    [self.myTableView.mj_header beginRefreshing];
//}
//
//#pragma mark - UITableViewDelegate
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
////行数
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return dataSourceArray.count;
//
//}
//
////设置cell的行高
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 112;
//}
//
////创建并显示每行的内容
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ShopCartListTableViewCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartListTableViewCell"];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopCartListTableViewCell" owner:nil options:nil];
//        cell = [nib objectAtIndex:0];
//        cell.joinNumText.delegate = self;
//        [cell.selectButton setImage:[UIImage imageNamed:@"cont_noslected"] forState:UIControlStateNormal];
//        [cell.selectButton setImage:[UIImage imageNamed:@"cont_slected"] forState:UIControlStateSelected];
//    }
//    //设点点击选择的颜色(无)
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    cell.joinNumText.layer.borderColor = [[UIColor colorWithRed:235.0/255.0 green:82.0/255.0 blue:83.0/255.0 alpha:1] CGColor];
//    cell.joinNumText.layer.borderWidth = 1.0f;
//
//    cell.photoImage.userInteractionEnabled = YES;
//    cell.photoImage.tag = indexPath.row;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGoodsPhotoAction:)];
//    [cell.photoImage addGestureRecognizer:tap];
//
//
//    ShopCartInfo *info = [dataSourceArray objectAtIndex:indexPath.row];
//
//    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:info.good_header] placeholderImage:PublicImage(@"defaultImage")];
//    cell.titleLabel.text = info.good_name;
//    cell.allLabel.text = [NSString stringWithFormat:@"总需 %ld人次",(long)info.need_people];
//    CGSize size = [cell.allLabel sizeThatFits:CGSizeMake(MAXFLOAT, 16)];
//    cell.allLabelWidth.constant = size.width;
//    cell.needLabel.text = [NSString stringWithFormat:@"剩余 %d人次",(int)(info.need_people - info.now_people)];
//
//
//    cell.joinNumText.tag = indexPath.row;
//    cell.joinNumText.text = info.goods_buy_num;
//
//    if (btnMoreItem.isSelected) {
//        cell.selectButton.hidden = NO;
//        cell.selectButtonWidth.constant = 40;
//
//        cell.selectButton.tag = indexPath.row;
//        [cell.selectButton addTarget:self action:@selector(clickSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//
//        [cell.selectButton setSelected:NO];
//        for (NSString *idstr in selectArray) {
//            if ([idstr isEqualToString:info.id]) {
//                [cell.selectButton setSelected:YES];
//                break;
//            }
//        }
//
//    }else{
//        cell.selectButton.hidden = YES;
//        cell.selectButtonWidth.constant = 8;
//
//    }
//
//    cell.addButton.tag = indexPath.row;
//    [cell.addButton addTarget:self action:@selector(clickAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.addButton.tag = indexPath.row;
//    objc_setAssociatedObject(cell.addButton, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
//
//    cell.downButton.tag = indexPath.row;
//    [cell.downButton addTarget:self action:@selector(clickDownButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    cell.downButton.tag = indexPath.row;
//    objc_setAssociatedObject(cell.downButton, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
//
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//
//}
//
//#pragma mark - 上下刷新
//- (void)setTabelViewRefresh
//{
//    __unsafe_unretained UITableView *tableView = self.myTableView;
//    __unsafe_unretained __typeof(self) weakSelf = self;
//    // 下拉刷新
//    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf httpGetShopCartList];
//    }];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    tableView.mj_header.automaticallyChangeAlpha = YES;
//    [tableView.mj_header beginRefreshing];
//}
//
//- (void)hideRefresh
//{
//    if([_myTableView.mj_header isRefreshing])
//    {
//        [_myTableView.mj_header endRefreshing];
//    }
//}
//
//
//
//#pragma mark - PayViewControllerDelegate
//
//- (void)payForBuyGoodsSuccess
//{
//    [self httpGetShopCartList];
//}
//
//#pragma mark - UITextFieldDelegate
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    ShopCartInfo *info = [dataSourceArray objectAtIndex:textField.tag];
//
//    NSInteger _canBuyNum = info.need_people - info.now_people;
//
//    if ([textField.text intValue] > _canBuyNum) {
//        [textField resignFirstResponder];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的数量已经超过最大可购买数量，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alert.tag = textField.tag;
//        [alert show];
//
//    }else{
//        if ([textField.text intValue] <= 0 )
//        {
//            textField.text = @"1";
//        }
//
//        [self httpUpdateShopCarInfoWithGoodsId:info.id goodsNum:textField.text];
//    }
//
//}
//
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    NSIndexPath *index = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
//
//    ShopCartListTableViewCell *cell = [_myTableView cellForRowAtIndexPath:index];
//
//    [cell.joinNumText becomeFirstResponder];
//}


@end
