//
//  NSString+DyfAdd.h
//  MyTool
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (DyfAdd)
/**
 *  四舍五入转整形
 *  egg:[self decimalwithFormat:@"0" floatV:2.2]
 */
+ (NSInteger) decimalwithFormat:(NSString *)format  floatV:(float)floatV;
/**
 *  判断字符串是否为空
 *
 *  @return 为空->yes
 */
- (BOOL)isNull;
/**
 *  方法功能：md5加密算法
 */
- (NSString*)md5;
/**
 *  图文混排
 */
- (NSAttributedString *)attributedTextWithImage:(NSString *)image;
/**
 *  增加删除线
 */
- (NSAttributedString *)attributedStr;
/**
 *  时间转成时间段字符串
 */
+ (NSString *)stringWithTimelineDate:(NSDate *)date;
/**
 *  整型转字符串
 */
+ (NSString *)stringWithInterge:(NSInteger)interger;

/**
 *  根据文字计算高度
 */
- (float)stringHeightWithsize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth;
/**
 *  返回宽度
 */
-(CGFloat)getWidthWithfont:(CGFloat)f;
/**
 *  NO前一天yes后一天
 *
 */
- (NSString *)forwordDayOrBehindDayWithState:(BOOL)state;

- (NSString *)formatDate;

+ (NSString *)formatDateWithDate:(NSDate *)date;

@end
