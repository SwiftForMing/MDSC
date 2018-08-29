//
//  LLSearchView.m
//  LLSearchView
//
//  Created by 王龙龙 on 2017/7/25.
//  Copyright © 2017年 王龙龙. All rights reserved.
//

#import "LLSearchView.h"

@interface LLSearchView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *historyArray;
@property (nonatomic, strong) UIView *searchHistoryView;
@property (nonatomic, strong) UIView *hotSearchView;

@end
@implementation LLSearchView

- (instancetype)initWithFrame:(CGRect)frame hotArray:(NSMutableArray *)hotArr historyArray:(NSMutableArray *)historyArr
{
    if (self = [super initWithFrame:frame]) {
        self.historyArray = historyArr;
        self.hotArray = hotArr;
        [self addSubview:self.searchHistoryView];
        [self addSubview:self.hotSearchView];
    }
    return self;
}


- (UIView *)hotSearchView
{
    if (!_hotSearchView) {
        self.hotSearchView = [self setViewWithOriginY:CGRectGetHeight(_searchHistoryView.frame) title:@"历史搜索" textArr:self.hotArray];
    }
    return _hotSearchView;
}


- (UIView *)searchHistoryView
{
    if (!_searchHistoryView) {
        if (_historyArray.count > 0) {
            self.searchHistoryView = [self setViewWithOriginY:0 title:@"热门搜索" textArr:self.historyArray];
        } else {
            self.searchHistoryView = [self setNoHistoryView];
        }
    }
    return _searchHistoryView;
}



- (UIView *)setViewWithOriginY:(CGFloat)riginY title:(NSString *)title textArr:(NSMutableArray *)textArr
{
    UIView *view = [[UIView alloc] init];
    CGFloat y = 10+40;
    CGFloat letfWidth = 20;
    if ([title isEqualToString:@"历史搜索"]) {
        y=10;
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        lineLabel.backgroundColor = [UIColor colorFromHexString:@"F8F6F6"];
        [view addSubview:lineLabel];
    }
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, ScreenWidth - 30 - 45, 30)];
    titleL.text = title;
    titleL.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    titleL.textColor = [UIColor colorFromHexString:@"333333"];
    titleL.textAlignment = NSTextAlignmentLeft;
    [view addSubview:titleL];
    
//    if ([title isEqualToString:@"热门搜索"]) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(ScreenWidth - 45, 10, 28, 30);
////        [btn setImage:[UIImage imageNamed:@"sort_recycle"] forState:UIControlStateNormal];
//        btn.layer.masksToBounds = true;
//        btn.layer.cornerRadius = 4;
//        [btn setBackgroundColor:[UIColor redColor]];
//        [btn addTarget:self action:@selector(clearnSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
////        [view addSubview:btn];
//    }
    
    
    for (int i = 0; i < textArr.count; i++) {
        NSString *text = textArr[i];
        CGFloat width = [self getWidthWithStr:text] + 30;
        if ([title isEqualToString:@"历史搜索"]) {
            width = ScreenWidth-40;
        }
        
        if (letfWidth + width + 20 >= ScreenWidth) {
            if (y >= 130 && [title isEqualToString:@"热门搜索"]) {
                [self removeTestDataWithTextArr:textArr index:i];
                break;
            }
            y += 40;
            letfWidth = 20;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(letfWidth, y, width, 30)];
        label.userInteractionEnabled = YES;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        label.text = text;
        label.textColor = KColor(111, 111, 111);
       
        if ([title isEqualToString:@"历史搜索"]) {
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
            label.backgroundColor = [UIColor whiteColor];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, width, 1)];
            lineLabel.backgroundColor = [UIColor colorFromHexString:@"F4F4F4"];
            [label addSubview:lineLabel];
        } else {
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 1;
            label.layer.cornerRadius = 4;
            label.layer.borderColor = [UIColor colorFromHexString:@"F2F2F3"].CGColor;
            label.backgroundColor = [UIColor colorFromHexString:@"F2F2F3"];
        }
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
       
        [view addSubview:label];
        letfWidth += width + 10;
    }
    view.frame = CGRectMake(0, riginY, ScreenWidth, y + 40);
    return view;
}


- (UIView *)setNoHistoryView
{
    UIView *historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth - 30, 30)];
    titleL.text = @"历史搜索";
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor blackColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    
    UILabel *notextL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleL.frame) + 10, 100, 20)];
    notextL.text = @"无搜索历史";
    notextL.font = [UIFont systemFontOfSize:12];
    notextL.textColor = [UIColor blackColor];
    notextL.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:titleL];
    [historyView addSubview:notextL];
    return historyView;
}

- (void)tagDidCLick:(UITapGestureRecognizer *)tap
{
    UILabel *label = (UILabel *)tap.view;
    if (self.tapAction) {
        self.tapAction(label.text);
    }
}

- (CGFloat)getWidthWithStr:(NSString *)text
{
    CGFloat width = [text boundingRectWithSize:CGSizeMake(ScreenWidth, 40) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size.width;
    return width;
}


- (void)clearnSearchHistory:(UIButton *)sender
{
    [self.searchHistoryView removeFromSuperview];
    self.searchHistoryView = [self setNoHistoryView];
    [_historyArray removeAllObjects];
    [NSKeyedArchiver archiveRootObject:_historyArray toFile:KHistorySearchPath];
    [self addSubview:self.searchHistoryView];
    CGRect frame = _hotSearchView.frame;
    frame.origin.y = CGRectGetHeight(_searchHistoryView.frame);
    _hotSearchView.frame = frame;
}

- (void)removeTestDataWithTextArr:(NSMutableArray *)testArr index:(int)index
{
    NSRange range = {index, testArr.count - index - 1};
    [testArr removeObjectsInRange:range];
    [NSKeyedArchiver archiveRootObject:testArr toFile:KHistorySearchPath];
}



@end
