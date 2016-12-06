//
//  LHDBTool.h
//  DBTool
//
//  Created by imac on 15/11/6.
//  Copyright © 2015年 common. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface FMDBTool : NSObject

#pragma mark -- 数据库操作
/**
 *  用文件名打开数据库文件，如果在Documents文件下没有这个文件，就会自动新建一个
 *
 *  @param dbFileName 数据库文件名
 *
 *  @return 打开的数据库操作Queue
 */
+ (FMDatabaseQueue *)openFMDBQWithName:(NSString *)dbFileName;

/**
 *  关闭数据库连接
 *
 *  @param DBQ 要关闭连接的数据库
 */
+ (void)closeFMDBQ:(FMDatabaseQueue *)DBQ;

/**
 *  查找出数据库中所有的表明
 *
 *  @param DBQ 数据库操作队列
 *
 *  @return 存放所有表名的数组
 */
+ (NSArray *)selectAllTableWith:(FMDatabaseQueue *)DBQ;

#pragma mark -- 表操作
/**
 *  创建表（eg：字典格式如下）
 *  NSMutableDictionary * dict = [NSMutableDictionary dictionary];
 *  dict[@"tableName"] = @"studentInfo"; 关键参数：表名
 *  dict[@"key"] = @"'SNo'"; 关键参数：主键
 *  dict[@"Sname"] = @"text"; //其他参数 参数名-数据库数据类型
 *  dict[@"SAge"] = @"integer";
 *  dict[@"SClass"] = @"integer";
 *
 *  @param DBQ        数据库连接
 *  @param dictionary 属性字典
 *  @return 是否创建成功
 */
+ (BOOL)createTableWithDBQ:(FMDatabaseQueue *)DBQ
            TableAttribute:(NSDictionary *)dictionary;

/**
 *  删除数据库中的一个表
 *
 *  @param DBQ       数据库操作队列
 *  @param tableName 要删除的表名
 *
 *  @return 是否删除成功
 */
+ (BOOL)dropTableWithDBQ:(FMDatabaseQueue *)DBQ
               TableName:(NSString *)tableName;

#pragma mark -- 增删改查
/**
 *  向表中插入一条数据
 *
 *  @param DBQ        数据库操作队列
 *  @param tableName  表名
 *  @param dictionary 要插入的属性字典（格式如下）
 *  NSMutableDictionary * dict = [NSMutableDictionary dictionary];
 *  dict[@"SName"] = @"'李四'";//字符串需要用‘’
 *  dict[@"SAge"] = @11;//数字要用NSNumber类型
 *  dict[@"SClass"] = @2;
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertToTableWithDBQ:(FMDatabaseQueue *)DBQ
                   TableName:(NSString *)tableName
                   Attribute:(NSDictionary *)dictionary;

/**
 *  查询一个表中的所有数据返回数据数组，数组存放每一行对应字典
 *
 *  @param DBQ       数据库操作队列
 *  @param tableName 要查询的表名
 *
 *  @return 结果数组
 */
+ (NSArray *)selectedAllDataWithDBQ:(FMDatabaseQueue *)DBQ
                         Table:(NSString *)tableName;

/**
 *  两个表的链接查询，t1的主键外键关联t2的一个列
 *
 *  @param DBQ        数据库操作队列
 *  @param tableName1 t1 名称
 *  @param tableName2 t2 名称
 *  @param key1       t1 主键
 *  @param key2       t2 外键
 *  @param value      t1 主键对应的值
 *
 *  @return 结果数组
 */
+ (NSArray *)selectedDataWithDBQ:(FMDatabaseQueue *)DBQ
                          Table1:(NSString *)tableName1
                          Table2:(NSString *)tableName2
                       Table1key:(NSString *)key1
                Table2ForeignKey:(NSString *)key2
                     Table1Value:(id)value;

/**
 *  登陆验证
 *
 *  @param DBQ             数据库操作队列
 *  @param tableName       表名
 *  @param userNameColName 表中用户名对应的列名
 *  @param passwrodColName 表中密码对应的列名
 *  @param userName        用户名
 *  @param password        密码
 *
 *  @return 是否登陆成功
 */
+ (BOOL)loginWithDBQ:(FMDatabaseQueue *)DBQ
               Table:(NSString *)tableName
     userNameColName:(NSString *)userNameColName
     passwordColName:(NSString *)passwrodColName
            userName:(NSString *)userName
            password:(NSString *)password;

/**
 *  更新数据
 *
 *  @param DBQ        数据库操作队列
 *  @param tableName  表名
 *  @param dictionary 属性字典：（格式如下）
 *  NSMutableDictionary * dict = [NSMutableDictionary dictionary];
 *  dict[@"flag"] = @"SNo"; //关键参数，要修改行的唯一标示列名（主键）
 *  dict[@"flagValue"] = @1; //关键参数，要修改行的唯一标示列名对应的值（主键对应的值）
 *  dict[@"Sname"] = @"'张珊珊'"; //要修个的列名和对应的value 字符串用‘’引起来
 *  dict[@"SClass"] = @4; //数字类转化成NSNumber
 *
 *  @return 是否修改成功
 */
+ (BOOL)updateWithDBQ:(FMDatabaseQueue *)DBQ
                Table:(NSString *)tableName
           Auttribute:(NSDictionary *)dictionary;

/**
 *  删除一个数据
 *
 *  @param DBQ          数据库操作队列
 *  @param tableName    表名
 *  @param flagColName  数据的唯一标识列名（主键）
 *  @param flagColValue 数据的唯一标识列值 (主键值)
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteWithDBQ:(FMDatabaseQueue *)DBQ
                Table:(NSString *)tableName
          FlagColName:(NSString *)flagColName
         FlagColValue:(id)flagColValue;

/**
 *  查询一张表中指定的列数据
 *
 *  @param tableName 表名
 *  @param colNames  列名
 *  @param whereStr  查询条件 (sNo = 1 and sName = '张三')
 *  @param DBQ       数据库操作队列
 *
 *  @return 查询结果
 */
+ (NSArray *)selectedInTableTabelName:(NSString *)tableName
                              ColName:(NSArray *)colNames
                                Where:(NSString *)whereStr
                              WithDBQ:(FMDatabaseQueue *)DBQ;

/**
 *  按照条件更新数据
 *
 *  @param DBQ       数据库操作队列
 *  @param tableName 表名
 *  @param colNames  要更新的列名
 *  @param colValues 与列名对应的数据
 *  @param whereStr  条件
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateWithDBQ:(FMDatabaseQueue *)DBQ
                Table:(NSString *)tableName
              colName:(NSArray *)colNames
             colValue:(NSArray *)colValues
             WhereStr:(NSString *)whereStr;


@end
