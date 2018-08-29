//
//  ShoppingCarVC.m
//  ShoppingCarDemo
//
//  Created by huanglianglei on 15/11/5.
//  Copyright © 2015年 huanglianglei. All rights reserved.
//

#import "ShoppingCarVC.h"
#import "UConstants.h"
#import "UIViewExt.h"
#import "ShoppingCarCell.h"
//#import "ShoppingModel.h"
#import "ShopCartInfo.h"
#import "GoodsListInfo.h"
//#import "ShopCarBuySucessViewController.h"
static NSString *kPurchaseFailureInventoryNotEnought = @"库存不足，购买下一期失败，请重新购买";
static NSString *kPurchaseFailureOver = @"该期已结束，包尾购买失败！";
@interface ShoppingCarVC ()<UITableViewDataSource,UITableViewDelegate,ShoppingCarCellDelegate>{
     NSMutableArray *goodsDataSourceArray;
    BOOL kanClick;
    BOOL canClick;
    NSMutableArray *stuatsArray;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *selectAllBtn;//全选按钮

@property (nonatomic,strong) UIButton *jieSuanBtn;//结算按钮
@property (nonatomic,strong) UILabel *totalMoneyLab;//总金额

@property(nonatomic,assign) float allPrice;
@property(nonatomic,copy) NSString *ids;


@end

@implementation ShoppingCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    kanClick = NO;
    canClick = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.dataArray = [[NSMutableArray alloc]init];
    goodsDataSourceArray = [NSMutableArray array];
    stuatsArray = [NSMutableArray array];
    self.allPrice = 0.00;
    self.ids = @"";
    [self createSubViews];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTabelViewRefresh];
    MLog(@"viewWillAppear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = NO;
}


- (void)setTabelViewRefresh
{
    __unsafe_unretained UITableView *tableView = self.tableView;
    __unsafe_unretained __typeof(self) weakSelf = self;
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
     
        [weakSelf httpGetShopCartList];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    [tableView.mj_header beginRefreshing];
    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf httpGetGoodsList];
//
//    }];
    tableView.mj_footer.automaticallyHidden = YES;
}

- (void)hideRefresh
{
    
    if([self.tableView.mj_footer isRefreshing])
    {
        [self.tableView.mj_footer endRefreshing];
    }
    if([self.tableView.mj_header isRefreshing])
    {
        [self.tableView.mj_header endRefreshing];
    }
}
/**
 * 初始化假数据
 */

- (void)httpGetShopCartList
{
    __weak ShoppingCarVC *weakSelf = self;
    [HttpHelper getShopCartListWithUserId:[ShareManager shareInstance].userinfo.id
                              success:^(NSDictionary *resultDic){
                                   [self hideRefresh];
                                  if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                     
                                      [weakSelf handleloadResult:resultDic];
                                  }else
                                  {
                                      [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                  }
                              }fail:^(NSString *decretion){
                                   [self hideRefresh];
                                  [Tool showPromptContent:decretion onView:self.view];
                              }];
}

- (void)handleloadResult:(NSDictionary *)resultDic
{
    MLog(@"handleloadResult%@",resultDic);
    if (_dataArray.count > 0) {
        [_dataArray removeAllObjects];
    }
      NSArray *resourceArray = [[resultDic objectForKey:@"data"] objectForKey:@"shopCartList"];
    
//    if (resourceArray.count != 0) {
//        self.tabBarController.tabBar.items[3].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)resourceArray.count];
//    }else{
//         self.tabBarController.tabBar.items[3].badgeValue = nil;
//    }
    
    if (resourceArray && resourceArray.count > 0 )
    {
        for (NSDictionary *dic in resourceArray)
        {
            ShopCartInfo *info = [dic objectByClass:[ShopCartInfo class]];
            if ([stuatsArray containsObject:info.id]) {
                info.selectState = NO;
            }else{
               info.selectState = YES;
            }
            
            [self.dataArray addObject:info];

        }
        
        if (resourceArray.count < 100) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer resetNoMoreData];
        }
        //        pageNum++;
    }
    //刷新
    
   
    [self.tableView reloadData];
    [self CalculationPrice];
    [self performSelector:@selector(come) withObject:nil afterDelay:0.3];
    
}
-(void)come{
    kanClick = YES;
}

- (void)httpDeleyeShopCarInfoWithGoodsIds:(NSString *)goodsIds
{
    MBProgressHUD * HUD = nil;
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"删除中...";
    
    __weak ShoppingCarVC *weakSelf = self;
    [HttpHelper deleteShopCartListInfoWithGoodsId:goodsIds
                                      success:^(NSDictionary *resultDic){
                                          [HUD hide:YES];
                                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                              MLog(@"resultDic%@",resultDic);
                                              [weakSelf handleloadDeleteResult:resultDic];
                                          }else
                                          {
                                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                          }
                                      }fail:^(NSString *decretion){
                                          [HUD hide:YES];
                                          [Tool showPromptContent:decretion onView:self.view];
                                      }];
}

- (void)handleloadDeleteResult:(NSDictionary *)resultDic
{
    [Tool showPromptContent:@"删除成功" onView:self.view];
    [self httpGetShopCartList];
    
}

- (void)httpUpdateShopCarInfoWithGoodsId:(NSString *)goodsId goodsNum:(NSString *)goodsNum
{
    
    __weak ShoppingCarVC *weakSelf = self;
    [HttpHelper changeShopCartListInfoWithGoodsId:goodsId
                                     goodsNum:goodsNum
                                      success:^(NSDictionary *resultDic){
                                          if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                              [weakSelf handleloadUpdateResult:resultDic];
                                          }else
                                          {
                                              [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                          }
                                      }fail:^(NSString *decretion){
                                          [Tool showPromptContent:decretion onView:self.view];
                                      }];
}

- (void)handleloadUpdateResult:(NSDictionary *)resultDic
{
    [self httpGetShopCartList];
}


-(void)createSubViews{
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0 , kScreenWidth, kScreenHeight-64-50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    CGFloat y = kScreenHeight == 812.0 ? 55:0;
    UIView *payView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-50-48-y, ScreenWidth, 50)];
    payView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:payView];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectAllBtn.frame = CGRectMake(10,15, 60, 20);
    [self.selectAllBtn setImage:[UIImage imageNamed:@"check_n"] forState:UIControlStateNormal];
    [self.selectAllBtn setImage:[UIImage imageNamed:@"check_p"] forState:UIControlStateSelected];
    self.selectAllBtn.selected = YES;
    [self.selectAllBtn addTarget:self action:@selector(selectAllaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectAllBtn.titleLabel.font = SYSTEMFONT(12.0);
    self.selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [payView addSubview:self.selectAllBtn];
    

    
    self.totalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(self.selectAllBtn.right+10, self.selectAllBtn.top, kScreenWidth-self.selectAllBtn.right-30-GetWidth(184),20)];

    self.totalMoneyLab.textAlignment = NSTextAlignmentCenter;
    self.totalMoneyLab.font = SYSTEMFONT(13.0);
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld小米",(long)self.allPrice]];
    [str addAttribute:NSFontAttributeName value:SYSTEMFONT(12) range:NSMakeRange(0,str.length-2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,str.length-2)];
    self.totalMoneyLab.attributedText = str;
    
    
    [payView addSubview:self.totalMoneyLab];
    
    
    self.jieSuanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jieSuanBtn.frame = CGRectMake(kScreenWidth-GetWidth(184)-10,(50-GetHeight(74))/2.0,GetWidth(184), GetHeight(74));
    [self.jieSuanBtn setBackgroundColor:RGBACOLOR(0, 189, 155, 1)];
     [self.jieSuanBtn setBackgroundImage:[UIImage imageNamed:@"nav"] forState:0];
    [self.jieSuanBtn addTarget:self action:@selector(jieSuanAction) forControlEvents:UIControlEventTouchUpInside];
    self.jieSuanBtn.layer.masksToBounds = YES;
    self.jieSuanBtn.layer.cornerRadius = GetHeight(74)/2.0;
    [self.jieSuanBtn setTitle:@"结算" forState:UIControlStateNormal];
    
    [self.jieSuanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.jieSuanBtn.titleLabel.font = SYSTEMFONT(12.0);
    self.jieSuanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [payView addSubview:self.jieSuanBtn];

    
    
}
//结算
-(void)jieSuanAction{
    if (!canClick) {
        canClick = YES;
        [self setTabelViewRefresh];
            if (self.dataArray.count>0&&self.allPrice!=0) {
                NSString *goods = @"";
                NSString *goods_fight_ids = @"";
                NSString *nums = @"";
                for (ShopCartInfo *info in self.dataArray){
                    if (info.selectState) {
                        goods_fight_ids = [NSString stringWithFormat:@"%@%@,",goods_fight_ids,info.goods_fight_id];
                        goods = [NSString stringWithFormat:@"%@%@,",goods,info.goods_id];
                        nums = [NSString stringWithFormat:@"%@%@,",nums,info.goods_buy_num];
                    }
                }
        
                goods = [goods substringWithRange:NSMakeRange(0, goods.length-1)];
                goods_fight_ids = [goods_fight_ids substringWithRange:NSMakeRange(0, goods_fight_ids.length-1)];
                nums = [nums substringWithRange:NSMakeRange(0, nums.length-1)];
        
                MLog(@"selectAllaction%@===%@======%@",goods_fight_ids,goods,nums);
                [self purchaseGoodsFightID:goods_fight_ids count:0 goods_buy_nums:nums thricePurchase:@[] isShopCart:@"y" coupon:@"" exchangedThriceCoin:0 goodsID:goods buyType:@"now"];
        
            }else{
                
                [Tool showPromptContent:@"亲 请先选择商品哦！微笑"];
               
               
                canClick = NO;
            }
        
    }else{
        MLog(@"!!!!!!!!!!!!!!!!!!");
    }
    
}

//全选
-(void)selectAllaction:(UIButton *)sender{
    
    sender.tag = !sender.tag;
    if (sender.tag)
    {
        sender.selected = YES;
    }else{
        sender.selected = NO;
        
    }
    [stuatsArray removeAllObjects];
    //改变单元格选中状态
    for (int i=0; i<self.dataArray.count;i++)
    {
        ShopCartInfo *model = self.dataArray[i];
        model.selectState = sender.tag;
    }
 
    [self CalculationPrice];
   
    [self.tableView reloadData];
    
    
}

//计算价格
-(void)CalculationPrice
{
    self.allPrice = 0.0;
    self.ids = @"";
    //遍历整个数据源，然后判断如果是选中的商品，就计算价格(单价 * 商品数量)
    for ( int i =0; i<self.dataArray.count;i++)
    {
        ShopCartInfo *model = self.dataArray[i];
        if (model.selectState)
        {
            self.allPrice = self.allPrice + [model.goods_buy_num intValue]*model.good_single_price;
            self.ids = [NSString stringWithFormat:@"%@,%@",model.id,self.ids];
            
        }
    }

    //给总价赋值
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld小米",(long)self.allPrice]];
    [str addAttribute:NSFontAttributeName value:SYSTEMFONT(12) range:NSMakeRange(0,str.length-2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,str.length-2)];
    self.totalMoneyLab.attributedText = str;
    
    //         NSLog(@"%f",self.allPrice);
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCarCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCarCell"];
    if(cell==nil){
        cell = [[ShoppingCarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopCarCell"];
    }
    cell.delegate = self;
     ShopCartInfo *model = self.dataArray[indexPath.row];
    cell.shoplistModel = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 0;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//        [self removeAction:indexPath.section]; // 在此处自定义删除行为
        ShopCartInfo *info = self.dataArray[indexPath.row];
        [self httpDeleyeShopCarInfoWithGoodsIds:info.goods_id];
    }
    else
    {
       
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 155;
}



//单元格选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     * 判断当期是否为选中状态，如果选中状态点击则更改成未选中，如果未选中点击则更改成选中状态
     */
    ShopCartInfo *model = self.dataArray[indexPath.row];
    if (model.selectState)
    {
        model.selectState = NO;
        [stuatsArray addObject:model.id];
    }
    else
    {
        model.selectState = YES;
        [stuatsArray removeObject:model.id];
    }

    //刷新当前行
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self CalculationPrice];
}

#pragma mark -- 实现加减按钮点击代理事件
/**
 * 实现加减按钮点击代理事件
 *
 * @param cell 当前单元格
 * @param flag 按钮标识，11 为减按钮，12为加按钮
 */


-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag andNum:(int)num
{
    if (kanClick) {
    kanClick = NO;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
     ShopCartInfo *model = self.dataArray[index.row];
    switch (flag) {
        case 11:
        {
//            做减法
            MLog(@"做减法");
            //先获取到当期行数据源内容，改变数据源内容，刷新表格
           
            if ([model.goods_buy_num intValue] > 1)
            {
            model.goods_buy_num = [NSString stringWithFormat:@"%d",[model.goods_buy_num intValue]-1];
            }
        }
            break;
        case 12:
        {
            //做加法
             MLog(@"做加法");
           
            if ([model.goods_buy_num intValue] == (model.need_people-model.now_people)) {
                model.goods_buy_num = [NSString stringWithFormat:@"%ld",(model.need_people-model.now_people)];
            }else{
                 
                model.goods_buy_num = [NSString stringWithFormat:@"%d",[model.goods_buy_num intValue]+1];
                
            }
        }
            break;
        case 13:
        {
            //做加法
            MLog(@"按钮");
           
            model.goods_buy_num = [NSString stringWithFormat:@"%d",num];
            
        }
        case 14:
        {
            //做加法
            MLog(@"按钮");
           
            model.goods_buy_num = [NSString stringWithFormat:@"%d",num];
//            
        }
            break;
        default:
            break;
    }
    //刷新表格
    
       [self httpUpdateShopCarInfoWithGoodsId:model.goods_id goodsNum:model.goods_buy_num];
    }else{
        MLog(@"不能点点");
    }
    

    //计算总价
    [self CalculationPrice];
}

// 直接购买 = 生成与订单 -> 夺宝币小米均足够可直接购买
- (void)purchaseGoodsFightID:(NSString *)goods_fight_ids
                       count:(int)crowdfundingBettingCount
              goods_buy_nums:goods_buy_nums
              thricePurchase:(NSArray *)thriceArray
                  isShopCart:(NSString *)is_shop_cart
                      coupon:(NSString *)ticket_send_id
         exchangedThriceCoin:(int)exchangedThriceCoin
                     goodsID:(NSString *)goods_ids
                     buyType:(NSString *)buyType
{
    
    __weak typeof(self) wself = self;
    
    [HttpHelper purchaseGoodsFightID:goods_fight_ids
                               count:crowdfundingBettingCount
                      goods_buy_nums:goods_buy_nums
                      thricePurchase:thriceArray
                          isShopCart:is_shop_cart
                              coupon:ticket_send_id
                 exchangedThriceCoin:exchangedThriceCoin
                             goodsID:goods_ids
                             buyType:buyType
                             success:^(NSDictionary *data) {
                                 MLog(@"purchaseGoodsFightIDdata%@",data);
                                 NSArray *arr = data[@"goods_fight_buy_List"];
                                 NSDictionary *dic = arr.firstObject;
                                 int price = [dic[@"good_single_price"] intValue];
                                 MLog(@"purchaseGoodsFightIDprice%d",price);
                                 
                                 //                                 int crowdfundingBettingCount = [[_data objectForKey:@"Crowdfunding"] intValue];
                                 
                                 int inventory = [[data objectForKey:@"has_inventory"] intValue];
                                 
                                 BOOL result = NO;
                                 NSDictionary *dict = nil;
                                 NSArray *array = [data objectForKey:@"results"];
                                 
                                 if ([array isKindOfClass:[NSArray class]]) {
                                     
                                     NSDictionary *object = [array firstObject];
                                     
                                     if ([object isKindOfClass:[NSDictionary class]]) {
                                         dict = object;
                                         result = YES;
                                     }
                                 }
                                 
                                 NSString *wording = [NSString stringWithFormat:@"库存不足，是否包尾"];
                                 NSString *sureButtonStr = [NSString stringWithFormat:@"包尾"];
                                 
                                 if ([buyType isEqualToString:@"now"]) {
                                     
                                     // 该期已结束，是否参与下一期
                                     if (inventory == 0 && result == NO) {
                                         
                                         // 中断loading，显示alert
                                         //                                         [wself.loadingHUD hide:NO];
                                         
                                         wording = @"该期已结束，是否参与下一期";
                                         sureButtonStr = @"参与";
                                         
                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             
                                             
                                             [wself purchaseGoodsFightID:goods_fight_ids
                                                                   count:crowdfundingBettingCount
                                                          goods_buy_nums:goods_buy_nums
                                                          thricePurchase:thriceArray
                                                              isShopCart:is_shop_cart
                                                                  coupon:ticket_send_id
                                                     exchangedThriceCoin:exchangedThriceCoin
                                                                 goodsID:goods_ids
                                                                 buyType:@"next"];
                                         }];
                                         
                                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                         }];
                                         
                                         [alertController addAction:cancelAction];
                                         [alertController addAction:alertAction];
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         
                                         // 库存不足
                                     } else if (inventory < crowdfundingBettingCount && result == NO) {
                                         
                                         // 中断loading，显示alert
                                         //                                         [wself.loadingHUD hide:NO];
                                         
                                         wording = [NSString stringWithFormat:@"库存不足，是否包尾 ？"];
                                         sureButtonStr = @"包尾";
                                         
                                         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wording message:nil preferredStyle:UIAlertControllerStyleAlert];
                                         UIAlertAction *alertAction = [UIAlertAction actionWithTitle:sureButtonStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             //谷歌分析包尾和不包尾
                                             [wself purchaseGoodsFightID:goods_fight_ids
                                                                   count:crowdfundingBettingCount
                                                          goods_buy_nums:goods_buy_nums
                                                          thricePurchase:thriceArray
                                                              isShopCart:is_shop_cart
                                                                  coupon:ticket_send_id
                                                     exchangedThriceCoin:exchangedThriceCoin
                                                                 goodsID:goods_ids
                                                                 buyType:@"mantissa"];
                                             
                                         }];
                                         
                                         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                             
                                         }];
                                         
                                         [alertController addAction:cancelAction];
                                         [alertController addAction:alertAction];
                                         [self presentViewController:alertController animated:YES completion:nil];
                                         
                                     }else if (result == YES) {
                                         
                                         [wself purchaseSuccess:data];
                                     }
                                 }
                                 
                                 // 上一轮执行操作为包尾，存在两种情况，包尾成功／该期已结束
                                 if ([buyType isEqualToString:@"mantissa"]) {
                                     
                                     
                                     // 包尾失败，该期已结束，操作终止
                                     if (inventory == 0  && result == NO) {
                                         
                                         [wself purchaseFailure:kPurchaseFailureOver];
                                         
                                     }else if (result == YES) {
                                         
                                         [wself purchaseSuccess:data];
                                     }
                                 }
                                 
                                 // 上一轮操作为买入到下一期，存在两种结果，库存不足没买上终止交易／购买成功
                                 if ([buyType isEqualToString:@"next"]) {
                                     
                                     // 购买失败，库存不足，操作终止
                                     if (inventory < crowdfundingBettingCount && result == NO) {
                                         
                                         [wself purchaseFailure:kPurchaseFailureInventoryNotEnought];
                                         
                                     }else if (result == YES) {
                                         
                                         [wself purchaseSuccess:data];
                                     }
                                 }
                                 
                                 
                                 MLog(@"%@", dict);
                                 
                             } failure:^(NSString *description) {
                                 
                                 [self purchaseFailure:description];
                             }];
}

// 购买支付成功
- (void)purchaseSuccess:(NSDictionary *)data
{
//    [activityIndicator stopAnimating];
    
    [Tool showPromptContent:@"购买成功" onView: [UIApplication sharedApplication].keyWindow];
    ShopCarBuySucessViewController *vc = [[ShopCarBuySucessViewController alloc]initWithNibName:@"ShopCarBuySucessViewController" bundle:nil];
    vc.modelDic = data;
    [self.navigationController pushViewController:vc animated:YES];
//    [self setTabelViewRefresh];
     canClick = NO;
    
}

// 购买失败
- (void)purchaseFailure:(NSString *)description
{
    [Tool showPromptContent:description onView: [UIApplication sharedApplication].keyWindow];
//      [self setTabelViewRefresh];
     canClick = NO;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
