//
//  UILabel+DyfAdd.m
//  MyTool
//
//  Created by SINOKJ on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "UILabel+DyfAdd.h"

@implementation UILabel (DyfAdd)

+(instancetype)CustomWithFontNumber:(NSInteger)fontN andSuperV:(UIView *)sView andIsAuto:(BOOL)isAuto andInteract:(BOOL)interact andAlign:(NSTextAlignment)align {
    
    UILabel *label = [UILabel new];
    
    label.font = [UIFont systemFontOfSize:fontN];
    
    [sView addSubview:label];
    
    if (isAuto) {
        
        label.numberOfLines = 0;
    }
    if (interact) {
        label.userInteractionEnabled = YES;
    }
    
    label.textAlignment = align;
    return label;
}

- (UILabel*)customWidthLabel:(CGRect)frame :(NSString*)title font:(CGFloat)f {
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:frame];
    nameLabel.text = title;
    nameLabel.font = [UIFont systemFontOfSize:f];
    [self addLineWithUI:nameLabel andFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1) andColor:[UIColor colorWithRed:0.7019 green:0.7019 blue:0.7019 alpha:1.0]];
    nameLabel.textColor = [UIColor colorWithRed:0.4353 green:0.4353 blue:0.4353 alpha:1.0];
    
    return nameLabel;
}

- (void)addLineWithUI:(UIView *)UIv andFrame:(CGRect)frame andColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = frame;
    [UIv addSubview:view];
}

- (CGFloat)getWidthWithfont:(CGFloat)f {
    UIFont * font = [UIFont systemFontOfSize:f];
    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat w = size.width;
    return w;
}
//增加下划线
-(void)addLine {
    
//    UIFont * font = [UIFont systemFontOfSize:f];
//    CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    NSUInteger length = [self.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleThick) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, 0)];
    [self setAttributedText:attri];
    
}
@end
