//
//  UITextView+DyfAdd.m
//  MyTool
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "UITextView+DyfAdd.h"

@implementation UITextView (DyfAdd)

- (void)setBorderColor:(UIColor *)color andRadius:(CGFloat)radius andWidth:(CGFloat)width {
    self.layer.borderColor = (__bridge CGColorRef _Nullable)(color);
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
}
@end
