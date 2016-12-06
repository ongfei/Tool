//
//  DyfTimeTool.h
//  时间工具类
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DyfTimeTool : NSObject

+ (NSInteger)getCurrentWeek;

+ (NSInteger)getCurrentWeekDay;

+ (NSInteger)getCurrentYear;

+ (NSInteger)getCurrentMonth;

+ (NSString *)getCurrentInterval;

+ (NSInteger)getCurrentClass;

+ (int)dayNumberSinceDateWithFormat_yyyy_MM_dd:(NSString *)date;
/**
 *  获取几个月后的时间或者几个月前的时间
 *
 *  @param date  基准时间
 *  @param month 正数是以后n个月，负数是前n个月
 *
 *  @return 计算后的日期
 */
+(NSDate *)getLaterDateFromDate:(NSDate *)date withMonth:(int)month;

@end
