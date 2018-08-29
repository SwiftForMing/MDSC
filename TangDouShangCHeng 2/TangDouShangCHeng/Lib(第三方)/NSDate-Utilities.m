/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej
*/

#import "NSDate-Utilities.h"

#define DATE_COMPONENTS (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (Utilities)

#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) && 
			([components1 day] == [components2 day]));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 week] != [components2 week]) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameYearAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameYearAsDate:newDate];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
	return ([components1 year] == [components2 year]);
}

- (BOOL) isThisYear
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self earlierDate:aDate] == self);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self laterDate:aDate] == self);
}


#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSUInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSUInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingHours: (NSUInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSUInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}

- (NSDate *) dateBySubtractingMinutes: (NSUInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) secondsAfterDate: (NSDate *) aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger) (ti);
}

- (NSInteger) secondsBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti);
}

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) yearsBeforeDate: (NSDate *) aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger) (ti / D_YEAR);
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
	return [components hour];
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components hour];
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components minute];
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components second];
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components day];
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components month];
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components week];
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekday];
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekdayOrdinal];
}
- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components year];
}

+(NSString*) remainTimeBetweenCurrentTime:(NSDate*)startTime And:(NSDate*)endTime
{
//    // 计算举例下次活动的时间
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];		
//    NSDateComponents *comps;
//    NSInteger unitFlags =  NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    //NSDate* nextTimeDate = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNextScratchTime];
//    comps = [calendar components:unitFlags fromDate:startTime toDate:endTime options:0];
//	
//    int hou = [comps hour];
//    int min = [comps minute];
//    int sec = [comps second];
//    NSString* text = [NSString stringWithFormat:@""];
//    if (hou) {
//        NSString* str;
//        if ([AppDelegate shared].isUserChineseLanguage) {
//            str = @"小时";
//        }else{
//            str = @"h";
//        }
//        text = [text stringByAppendingFormat:@"%d%@",hou,str];
//    }
//    if (min) {
//        NSString* str;
//        if ([MNAppDelegate shared].isUserChineseLanguage) {
//            str = @"分钟";
//        }else{
//            str = @"m";
//        }
//        text = [text stringByAppendingFormat:@"%d%@",min,str];
//    }
////    if (sec) {
////        
////    }
//    NSString* str;
//    if ([MNAppDelegate shared].isUserChineseLanguage) {
//        str = @"秒";
//    }else{
//        str = @"s";
//    }
//    text = [text stringByAppendingFormat:@"%d%@",sec,str];
//    return text;
    return nil;
}

+(NSString*) stringFormat:(NSDate*)date
{
    NSString* strRet = nil;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    strRet = [formatter stringFromDate:date];
    return strRet;
}

+ (NSString*)stringFormatMMMMd:(NSDate*)date
{
    NSString* strRet = nil;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d"];
    strRet = [formatter stringFromDate:date];
    return strRet;
}

+ (NSString*)stringFormatMMMMdyyyy:(NSDate*)date
{
    NSString* strRet = nil;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM d,yyyy"];
    strRet = [formatter stringFromDate:date];
    return strRet;
}

+ (NSString *)stringWithChinaFormat:(NSDate *)date{
    NSString *dateString = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)[date year],(long)[date month],(long)[date day]];
    return dateString;
}

+(NSString *)stringWithChinaHourFormat:(NSDate *)date{
    NSString *dateString = [NSString stringWithFormat:@"%ld年%ld月%ld日%ld时%ld分",(long)[date year],(long)[date month],(long)[date day],(long)[date hour],(long)[date minute]];
    return dateString;
}

+(NSString*) calendarStringFormat:(NSDate*)date
{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMdd"];
    NSString *calendarString = [dateformatter stringFromDate:date];
    
    return calendarString;
}

+ (NSInteger)serverTimeDifference:(long long)serverTime
{
    NSDate *serverDate = [NSDate dateWithTimeIntervalSince1970:serverTime * 0.001];
    MLog(@"server date = %@", serverDate);
    MLog(@"local date = %@", [NSDate date]);
    NSInteger difference = [serverDate secondsAfterDate:[NSDate date]];
    return difference;
}

+(NSDate *)dateWithTimeIntervalFromServer:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if (date.year > 2100) {
        timeInterval /= 1000.0f;
    }
    if (date.year < 1990) {
        timeInterval *= 1000.0f;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSString *)calculateCountdownTimeString:(NSDate *)destDate
{
    NSTimeInterval destTimeInterval = [destDate timeIntervalSince1970];
    NSTimeInterval nowTimeSeconds = [[NSDate date] timeIntervalSince1970];
    
    long long oneMin = 60;
    long long oneHour = oneMin*60;
    long long oneDay = oneHour*24;
    long long oneWeek = oneDay*7;
    long long subSeconds = nowTimeSeconds - destTimeInterval;
    if (subSeconds < 0) {//服务器和客户端有时间差，当差为负数时，显示为0
        subSeconds = 0;
    }
    NSString* time = nil;
    if (subSeconds < oneHour) {//小于1小时
        time = [NSString stringWithFormat:@"%lldm",subSeconds/oneMin == 0 ? 1:subSeconds/oneMin];
    } else if ((oneHour <= subSeconds) && (subSeconds < oneDay)) {//小于1天
        time = [NSString stringWithFormat:@"%lldh", subSeconds/oneHour];
    } else if ((oneDay <= subSeconds) && (subSeconds < oneWeek)) {//小于1周
        time = [NSString stringWithFormat:@"%lldd", subSeconds/oneDay];
    } else if ((oneWeek <= subSeconds) && (subSeconds < oneWeek*4)) {//小于4周
        time = [NSString stringWithFormat:@"%lldw", subSeconds/oneWeek];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        time = [formatter stringFromDate:destDate];
    }
    
    return time;
}

+ (NSString *)calculateTimeString:(NSDate *)destDate
{
    NSTimeInterval destTimeInterval = [destDate timeIntervalSince1970];
    NSTimeInterval nowTimeSeconds = [[NSDate date] timeIntervalSince1970];
    
    long long oneMin = 60;
    long long oneHour = oneMin*60;
    long long oneDay = oneHour*24;
    long long oneWeek = oneDay*7;
    long long subSeconds = nowTimeSeconds - destTimeInterval;
    if (subSeconds < 0) {//服务器和客户端有时间差，当差为负数时，显示为0
        subSeconds = 0;
    }
    NSString* time = nil;
    if (subSeconds < oneDay) {//小于1天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy年MM月dd HH:mm"];
        
        time = [formatter stringFromDate:destDate];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy年MM年dd"];
        
        time = [formatter stringFromDate:destDate];
    }
    
    return time;
}

+ (NSString *)calculateCountdownTimeString2:(NSDate *)destDate
{
    NSTimeInterval destTimeInterval = [destDate timeIntervalSince1970];
    NSTimeInterval nowTimeSeconds = [[NSDate date] timeIntervalSince1970];
    
    long long oneMin = 60;
    long long oneHour = oneMin*60;
    long long oneDay = oneHour*24;
    long long oneWeek = oneDay*7;
    long long subSeconds = nowTimeSeconds - destTimeInterval;
    if (subSeconds < 0) {//服务器和客户端有时间差，当差为负数时，显示为0
        subSeconds = 0;
    }
    NSString* time = nil;
    if (subSeconds < oneDay) {//小于1天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"HH:mm"];
        
        time = [formatter stringFromDate:destDate];
    } else if ((oneDay <= subSeconds) && (subSeconds < oneWeek)) {//小于1周
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"EEE"];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"MM-dd"];
        
        time = [formatter stringFromDate:destDate];
    }
    
    return time;
}

/**
 *  小于一年不显示年
 *
 *  Format1: yyyy-MM-dd HH:mm
 *  Format2: MM-dd HH:mm
 */
+ (NSString *)calculateTimeString1:(NSDate *)destDate
{
    NSString* time = nil;
    
    int year = [destDate yearsBeforeDate:[NSDate date]];
    
    if (year > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        time = [formatter stringFromDate:destDate];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        
        time = [formatter stringFromDate:destDate];
    }
    
    return time;
}


@end
