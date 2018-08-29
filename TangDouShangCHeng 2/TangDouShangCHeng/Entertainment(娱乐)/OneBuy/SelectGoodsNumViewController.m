//
//  SelectGoodsNumViewController.m
//  DuoBao
//
//  Created by 林奇生 on 16/3/15.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "SelectGoodsNumViewController.h"
#import "SelectGoodsNumberView.h"
#import "UIView+Additions.h"
#import "GoodsDetailInfo.h"
#import "GoodsFightModel.h"

@interface SelectGoodsNumViewController ()<UITextFieldDelegate, SelectGoodsNumberViewDelegate>
@property (nonatomic, strong) SelectGoodsNumberView *selectGoodsNumberView;
@property (nonatomic, strong) GoodsDetailInfo *detailInfo;
@property (nonatomic, strong) GoodsFightModel *model;

@end

@implementation SelectGoodsNumViewController

- (void)dealloc
{
    MLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureSelectGoodsNumberView];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureSelectGoodsNumberView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectGoodsNumberView" owner:nil options:nil];
    SelectGoodsNumberView *view = [nib firstObject];
    if (_model) {
        view.model = _model;
    } else {
        view.detailInfo = _detailInfo;
    }
    view.delegate = self;

    [self.view addSubview:view];
    _selectGoodsNumberView = view;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SelectGoodsNumberView *view = _selectGoodsNumberView;
    
    view.width = self.view.width;
    view.bottom = self.view.height;
//    view.buyNum = _buyNum;
    
}


- (void)reloadWithGoodsFightModel:(GoodsFightModel *)model
{
    _model = model;
    _selectGoodsNumberView.model = model;
}

- (void)reloadDetailInfoOnce:(GoodsDetailInfo *)detailInfo
{
    _detailInfo = detailInfo;
    [self httpGetGoodsDetailInfo];
}

- (void)setDetailInfo:(GoodsDetailInfo *)detailInfo
{
    _detailInfo = detailInfo;
    _selectGoodsNumberView.detailInfo = detailInfo;
}

- (IBAction)backgroundTapGesture:(id)sender
{
    [Tool hideAllKeyboard];
    
    [self cancelPurchase];
}

#pragma mark - SelectGoodsNumberViewDelegate

- (void)didSelectPurchaseNumber:(int)purchaseNumber
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_model) {
            
            if([self.delegate respondsToSelector:@selector(selectGoodsNum:goodsFightModel:)])
            {
                [self.delegate selectGoodsNum:purchaseNumber goodsFightModel:_model];
            }
        } else {
            
            if([self.delegate respondsToSelector:@selector(selectGoodsNum:goodsInfo:)])
            {
                [self.delegate selectGoodsNum:purchaseNumber goodsInfo:_detailInfo];
            }
        }
    }];
}

- (void)cancelPurchase
{
    [_selectGoodsNumberView dismissAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 
- (void)httpGetGoodsDetailInfo
{
    NSString *userIdStr = nil;
    if ([ShareManager shareInstance].userinfo.islogin) {
        userIdStr = [ShareManager shareInstance].userinfo.id;
    }
//    HttpHelper *helper = [HttpHelper helper];
    __weak typeof(self) weakSelf = self;
    [HttpHelper loadGoodsDetailInfoWithGoodsId:_detailInfo.id
                                    userId:userIdStr
                                   success:^(NSDictionary *resultDic){
                                       if ([[resultDic objectForKey:@"status"] integerValue] == 0) {
                                           NSDictionary *dic = [resultDic objectForKey:@"data"];
                                           
                                           GoodsDetailInfo *object = [[dic objectForKey:@"goodsFightMap"] objectByClass:[GoodsDetailInfo class]];
                                           object.buyNum = weakSelf.detailInfo.buyNum;
                                           weakSelf.detailInfo = object;
                                       }else
                                       {
                                           [Tool showPromptContent:[resultDic objectForKey:@"desc"] onView:self.view];
                                       }
                                       
                                   }fail:^(NSString *decretion){
                                       [Tool showPromptContent:@"网络出错了" onView:self.view];
                                   }];
}

@end
