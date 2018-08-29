//
//  AgreementCheckbox.m
//  DuoBao
//
//  Created by clove on 4/9/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "AgreementCheckbox.h"
#import "SafariViewController.h"

@interface AgreementCheckbox()
@property (nonatomic, strong) UIButton *button;

@end

@implementation AgreementCheckbox

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithController:(UIViewController *)viewController
{
    CGRect frame = CGRectMake(0, 0, ScreenWidth, 44);
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_checkbox_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_checkbox_selected"] forState:UIControlStateSelected];
        [button sizeToFit];
        [button addTarget:self action:@selector(checkboxAction) forControlEvents:UIControlEventTouchUpInside];
        _button = button;
        
        UIColor *textColor = [UIColor colorFromHexString:@"a3a3a3"];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"我已同意并阅读《米花糖服务协议》";
        label.textColor = textColor;
        label.font = [UIFont systemFontOfSize:12];
        [label sizeToFit];
        
        self.height = 44;
        self.width = button.width + label.width + 2;
        label.left = button.width + 2;
        button.centerY = self.height / 2;
        label.centerY = button.centerY;
        
        [self addSubview:button];
        [self addSubview:label];
        
        button.selected = YES;
        
        [self whenTapped:^{
            
            SafariViewController *vc = [[SafariViewController alloc]initWithNibName:@"SafariViewController" bundle:nil];
            vc.title = @"服务协议";
            vc.urlStr = [NSString stringWithFormat:@"%@%@id=6&is_show_message=y", URL_Server, Wap_AboutDuobao];
            [viewController.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    return self;
}

- (void)checkboxAction
{
    _button.selected = !_button.selected;
}

- (BOOL)isSelected
{
    BOOL result = _button.isSelected;
    return result;
}

@end
