//
//  MoreCardTableViewController.m
//  DuoBao
//
//  Created by clove on 11/29/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "MoreCardTableViewController.h"
#import "MoreCardTableViewCell.h"

@interface MoreCardTableViewController ()

@end

@implementation MoreCardTableViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self.tableView registerClass:[MoreCardTableViewCell class] forCellReuseIdentifier:@"MoreCardTableViewCell"];
    
    UINib *nib = [UINib nibWithNibName:@"MoreCardTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MoreCardTableViewCell"];
    self.tableView.allowsSelection = NO;
    
    [self leftNavigationItem];
    [self setRightBarButtonItem:@"复制所有"];
    
    self.title = @"充值卡";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRightBarButtonItem:(NSString *)title
{
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction:)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
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

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要复制所有充值卡吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        NSString *copyAll = @"";
        for (NSDictionary *recharge in _rechargeArray) {
            NSString *rechargeNumber = [recharge objectForKey:@"card_number"];
            NSString *rechargePassword = [recharge objectForKey:@"card_pass"];
            NSString *str = [NSString stringWithFormat:@"%@\n%@", rechargeNumber, rechargePassword];
            
            copyAll = [copyAll stringByAppendingFormat:@"%@\n\n", str];
        }
        
        pasteboard.string = copyAll;
        [Tool showPromptContent:@"复制所有成功"];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 

- (void)setRechargeArray:(NSArray *)rechargeArray
{
    _rechargeArray = rechargeArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _rechargeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *recharge = [_rechargeArray objectAtIndex:indexPath.section];
    NSString *rechargeNumber = [recharge objectForKey:@"card_number"];
    NSString *rechargePassword = [recharge objectForKey:@"card_pass"];
    
    MoreCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCardTableViewCell" forIndexPath:indexPath];
    
    MLog(@"%@,%@",rechargeNumber,rechargePassword);
    
    NSString *str = [NSString stringWithFormat:@"卡号：%@", rechargeNumber];
    if (indexPath.row == 1) {
        str = [NSString stringWithFormat:@"密码：%@", rechargePassword];
    }
    [cell reloadWithString:str];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{
    NSString *str = @"";
    str = [NSString stringWithFormat:@"第 %ld 张充值卡", section+1];
    
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1f;
    if (section == _rechargeArray.count-1) {
        height = 3.0f;
    }
    
    return height;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
