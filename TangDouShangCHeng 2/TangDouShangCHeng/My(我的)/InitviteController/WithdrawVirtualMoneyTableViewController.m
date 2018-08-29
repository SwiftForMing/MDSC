//
//  WithdrawMoneyTableViewController.m
//  DuoBao
//
//  Created by clove on 12/13/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "WithdrawVirtualMoneyTableViewController.h"

@interface WithdrawVirtualMoneyTableViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) InviteModel *model;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *bottomButton;

@end

@implementation WithdrawVirtualMoneyTableViewController

- (void)dealloc
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    
    _model = [ShareManager shareInstance].inviteModel;

    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [self footerView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    //    [[IQKeyboardManager sharedManager] disableInViewControllerClass:[self class]];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"请输入转出金额";
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor colorFromHexString:@"666666"];
            break;
        }
        case 1:
        {
            UITextField *textField = [self createTextFieldWithFrame:CGRectMake(16, 0, screenWidth- 2*16, 86)];
            textField.placeholder = [NSString stringWithFormat:@"不低于%@元", @"5"];
            [cell.contentView addSubview:textField];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float heights[] = {50, 86, 70};
    
    float height = 50;
    if (indexPath.row < 3) {
        height = heights[indexPath.row];
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    view.backgroundColor = [UIColor colorFromHexString:@"f7f7f7"];
    [view addSingleBorder:UIViewBorderDirectTop color:[UIColor defaultTableViewSeparationColor] width:0.5f];
    return view;
}

- (UITextField *)createTextFieldWithFrame:(CGRect)frame
{
    float fontOfSize = 22;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.font = [UIFont systemFontOfSize:fontOfSize];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"¥";
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:fontOfSize + 2];
    [label sizeToFit];
    label.width += 8;
    textField.leftView = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"全部转出" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor defaultRedColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.contentMode = UIViewContentModeRight;
    button.height = textField.height;
    button.width = 70;
    [button addTarget:self action:@selector(withdrawAllButtonAction) forControlEvents:UIControlEventTouchUpInside];
    textField.rightView = button;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    textField.delegate = self;
    _textField = textField;

    return textField;
}

- (UIButton *)createButtonWithLeftMargin:(CGFloat)left top:(CGFloat)top height:(CGFloat)height title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] darkerColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[[UIColor whiteColor] darkerColor] forState:UIControlStateSelected];
    [button setTitleColor:[[UIColor whiteColor] darken:0.25] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.height = height;
    button.width =  [UIScreen mainScreen].bounds.size.width - 2*left;
    button.left = left;
    button.top = top;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.height/2;
    button.backgroundColor = [UIColor defaultRedButtonColor];
    //    UIImage *image = [UIImage imageFromContextWithColor:[UIColor defaultRedColor] size:button.size];
    //    UIImage *darkerImage = [UIImage imageFromContextWithColor:[[UIColor defaultRedColor] darkerColor] size:button.size];
    //    [button setBackgroundImage:image forState:UIControlStateNormal];
    //    [button setBackgroundImage:darkerImage forState:UIControlStateSelected];
    //    [button setBackgroundImage:darkerImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(bottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)footerView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    UIButton *button = [self createButtonWithLeftMargin:16 top:30 height:40 title:@"确定转出"];
    [view addSubview:button];
    _bottomButton = button;
    
    int remainder = [[_model remainderMoney] floatValue] * 100;
    if (remainder < 500) {
        button.backgroundColor = [[UIColor defaultRedButtonColor] darken:0.25];
        button.enabled = NO;
    }
    
    return view;
}

// 是否不合法
- (BOOL)illegalValue:(NSString *)moneyStr
{
    BOOL result = NO;
    
    int value = [moneyStr floatValue] * 100;
    
    int remainderMoney = [[_model remainderMoney] floatValue] * 100;
    
    int minusValue = remainderMoney - value;
    
    // 不合法
    if (minusValue < 0 || remainderMoney < 500) {
        result = YES;
    }
    
    return result;
}

- (BOOL)minusMoneyWithString:(NSString *)moneyStr
{
    int value = [moneyStr floatValue] * 100;
    
    int remainderMoney = [[_model remainderMoney] floatValue] * 100;
    
    remainderMoney -= value;
    
    if (remainderMoney < 0) {
        return NO;
    }
    
    float remainderFloat = remainderMoney * 0.01;
    NSString *remainderString = [NSString stringWithFormat:@"%.2f", remainderFloat];
    _model.user_earnings = remainderString;
    
    return YES;
}

#pragma mark - Action

- (void)withdrawAllButtonAction
{
    NSString *str = [_model remainderMoney];
    int value = [str intValue];
    
    _textField.text = [NSString stringWithFormat:@"%d", value];
}

- (void)bottomButtonAction
{
    if ([self illegalValue:_textField.text]) {
        [Tool showPromptContent:@"余额不足"];
        return;
    }
    
    float value = [_textField.text floatValue];
    
    NSString *money = [NSString stringWithFormat:@"%.0f", value];
    
    __weak typeof(self) weakself = self;
    
    [HttpHelper withdrawMoney:money
             withdrawType:@"virtual"
                  success:^(NSDictionary *resultDic) {
                      
                      NSString *status = [resultDic objectForKey:@"status"];
                      NSString *description = [resultDic objectForKey:@"desc"];
                      
                      if ([status isEqualToString:@"0"]) {
                          
                          // 减去转出金额
                          [weakself minusMoneyWithString:money];
                          [Tool showPromptContent:@"提交成功，请等待审核"];
                      } else {
                          [Tool showPromptContent:description];
                      }
                      
                  } fail:^(NSString *description) {
                      
                      [Tool showPromptContent:description];
                  }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore
{
    [textField resignFirstResponder];
    return YES;
}

@end
