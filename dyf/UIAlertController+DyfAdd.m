//
//  UIAlertController+DyfAdd.m
//  MyTool
//
//  Created by SINOKJ on 16/6/13.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import "UIAlertController+DyfAdd.h"

@implementation UIAlertController (DyfAdd)
//确定取消
+ (void)presentAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message andStyle:(UIAlertControllerStyle)style andClass:(UIViewController *)cls andSureBlock:(void (^)())sureBlock andCancleBlock:(void (^)())cancleBlock {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(style)];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        sureBlock();
    }];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        cancleBlock();
    }];
    [alertC addAction:actionSure];
    [alertC addAction:actionCancle];
    [cls presentViewController:alertC animated:YES completion:^{
        
    }];
}
//确定
+ (void)presentAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message andStyle:(UIAlertControllerStyle)style andClass:(UIViewController *)cls andSureBlock:(void (^)())sureBlock {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(style)];
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        sureBlock();
    }];
    [alertC addAction:actionSure];
    [cls presentViewController:alertC animated:YES completion:^{
        
    }];
}
//action多个
+ (void)presentAlertControllerWithTitle:(NSString *)title andMessage:(NSString *)message andStyle:(UIAlertControllerStyle)style andClass:(UIViewController *)cls andBlock:(void (^)(NSInteger index))block andAction:(NSString *)actionT, ... {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(style)];
    //遍历不确定参数
    va_list argList;
    if (actionT) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionT style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }];
        [alertC addAction:action];
        
        va_start(argList, actionT);
        NSString *arg = va_arg(argList, id);
        NSInteger i = 1;
        while (arg) {
           UIAlertAction *action = [UIAlertAction actionWithTitle:arg style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                block(i);
            }];
            i++;
            [alertC addAction:action];
            arg = va_arg(argList, id);
        }
        va_end(argList);
    }
    
    [cls presentViewController:alertC animated:YES completion:^{
        
    }];
}
@end
