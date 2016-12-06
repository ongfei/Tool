//
//  UITextField+DyfAdd.m
//  MyTool
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "UITextField+DyfAdd.h"

@implementation UITextField (DyfAdd)
- (instancetype)customWithFrame:(CGRect)frame andLeftTitle:(NSString *)leftT andPlaceH:(NSString *)placeho {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 100, frame.size.height - 20)];
    label.text = leftT;
    label.textColor = [UIColor colorWithRed:0.4353 green:0.4353 blue:0.4353 alpha:1.0];
    label.font = [UIFont systemFontOfSize:15];
    UITextField *textF = [[UITextField alloc] initWithFrame:frame];
    textF.leftViewMode = UITextFieldViewModeAlways;
    textF.layer.borderWidth = 0;
    textF.leftView = label;
    textF.placeholder = placeho;
    textF.clearButtonMode = UITextFieldViewModeWhileEditing;
    textF.font = [UIFont systemFontOfSize:13];
    [self addLineWithUI:textF andFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1) andColor:[UIColor colorWithRed:0.7019 green:0.7019 blue:0.7019 alpha:1.0]];
    return textF;
}


- (void)addLineWithUI:(UIView *)UIv andFrame:(CGRect)frame andColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = frame;
    [UIv addSubview:view];
}

@end
