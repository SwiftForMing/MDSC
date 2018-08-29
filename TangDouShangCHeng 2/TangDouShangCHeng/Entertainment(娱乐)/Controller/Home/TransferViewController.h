//
//  TransferViewController.h
//  DuoBao
//
//  Created by 黎应明 on 2017/7/25.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "BaseViewController.h"
#import "ZJRecordListInfo.h"

@protocol SendGoodDelegate // 代理传值方法
- (void)sendInfo:(ZJRecordListInfo *)info;

@end

@interface TransferViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) ZJRecordListInfo *goodInfo;
@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextView *numTextView;
@property (strong, nonatomic) NSString *order_type;
@property (strong, nonatomic) NSString *orders_id;
@end
