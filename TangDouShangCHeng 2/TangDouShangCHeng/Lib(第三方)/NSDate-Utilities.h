/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Utilities)

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSUInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays;
- (NSDate *) dateByAddingHours: (NSUInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSUInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSUInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSUInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) secondsAfterDate: (NSDate *) aDate;
- (NSInteger) secondsBeforeDate: (NSDate *) aDate;
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger) yearsBeforeDate: (NSDate *) aDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

// 我的扩充
// 传入当前时间  以及  结束时间 返回一个 本地化好了  str 中文为：11小时20分钟5秒 应为为：11h20m5s
+(NSString*) remainTimeBetweenCurrentTime:(NSDate*)startTime And:(NSDate*)endTime;
// 把时间变成string形式 这个是我设置的默认格式 精确到毫秒 yyyy-MM-dd HH:mm:ss.FFF
+ (NSString*)stringFormat:(NSDate*)date;
+ (NSString*)stringFormatMMMMd:(NSDate*)date;
+ (NSString*)stringFormatMMMMdyyyy:(NSDate*)date;
+(NSString *)stringWithChinaFormat:(NSDate *)date;
+(NSString *)stringWithChinaHourFormat:(NSDate *)date;

// 检测服务器时间是否准确，可能会需要除以1000，可能不需要
+ (NSDate *)dateWithTimeIntervalFromServer:(NSTimeInterval)timeInterval;

//传入时间，得到"yyyyMMdd"格式的输出
+(NSString*) calendarStringFormat:(NSDate*)date;

// 5:30, 昨天，前天， 星期六， 一个月， 09－10
+ (NSString *)calculateCountdownTimeString:(NSDate *)destDate;

+ (NSString *)calculateCountdownTimeString2:(NSDate *)destDate;

// yyyy-MM-dd, 小于一天显示 2015年10月26日 11:20
+ (NSString *)calculateTimeString:(NSDate *)destDate;

/**
 *  小于一年不显示年
 *
 *  Format1: yyyy-MM-dd HH:mm
 *  Format2: MM-dd HH:mm
 */
+ (NSString *)calculateTimeString1:(NSDate *)destDate;

// 服务器时间 - 本地时间
+ (NSInteger)serverTimeDifference:(long long)serverTime;

@end
