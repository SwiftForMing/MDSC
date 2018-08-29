//
//  CalerderViewController.h
//  CalendarTest
//
//  Created by 吕亚斌 on 2018/4/8.
//  Copyright © 2018年 吕亚斌. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^calendarBlock)(NSString *startTime,NSDate *startDate,NSString *endTime, NSDate *endDate, BOOL isSigleCalendar);
@interface CalerderViewController : UIViewController
@property (nonatomic, assign) BOOL isArive;//是否是往返 默认为no，即单程
@property (nonatomic, assign) BOOL isEnd;//往返程中是否修改开始 no则是修改去程 yes为返程 默认为no 即去程
@property (nonatomic, strong) NSDate *startDate;//去程时间
@property (nonatomic, strong) NSDate *endDate;//返程时间
@property (nonatomic, copy) calendarBlock selectedCalendarBlock;
@end
