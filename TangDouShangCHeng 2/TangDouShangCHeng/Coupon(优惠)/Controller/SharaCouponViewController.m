//
//  SharaCouponViewController.m
//  TaoPiao
//
//  Created by 黎应明 on 2017/10/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "SharaCouponViewController.h"
#import "SharaCouponCell.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface SharaCouponViewController ()

@end

@implementation SharaCouponViewController{
    
    NSString *couponString;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转让";
     self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    couponString = @"";
    [self setHeaderWithMyTableView];
    
}

-(void)setHeaderWithMyTableView{
    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, ScreenWidth, 250))];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *url = [NSURL URLWithString:_couponModel.good_header];
    [headerImage sd_setImageWithURL:url placeholderImage:nil];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:(CGRectMake(20, 225, ScreenWidth-30, 20))];
     UILabel *lineLabel = [[UILabel alloc]initWithFrame:(CGRectMake(0, 249, ScreenWidth, 1))];
    lineLabel.backgroundColor = [UIColor colorFromHexString:@"7F7F7F"];
    
    titleLabel.text = _couponModel.coupons_name;
    titleLabel.textColor = [UIColor redColor];
//    [headerImage addSubview:lineLabel];
    [headerImage addSubview:titleLabel];
    
    self.tableView.tableHeaderView = headerImage;
}

-(void)setCouponModel:(CouponModel *)couponModel{
    _couponModel = couponModel;
    MLog(@"_couponModel%@",_couponModel.id);
    [self getCouponId];
    [self.tableView reloadData];
}

-(void)getCouponId{
    [HttpHelper getSharaCouponIDWithUserID:[ShareManager shareInstance].userinfo.id Coupons_secret:_couponModel.id success:^(NSDictionary *resultDic) {
        NSString *status = resultDic[@"status"];
        if ([status isEqualToString:@"0"]) {
          NSDictionary *dic = resultDic[@"data"];
          NSDictionary *shareCoupons =  dic[@"shareCoupons"];
            if (shareCoupons[@"id"]) {
                couponString = shareCoupons[@"id"];
                MLog(@"couponString%@",couponString);
            }
            
        }else{
            couponString = @"获取优惠券码失败";
        }
        [self.tableView reloadData];
    } fail:^(NSString *description) {
         couponString = @"获取优惠券码失败";
        [Tool showPromptContent:description onView:self.view];
         [self.tableView reloadData];
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

//创建并显示每行的内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SharaCouponCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SharaCouponCell"];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SharaCouponCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.lineLabel.hidden = YES;
        cell.titleLabel.text = @"兑换码:";
        cell.desLabel.text = [NSString stringWithFormat:@"%@",couponString];
        [cell.fzBtn whenTapped:^{
            NSString *link = [NSString stringWithFormat:@"%@",_couponModel.id];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = link;
            [Tool showPromptContent:@"复制成功"];
        }];
        cell.desLabel.textColor = [UIColor colorFromHexString:@"7F7F7F"];
    }
    if (indexPath.row == 1) {
         cell.lineLabel.hidden = NO;
        cell.titleLabel.text = @"有效期:";
        cell.fzBtn.hidden = YES;
        cell.desLabel.text = [NSString stringWithFormat:@"%@",@"五分钟内有效"];
        cell.desLabel.textColor = [UIColor colorFromHexString:@"7F7F7F"];
    }
    if (indexPath.row == 2) {
        cell.lineLabel.hidden = NO;
        cell.titleLabel.text = @"分享:";
        cell.desLabel.hidden = YES;
        cell.fzBtn.hidden = YES;
        cell.sharaView.hidden = NO;
        
        [cell.qqSharaImage whenTapped:^{
            
            [self sharaToQQ];
        }];
        
        [cell.weixinImage whenTapped:^{
            
            [self sharaToWX];
        }];
        
    }
    if (indexPath.row == 3) {
        cell.lineLabel.hidden = NO;
        cell.titleLabel.text = @"优惠券转让规则:";
        cell.fzBtn.hidden = YES;
        cell.desLabel.hidden = YES;
        cell.sharaView.hidden = YES;
        cell.rulerLabel.hidden = NO;
    }
    
    return cell;
    
}

-(void)sharaToQQ{
    
    if ([couponString isEqualToString:@"获取优惠券码失败"]) {
        [Tool showPromptContent:@"获取优惠券码失败" onView:self.view];
        return;
    }
    
    NSString *link = [NSString stringWithFormat:@"%@",_couponModel.id];
    NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"%@ - 最靠谱购物APP，0元购你所想！", bundleDisplayName];
    
    // 分享QQ好友
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    SSDKContentType shareType = SSDKContentTypeText;
    [shareParams SSDKSetupQQParamsByText:link
                                   title:str
                                     url:nil
                              thumbImage:nil
                                   image:@""
                                    type:shareType
                      forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeQQFriend //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state)
         {
             case SSDKResponseStateSuccess:
             {
                 //                                   if (completion) {
                 //                                       completion(state);
                 //                                   }
                 break;
             }
             case SSDKResponseStateFail:
             {
                 //                                   if (completion) {
                 //                                       completion(state);
                 //                                   }
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 //                                   if (completion) {
                 //                                       completion(state);
                 //                                   }
                 break;
             }
             default:
                 break;
         }
     }];
    
}

-(void)sharaToWX{
    if ([couponString isEqualToString:@"获取优惠券码失败"]) {
        [Tool showPromptContent:@"获取优惠券码失败" onView:self.view];
        return;
    }
    NSString *link = [NSString stringWithFormat:@"%@",_couponModel.id];
    NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = [NSString stringWithFormat:@"%@ - 最靠谱购物APP，0元购你所想！", bundleDisplayName];
    
    // 分享QQ好友
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    SSDKContentType shareType = SSDKContentTypeText;
    [shareParams SSDKSetupWeChatParamsByText:link
                                       title:str
                                         url:nil
                                  thumbImage:nil
                                       image:nil
                                musicFileURL:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil
                                        type:shareType
                          forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //2、分享
    [ShareSDK share:SSDKPlatformSubTypeWechatSession //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理....
         switch (state)
         {
             case SSDKResponseStateSuccess:
             {
                 //                                   if (completion) {
                 //                                       completion(state);
                 //                                   }
                 break;
             }
             case SSDKResponseStateFail:
             {
                 //                                   if (completion) {
                 //                                       completion(state);
                 //                                   }
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 //                                   if (completion) {
                 //                                       completion(state);
                 //                                   }
                 break;
             }
             default:
                 break;
         }
     }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 90;
    }
    if (indexPath.row == 1) {
        return 90;
    }
    if (indexPath.row == 2) {
        return 130;
    }
    if (indexPath.row == 3) {
        return 160;
    }else{
        return 100;
    }
    
}

@end
