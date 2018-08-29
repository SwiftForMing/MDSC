//
//  CalerderViewController.m
//  CalendarTest
//
//  Created by 吕亚斌 on 2018/4/8.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import "CalerderViewController.h"
#import "FSCalendar.h"
#import "LVCalendarCell.h"
#import "UIColor+Hex.h"
static NSString *const cellID = @"cell";
static NSString *const dateFormatterType = @"yyyy/MM/dd";
@interface CalerderViewController ()<FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) FSCalendar *calendarl;
@property (nonatomic, strong) NSCalendar *gregorian;
@end

@implementation CalerderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"日历";
    [self.view addSubview:self.calendarl];
    self.calendarl.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    [self initDeaultsInfo];
}
- (void)initDeaultsInfo{
    if (self.startDate) {
        self.startTime = [self.dateFormatter stringFromDate:self.startDate];
    }
    if (self.endDate) {
        self.endTime = [self.dateFormatter stringFromDate:self.endDate];
    }
    //如果返程日期小于去程。则返程设置为和去程同一天
    if ([self.endDate compare:self.startDate] == NSOrderedAscending) {
        self.endDate = self.startDate;
    }
}

#pragma mark --FSCalendarDataSource
//最小时间
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [NSDate date];
}
//最大时间
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitYear value:1 toDate:[NSDate date] options:NSCalendarWrapComponents];
}
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
    if ([self.gregorian isDateInToday:date]) {
        return @"今天";
    }
    return nil;
}
- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    //先判断 如果去程和返程时同一天
    if ([self.startTime isEqualToString:self.endTime] && [self.startTime isEqualToString:[self.dateFormatter stringFromDate:date]]) {
        return @"去/返程";
    }
    if (self.startDate && [self.startTime isEqualToString:[self.dateFormatter stringFromDate:date]]) {
        return @"去程";
    }
    if (self.endDate && [self.endTime isEqualToString:[self.dateFormatter stringFromDate:date]]){
        return @"返程";
    }
    return nil;
}
- (__kindof FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position{
    LVCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:cellID forDate:date atMonthPosition:position];
    return cell;
}
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    [self configure:cell date:date position:monthPosition];
}
#pragma mark --FSCalendarDelegate
//是否可以选择时间
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    return monthPosition = FSCalendarMonthPositionCurrent;
}
//选择了时间
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    NSLog(@"选择的时间 %@",[self.dateFormatter stringFromDate:date]);
    
    if (self.isEnd) {
        //如果选择的返程日期小于去程日期。重新选择去程日期
        if ([date compare:[self.dateFormatter dateFromString:self.startTime]] == NSOrderedAscending){
            self.startDate = date;
            self.startTime = [self.dateFormatter stringFromDate:date];
            [calendar reloadData];
            return;
        }
        //返程
        self.endDate = date;
        self.endTime = [self.dateFormatter stringFromDate:date];
    }else{
        if ([date compare:[self.dateFormatter dateFromString:self.endTime]] == NSOrderedDescending){
            self.endDate = date;
            self.endTime = [self.dateFormatter stringFromDate:date];
        }
        self.startDate = date;
        self.startTime = [self.dateFormatter stringFromDate:date];
    }
    if (self.selectedCalendarBlock) {
        self.selectedCalendarBlock(self.startTime, self.startDate, self.endTime, self.endDate, self.isArive);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//是否可以取消选择时间
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    if ([self.gregorian isDateInToday:date]) {
        return NO;
    }
    return YES;
}
//取消了选择的时间
//- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
//    NSLog(@"取消选择的时间 %@",[self.dateFormatter stringFromDate:date]);
//}
#pragma mark --FSCalendarDelegateAppearance
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date{
//    //如果
//    if ([self.gregorian isDateInToday:date]) {
//        return [UIColor orangeColor];
//    }
//    return appearance.eventDefaultColor;
//}
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date{
//    return [UIColor whiteColor];
//}
- (nullable NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date{
//    if ([self.gregorian isDateInToday:date]) {
//        return @[[UIColor redColor]];
//    }
    return @[appearance.eventSelectionColor];
}
- (nullable NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor redColor]];
    }
    return @[appearance.eventDefaultColor];
}
#pragma mark --cell
- (void)configure:(FSCalendarCell *)cell date:(NSDate *)date position:(FSCalendarMonthPosition)position{
    LVCalendarCell *rangeCell = (LVCalendarCell *)cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.middleLayer.hidden = YES;
        rangeCell.selectionLayer.hidden = YES;
        return;
    }
    if (self.startTime && self.endTime) {
        BOOL isMiddle = [date compare:[self.dateFormatter dateFromString:self.startTime]] == NSOrderedDescending && [date compare:[self.dateFormatter dateFromString:self.endTime]] == NSOrderedAscending;
        rangeCell.middleLayer.hidden = !isMiddle;
    }else{
        rangeCell.middleLayer.hidden = YES;
    }
    BOOL isStart = [self.dateFormatter dateFromString:self.startTime] != nil && [self.gregorian isDate:date inSameDayAsDate:[self.dateFormatter dateFromString:self.startTime]];
    BOOL isEnd = [self.dateFormatter dateFromString:self.endTime] != nil && [self.gregorian isDate:date inSameDayAsDate:[self.dateFormatter dateFromString:self.endTime]];
    rangeCell.selectionLayer.hidden = !isEnd && !isStart;
}
#pragma mark --getter
- (NSCalendar *)gregorian{
    if (!_gregorian) {
        _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}
- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = dateFormatterType;
        return _dateFormatter;
    }
    return _dateFormatter;
}
- (FSCalendar *)calendarl{
    if (!_calendarl) {
        _calendarl = [[FSCalendar alloc] init];
        _calendarl.dataSource = self;
        _calendarl.delegate = self;
        _calendarl.backgroundColor = [UIColor whiteColor];
        _calendarl.scrollDirection = UICollectionViewScrollDirectionVertical;
        _calendarl.allowsMultipleSelection = YES;
        _calendarl.placeholderType = FSCalendarPlaceholderTypeNone;
        // 不分页显示
        _calendarl.pagingEnabled = NO;
        [_calendarl appearance].headerTitleColor = [UIColor blackColor];
        [_calendarl appearance].weekdayTextColor = [UIColor blackColor];
        [_calendarl appearance].borderRadius = 0;
        // 日期是周末的
        [_calendarl appearance].titleWeekendColor = [UIColor redColor];
        // 选择的颜色
        [_calendarl appearance].headerDateFormat = @"yyyy年MM月";
        [_calendarl appearance].todayColor = [UIColor whiteColor];
        [_calendarl appearance].titleTodayColor = [UIColor blackColor];
        [_calendarl appearance].selectionColor = [UIColor colorWithHexString:@"#29B5EB"];
//        _calendarl.firstWeekday = 0;
        _calendarl.calendarHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];

        [_calendarl registerClass:[LVCalendarCell class] forCellReuseIdentifier:cellID];
        
        [_calendarl appearance].subtitleOffset = CGPointMake(0, 7);
    }
    return _calendarl;
}
//- (NSDate *)startDate{
//    if (!_startDate) {
//        //去程时间默认今天
//        _startDate = [NSDate date];
//    }
//    return _startDate;
//}
//- (NSDate *)endDate{
//    if (!_endDate) {
//        //默认两天后
//        _endDate = [self.gregorian dateByAddingUnit:NSCalendarUnitDay value:2 toDate:[NSDate date] options:NSCalendarWrapComponents];
//    }
//    return _endDate;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
