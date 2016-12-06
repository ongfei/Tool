//
//  UITextField+DyfAdd.h
//  MyTool
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (DyfAdd)
/**
 *  带下划线的textFiled
 *
 */
- (instancetype)customWithFrame:(CGRect)frame andLeftTitle:(NSString *)leftT andPlaceH:(NSString *)placeho;
@end
