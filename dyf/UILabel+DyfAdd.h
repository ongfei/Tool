//
//  UILabel+DyfAdd.h
//  MyTool
//
//  Created by SINOKJ on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DyfAdd)

+(instancetype)CustomWithFontNumber:(NSInteger)fontN andSuperV:(UIView *)sView andIsAuto:(BOOL)isAuto andInteract:(BOOL)interact andAlign:(NSTextAlignment)align;

/**
 *  带下划线的label
 */
- (UILabel*)customWidthLabel:(CGRect)frame :(NSString*)title font:(CGFloat)f;

/**
 *  得到label的宽度
 */
- (CGFloat)getWidthWithfont:(CGFloat)f;
/**
 *  增加下划线
 */
-(void)addLine;
@end
