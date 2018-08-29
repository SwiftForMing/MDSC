//
//  AllGoodsOfFreePurchaseTableViewContrller.m
//  DuoBao
//
//  Created by clove on 1/3/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "AllGoodsOfFreePurchaseTableViewContrller.h"
#import "FreePurchaseGoodsTableViewCell.h"

@interface AllGoodsOfFreePurchaseTableViewContrller ()
@property (nonatomic, strong) NSArray *listData;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AllGoodsOfFreePurchaseTableViewContrller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本周商品";
    
    self.tableView.backgroundColor = [UIColor colorFromHexString:@"26002f"];
    _titleLabel.font = [UIFont fontWithName:@"FZShangKuS-R-GB" size:18];
    
    [self request];
    
    self.tableView.tableHeaderView = _tableHeaderView;
    _tableHeaderView.backgroundColor = self.tableView.backgroundColor;
    
//    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    [self setLeftBarButtonItemArrow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLeftBarButtonItemArrow
{
    if (self.navigationController == nil) {
        return;
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FreePurchaseGoodsTableViewCell" owner:nil options:nil];
    FreePurchaseGoodsTableViewCell *cell = [nib firstObject];
    
    NSArray *array = [_listData objectAtIndex:indexPath.row];
    [cell reloadWithArray:array];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor colorFromHexString:@"26002f"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 180 * UIAdapteRate;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark -

- (void)request
{
    __weak typeof(self) weakself = self;
    [HttpHelper getOneWeekFreeGoodsList:^(NSDictionary *resultDic) {
        
        NSString *status = [resultDic objectForKey:@"status"];
        NSString *description = [resultDic objectForKey:@"desc"];
        NSDictionary *dict = [resultDic objectForKey:@"data"];
        
        if ([status isEqualToString:@"0"]) {
            
            NSArray *keys = @[@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN"];
            
            NSMutableArray *list = [NSMutableArray array];
            for (NSString *key in keys) {
                NSArray *array = [dict objectForKey:key];
                if (array) {
                    [list addObject:array];
                }
            }

            weakself.listData = list;
            
            // 修改标题
            NSDictionary *dict = [[list lastObject] lastObject];
            weakself.titleLabel.text = [dict objectForKey:@"current_desc"];
            
            [weakself.tableView reloadData];
        } else {
            [Tool showPromptContent:description];
        }
        
    } fail:^(NSString *description) {
        
        [Tool showPromptContent:description];
    }];
}



@end
