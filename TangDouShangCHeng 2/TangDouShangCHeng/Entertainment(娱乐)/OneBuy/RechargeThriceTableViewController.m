//
//  RechargeThriceTableViewController.m
//  DuoBao
//
//  Created by clove on 4/17/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "RechargeThriceTableViewController.h"
#import "NumberInputField.h"
#import "PaySelectedController.h"
#import "AgreementCheckbox.h"
#import "FooterButtonView.h"
#import "CZRecordListViewController.h"
#import "CZResultViewController.h"
#import "FAQTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YYKitMacro.h"

@interface RechargeThriceTableViewController ()
@property (weak, nonatomic) IBOutlet NumberInputField *inputTextField;
@property (nonatomic, strong) UIView *thriceCoinView;
@property (nonatomic, strong) PaySelectedController *paySelectedController;
@property (nonatomic, strong) AgreementCheckbox *agreementCheckbox;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (nonatomic, strong) UIButton *footerButton;
@property (nonatomic) BOOL footerButtonHasTapped;
@property (nonatomic, strong) MBProgressHUD *loadingHUD;
@property (weak, nonatomic) IBOutlet UIButton *ruleButton;


@end

@implementation RechargeThriceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"欢乐券";
    
    [self leftNavigationItem];
    [self rightItemView];
    
    [_inputTextField grayStyle:_inputTextField.frame];
    NumberInputField *inputField = _inputTextField;
    inputField.coinType = CoinTypeCrowdfunding;
    inputField.cardinalNumber = 10;
    inputField.bettingType = BettingTypeThrice0;
    inputField.exchangeRate = 100;
    inputField.delegate = self;
    inputField.min = 1;
    [inputField setDefaultValue:10 limit:10000000];
    
    PaySelectedController *tableViewController = [[PaySelectedController alloc] initWithNibName:@"PaySelectedController" bundle:nil];
    [self addChildViewController:tableViewController];
    tableViewController.tableView.top = 0;
    [self.tableView addSubview:tableViewController.tableView];
    _paySelectedController = tableViewController;
    
    
    self.tableView.tableHeaderView = _tableHeaderView;
    
    FooterButtonView *footerView = [[FooterButtonView alloc] initWithTitle:@"立即购买"];
    [footerView.button addTarget:self action:@selector(rechargeAction) forControlEvents:UIControlEventTouchUpInside];
    _footerButton = footerView.button;
    self.tableView.tableFooterView = footerView;

//    if ([ShareManager shareInstance].isInReview == YES) {
//        self.tableView.tableFooterView = nil;
//    }
    
    [self updateUserInterface];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    MLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    MLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
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

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"消费记录" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0,0)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}

#pragma mark - Button Action

- (void)clickLeftItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightItemAction:(id)sender
{
    CZRecordListViewController *vc = [[CZRecordListViewController alloc] initWithNibName:@"CZRecordListViewController" bundle:nil];
    vc.isThrice = YES;
    vc.title = @"小米消费记录";
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ruleButtonAction:(id)sender {
    
    FAQTableViewController *vc = [[FAQTableViewController alloc] initWithNibName:@"FAQTableViewController" bundle:nil];
//     
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rechargeAction
{
    int payCNY = _inputTextField.number;
    
    if (_footerButtonHasTapped) {
        return;
    }
    
    // 是否在最小充值范围内
    NSString *purchasePermission = [_paySelectedController paymentPermission:payCNY];
    if (![purchasePermission isEqualToString:@"allow"]) {
        [Tool showPromptContent:purchasePermission];
        return;
    }
    
    // 如果是mustpay支付，间隔时间设置为10秒，用户调出mustpay支付界面，没有选择支付，点击左上角的X后，loading无法监听和取消
    int loadingTime = 30;
    if (_paySelectedController.selectedPayCategory == PayCategoryMustpay) {
        loadingTime = 10;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    //    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [_loadingHUD hide:NO];
    _loadingHUD = HUD;
    [_loadingHUD hide:YES afterDelay:loadingTime];
    [ _loadingHUD setCompletionBlock:^(void) {
        _footerButtonHasTapped = NO;
    }];
    
    _footerButtonHasTapped = YES;

    __weak typeof(self) wself = self;
    MLog(@"充值RechargeThrice");
//    [_paySelectedController rechargeThriceCoin:payCNY completion:^(BOOL result, NSString *description, NSDictionary *dict) {
//
//        wself.footerButtonHasTapped = NO;
//
//        if (result == NO) {
//            HUD.mode = MBProgressHUDModeText;
//            HUD.labelText = description;
//            [HUD hide:YES afterDelay:2];
//        } else {
//
//            HUD.mode = MBProgressHUDModeText;
//            HUD.labelText = @"充值成功";
//            [HUD hide:YES afterDelay:2];
//
//            [ShareManager shareInstance].userinfo.happy_bean_num += payCNY * ThriceExchangeRate;
//            //进度支付结果页面
//            CZResultViewController *vc = [[CZResultViewController alloc]initWithNibName:@"CZResultViewController" bundle:nil];
//            vc.allMoney = payCNY;
//            vc.coinType = @"小米";
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
//
////            [wself.navigationController popViewControllerAnimated:YES];
//        }
//
//        MLog(@"%@", dict.my_description);
//    }];
}

- (void)updateUserInterface
{
//    int value = _inputTextField.value;
//    int thriceCoin = value;
    
//    [_thriceCoinView removeFromSuperview];
//    NSString *str = [NSString stringWithFormat:@"赠送 %d ", thriceCoin];
//    _thriceCoinView = [Tool thriceCoinViewWithStr:str fontSize:12 textColor:nil];
//    _thriceCoinView.right = ScreenWidth - 16;
//    _thriceCoinView.bottom = _tableHeaderView.height - 15;
//    [_tableHeaderView addSubview:_thriceCoinView];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if ([ShareManager shareInstance].isInReview == YES) {
//        return 0;
//    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if ([ShareManager shareInstance].isInReview == YES) {
//        return 0;
//    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIColor *color = [UIColor colorFromHexString:@"474747"];
    UIColor *redColor = [UIColor colorFromHexString:@"e6322c"];
    cell.textLabel.text = @"选择支付方式";
    cell.textLabel.textColor = color;
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    
    
    NSString *str = [NSString stringWithFormat:@"%d元", _inputTextField.number];
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:@"共计 " attributes:@{NSForegroundColorAttributeName:color}];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:redColor}];
    [attr1 appendAttributedString:attr2];
    cell.detailTextLabel.attributedText = attr1;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 36;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.1;
    
    height = _paySelectedController.height + 50;
    
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    view.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    
//    if ([ShareManager shareInstance].isInReview == YES) {
//        return nil;
//    }
//    
    UIView *view = nil;
    
    // 小米、小米足够不需要RMB购买，隐藏支付界面
    if (section == 0) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _paySelectedController.height + 50)];
//        view.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
        view.backgroundColor = [UIColor clearColor];

        _paySelectedController.tableView.top = 1;
        
        // 支付方式选择
        [view addSubview:_paySelectedController.tableView];
        
        // Tabel section separation line
        UIImageView *separationLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _paySelectedController.height-1, ScreenWidth, 0.5)];
        separationLine.backgroundColor = [UIColor defaultTableViewSeparationColor];
//        [view addSubview:separationLine];
        
        // 服务协议
        if (_agreementCheckbox == nil) {
            _agreementCheckbox = [[AgreementCheckbox alloc] initWithController:self];
        }
        
        AgreementCheckbox *checkboxView = _agreementCheckbox;
        checkboxView.centerX = view.width / 2;
        checkboxView.top = _paySelectedController.height;
        [view addSubview:_agreementCheckbox];
    }
    
    return view;
}

#pragma mark - NumberInputFieldDelegate

- (void)numberInputFieldChanged:(NumberInputField *)numberInputField currentValue:(int)money
{
    [self updateUserInterface];
}


@end
