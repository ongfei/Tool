//
//  DyfDeviceTool.h
//  获取系统版本等
//
//  Created by df on 16/6/12.
//  Copyright © 2016年 Dyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DyfDeviceTool : NSObject
/**
 *  获得设备型号
 */
+ (NSString *)getCurrentDeviceModel;

/**
 *  获得系统版本
 */
+ (NSString *)getCurrentSystemVersion;

/**
 *  获得软件版本
 */
+ (NSString *)getCurrentAppVersion;

/**
 *  获得build版本
 */
+ (NSString *)getCurrentAppBuild;
/**
 *  获取appstore中的版本号
 *
 *  @param appId appstore上的appId
 *  @param block appstore中的版本号
 */
+ (void)getAppStoreVersionWithAppId:(NSString *)appId andBlock:(void (^)(NSString *version))block;

@end
