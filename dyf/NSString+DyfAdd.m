//
//  NSString+DyfAdd.m
//  MyTool
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "NSString+DyfAdd.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+YYAdd.h"

@implementation NSString (DyfAdd)
+ (NSInteger) decimalwithFormat:(NSString *)format  floatV:(float)floatV {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [[numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]] integerValue];
}

- (BOOL)isNull {
    if ([self isEqual:[NSNull null]] || [self isEqualToString:@""] || [self isEqualToString:@"null"] || [self isEqualToString:@"<null>"] || self == nil) {
        return YES;
    }else {
        return NO;
    }
}

- (NSString *)md5 {
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (unsigned int)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
    
}


- (NSAttributedString *)attributedTextWithImage:(NSString *)image {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self attributes:nil];
    //进行图文混排
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    textAttachment.image = [UIImage imageNamed:image];
    textAttachment.bounds = CGRectMake(0, 0, 12,10);
    NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment ];
    [string insertAttributedString:textAttachmentString atIndex:0];
    return string;
    
}


- (NSAttributedString *)attributedStr {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleThick) range:NSMakeRange(0, [self length])];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, [self length])];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, 0)];
    return attri;
}

+ (NSString *)stringWithTimelineDate:(NSDate *)date {
    if (!date) return @"";
    
    static NSDateFormatter *formatterYesterday;
    static NSDateFormatter *formatterSameYear;
    static NSDateFormatter *formatterFullDate;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatterYesterday = [[NSDateFormatter alloc] init];
        [formatterYesterday setDateFormat:@"昨天 HH:mm"];
        [formatterYesterday setLocale:[NSLocale currentLocale]];
        
        formatterSameYear = [[NSDateFormatter alloc] init];
        [formatterSameYear setDateFormat:@"M-d"];
        [formatterSameYear setLocale:[NSLocale currentLocale]];
        
        formatterFullDate = [[NSDateFormatter alloc] init];
        [formatterFullDate setDateFormat:@"yy-M-dd"];
        [formatterFullDate setLocale:[NSLocale currentLocale]];
    });
    
    NSDate *now = [NSDate new];
    NSTimeInterval delta = now.timeIntervalSince1970 - date.timeIntervalSince1970;
    if (delta < -60 * 10) { // 本地时间有问题
        return [formatterFullDate stringFromDate:date];
    } else if (delta < 60 * 10) { // 10分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%d分钟前", (int)(delta / 60.0)];
    } else if (date.isToday) {
        return [NSString stringWithFormat:@"%d小时前", (int)(delta / 60.0 / 60.0)];
    } else if (date.isYesterday) {
        return [formatterYesterday stringFromDate:date];
    } else if (date.year == now.year) {
        return [formatterSameYear stringFromDate:date];
    } else {
        return [formatterFullDate stringFromDate:date];
    }
}

+ (NSString *)stringWithInterge:(NSInteger)interger {
    return [NSString stringWithFormat:@"%ld",interger];
}

- (float)stringHeightWithsize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    
    float height = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height);
}

-(CGFloat)getWidthWithfont:(CGFloat)f {
    
    UIFont * font = [UIFont systemFontOfSize:f];
    CGSize size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat w = size.width;
    
    return w;
}

- (NSString *)forwordDayOrBehindDayWithState:(BOOL)state {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[formatter dateFromString:self]];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    //    [adcomps setYear:0];
    //    [adcomps setMonth:-1];
    //    [adcomps setDay:0];
    if (state) {
        [adcomps setDay:1];
    }else {
        [adcomps setDay:-1];
    }
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[formatter dateFromString:self] options:0];
    return [formatter stringFromDate:newdate];
}

- (NSString *)formatDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:[formatter dateFromString:self]];
}

+ (NSString *)formatDateWithDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end
