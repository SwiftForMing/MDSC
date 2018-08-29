
//
//  FAQTableViewController.m
//  DuoBao
//
//  Created by clove on 4/18/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "FAQTableViewController.h"

@interface FAQTableViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation FAQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"小米使用规则";
    
    NSString *title1 = @"如何使用小米?";
    NSString *content1 = @"1、在米花糖抵扣现金（100小米=1元）。下单时，在购买页面您可使用小米抵扣部分订单金额或小米 \n2、参与举办的各种活动，如小米活动，小米竞猜等";
    
    NSString *title2 = @"如何获得小米?";
    NSString *content2 = @"1、签到免费领小米，用户可每天签到可免费领小米，连续签到会获取更多小米 \n2、购买欢乐优惠券免费获赠小米，欢乐优惠券可用于抵扣小米或者现金 \n3、购物充值免费获得小米，用户充值小米或者直接参与下单购买商品，均可免费获得赠送的小米。具体赠送金额，见充值活动详情 \n4、评论晒单免费获赠小米，用户成功评论晒单后将会免费获得相应的小米赠送（用户只能评价自己购买的商品） \n5、参与米花糖举办的各种活动，如活动、游戏等均有机会获得额外小米";

    NSString *title3 = @"使用规则";
    NSString *content3 = @"1、米花糖小米仅限在米花糖使用，小米可抵扣部分现金或者小米，不能单独购买商品 \n2、消费时可使用小米的数量是100的整数倍，如100、200、300等小米数 \n3、如果您拥有的小米数量小于100个，则不可在结算或者收银台使用小米支付";

    NSArray *array = @[
                       @{@"title":title1,
                         @"content":content1},

                       @{@"title":title2,
                         @"content":content2},

                       @{@"title":title3,
                         @"content":content3},
                       ];
    
    _data = array;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    view.backgroundColor = [UIColor colorFromHexString:@"fffbf9"];
    self.tableView.tableFooterView = view;
    
    [self leftNavigationItem];
}

- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 16, 17)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIColor *pinkColor = [UIColor colorFromHexString:@"fffbf9"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = pinkColor;
    cell.contentView.backgroundColor = pinkColor;
    
    NSDictionary *dict = [_data objectAtIndex:indexPath.row];
    NSString *title = [dict objectForKey:@"title"];
    NSString *content = [dict objectForKey:@"content"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorFromHexString:@"e84b42"];
    [label sizeToFit];
    label.width += 2 * 10;
    label.height += 2 * 2;
    label.top = 20;
    label.left = 20;
    label.layer.cornerRadius = label.height / 2;
    label.layer.masksToBounds = YES;
    [cell.contentView addSubview:label];
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
//    textView.font = [UIFont systemFontOfSize:13];
//    textView.textColor = [UIColor colorFromHexString:@"ed7a74"];
    textView.backgroundColor = [UIColor colorFromHexString:@"fffbf9"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName: [UIFont systemFontOfSize:13.5],
                                 NSForegroundColorAttributeName:[UIColor colorFromHexString:@"ed7a74"]
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    textView.width = ScreenWidth - 20*2 + 4 + 8;
    [textView sizeToFit];
    textView.top = label.bottom + 4;
    textView.left = label.left - 4;
    textView.userInteractionEnabled = NO;
    
    [cell.contentView addSubview:textView];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    NSDictionary *dict = [_data objectAtIndex:indexPath.row];
    NSString *title = [dict objectForKey:@"title"];
    NSString *content = [dict objectForKey:@"content"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorFromHexString:@"e84b42"];
    [label sizeToFit];
    label.width += 2 * 10;
    label.height += 2 * 2;
    label.top = 20;
    label.left = 20;
    label.layer.cornerRadius = label.height / 2;
    label.layer.masksToBounds = YES;
    
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
//    textView.font = [UIFont systemFontOfSize:13];
//    textView.textColor = [UIColor colorFromHexString:@"ed7a74"];
    textView.backgroundColor = [UIColor colorFromHexString:@"fffbf9"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,
                                 NSFontAttributeName: [UIFont systemFontOfSize:13.5],
                                 NSForegroundColorAttributeName:[UIColor colorFromHexString:@"ed7a74"]
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
    textView.width = ScreenWidth - 20*2 + 4 + 8;
    [textView sizeToFit];
    textView.top = label.bottom + 4;
    textView.left = label.left - 4;
    textView.userInteractionEnabled = NO;
    
    height = textView.bottom - 9;
    
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



@end
