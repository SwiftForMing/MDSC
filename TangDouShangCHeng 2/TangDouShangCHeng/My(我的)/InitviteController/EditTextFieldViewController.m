//
//  EditTextFieldViewController.m
//  LLLM
//
//  Created by clove on 10/23/15.
//  Copyright (c) 2015 clove. All rights reserved.
//

#import "EditTextFieldViewController.h"

@interface EditTextFieldViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *indicatorString;
@property (nonatomic, strong) void (^block)(BOOL result, NSString *changedText);

@end

@implementation EditTextFieldViewController

- (void)dealloc
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
}

- (instancetype)initWithText:(NSString *)text placeholder:(NSString *)placeholder completed:(void (^)(BOOL result, NSString *changedText))block
{
    self = [super initWithTableViewStyle:UITableViewStyleGrouped];
    if (self) {
        _text = text;
        _placeholder = placeholder;
        _block = block;
    }
    
    return self;
}

- (instancetype)initWithText:(NSString *)text placeholder:(NSString *)placeholder indicatorStringForHeader:(NSString *)indicatorString completed:(void (^)(BOOL result, NSString *changedText))block
{
    self = [super initWithTableViewStyle:UITableViewStyleGrouped];
    if (self) {
        _text = text;
        _placeholder = placeholder;
        _block = block;
        _indicatorString = indicatorString;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setRightBarButtonItem:@"完成"];
    
    self.title = @"推荐人ID";
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    // 推荐人ID为空
    NSString *recommendUserID = [ShareManager shareInstance].userinfo.recommend_user_id;
    if (recommendUserID.length == 0 || [recommendUserID isEqualToString:@"<null>"]) {
        self.tableView.tableFooterView = [self footerViewWithTitle:@"提交"];
    } else {
        self.textField.userInteractionEnabled = NO;
    }
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 推荐人ID为空
    NSString *recommendUserID = [ShareManager shareInstance].userinfo.recommend_user_id;
    if (recommendUserID.length == 0 || [recommendUserID isEqualToString:@"<null>"]) {
        [_textField becomeFirstResponder];
    }
}

- (void)rightBarButtonItemAction:(id)sender
{
    [_textField resignFirstResponder];
    
    BOOL isChanged = NO;
    NSString *origin = _text;
    NSString *text = _textField.text;
    
    if (origin == nil) {
        if (text != nil ) {
            isChanged = YES;
        }
    } else {
        if (text == nil ) {
            isChanged = YES;
        } else {
            if (![origin isEqualToString:text]) {
                isChanged = YES;
            }
        }
    }
    
    _block(isChanged, text);
    
    [self saveRecommendUserID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    switch (indexPath.row) {
        case 0:
        {
            UITextField *textField = [[UITextField alloc] initWithFrame:cell.frame];
            textField.textAlignment = NSTextAlignmentLeft;
            textField.borderStyle = UITextBorderStyleNone;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.width = ScreenWidth - MARGIN *2 ;
            textField.left = cell.layoutMargins.left *2;
            textField.text = _text;
            textField.placeholder = _placeholder;
            [cell.contentView addSubview:textField];

            // 推荐人ID为空
            NSString *recommendUserID = [ShareManager shareInstance].userinfo.recommend_user_id;
            if (recommendUserID.length == 0 || [recommendUserID isEqualToString:@"<null>"]) {
            } else {
                textField.userInteractionEnabled = NO;
            }
            
            _textField = textField;
            
            break;
        }
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section    // fixed font style. use custom view (UILabel) if you want something different
{
    NSString *str = @"";
    if (_indicatorString) {
        str = _indicatorString;
    }
    
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    CGFloat height = 0.1;
    if (section == 0){
        height = 10;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0)
{
    CGFloat height = 20;
    if (section == 0) {
        height = 50;
    }
    
    return height;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField             // called when 'return' key pressed. return NO to ignore.
{
    [self rightBarButtonItemAction:nil];
    return YES;
}

- (void)footerButtonAction
{
    [self rightBarButtonItemAction:nil];
}

#pragma mark - 

- (void)saveRecommendUserID
{
    NSString *recommendUserID = _textField.text;
    
//    HttpHelper *helper = [HttpHelper helper];
    __weak typeof(self) weakself = self;
    
    [HttpHelper saveRecommendUserID:recommendUserID
                            success:^(NSDictionary *resultDic){
                                
                                NSString *status = [resultDic objectForKey:@"status"];
                                NSString *decretion = [resultDic objectForKey:@"desc"];
                                
                                if ([status isEqualToString:@"0"]) {
                                    UserInfo *model = [ShareManager shareInstance].userinfo;
                                    model.recommend_user_id = recommendUserID;
                                    [model updateToDB];
                                    
                                    [Tool showPromptContent:@"成功"];
                                    [self.navigationController popViewControllerAnimated:YES];
                                } else {
                                    [Tool showPromptContent:decretion];
                                }

                            }fail:^(NSString *decretion){
                                
                                [Tool showPromptContent:decretion];
                            }];
}



@end
