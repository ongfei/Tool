//
//  DyfTimeTool.m
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "DyfTimeTool.h"

@implementation DyfTimeTool

+ (NSInteger)getCurrentWeek {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return [dateComponent weekOfYear];
}

+ (NSInteger)getCurrentWeekDay {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return [dateComponent weekday];
}

+ (NSInteger)getCurrentYear
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return [dateComponent year];
}

+ (NSInteger)getCurrentMonth
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return [dateComponent month];
}

+ (NSString *)getCurrentInterval
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    long hour = [dateComponent hour];
    if (hour>=0&&hour<4) {
        return @"凌晨";
    }else if (hour>=4&&hour<9){
        return @"早上";
    }else if (hour>=9&&hour<11){
        return @"上午";
    }else if (hour>=11&&hour<14){
        return @"中午";
    }else if (hour>=14&&hour<19){
        return @"下午";
    }else if (hour>=19&&hour<24){
        return @"晚上";
    }
    else return @"error";
}

+ (NSInteger)getCurrentClass {
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    long hour = [dateComponent hour];
    if (hour<8) {
        return 1;
    } else if (hour>=8&&hour<10) {
        return 2;
    } else if (hour>=10&&hour<14) {
        return 3;
    } else if (hour>=14&&hour<16) {
        return 4;
    } else if (hour>=16&&hour<19) {
        return 5;
    }
    else return 6;
}

+ (int)dayNumberSinceDateWithFormat_yyyy_MM_dd:(NSString *)date
{
    NSDateFormatter * dm = [[NSDateFormatter alloc]init];
    
    [dm setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * newdate = [dm dateFromString:date];
    
    NSTimeInterval reTime = [newdate timeIntervalSinceNow];
    
    int lastDay = (int)reTime/3600/24;
    return lastDay;
}

+(NSDate *)getLaterDateFromDate:(NSDate *)date withMonth:(int)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}
@end
