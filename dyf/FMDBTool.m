//
//  LHDBTool.m
//  DBTool
//
//  Created by imac on 15/11/6.
//  Copyright © 2015年 common. All rights reserved.
//

#import "FMDBTool.h"

@implementation FMDBTool
#pragma mark -- 数据库操作
/**
 *  用文件名打开数据库文件，如果在Documents文件下没有这个文件，就会自动新建一个
 *
 *  @param dbFileName 数据库文件名
 *
 *  @return 打开的数据库操作Queue
 */
+ (FMDatabaseQueue *)openFMDBQWithName:(NSString *)dbFileName
{
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dbFileName];
    FMDatabaseQueue * DBQ = [FMDatabaseQueue databaseQueueWithPath:filePath];
    return DBQ;
}

/**
 *  关闭数据库连接
 *
 *  @param DBQ 要关闭连接的数据库
 */
+ (void)closeFMDBQ:(FMDatabaseQueue *)DBQ
{
    [DBQ close];
}

/**
 *  查找出数据库中所有的表名
 *  SQLite数据库中的信息存在于一个内置表sqlite_master中，在查询器中可以用select * from sqlite_master来查看，如果只要列出所有表名的话，则只要一个语句:SELECT name FROM sqlite_master WHERE type='table'
 *
 *  @param DBQ 数据库操作队列
 *
 *  @return 存放所有表名的数组
 */
+ (NSArray *)selectAllTableWith:(FMDatabaseQueue *)DBQ
{
    if (DBQ.openFlags) {
        //用于接收数据的数组
        __block NSMutableArray * resultArray = [NSMutableArray array];
        NSString * sqlStr = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table'"];
        
        [DBQ inDatabase:^(FMDatabase *db) {
            FMResultSet * set = [db executeQuery:sqlStr];
            int cols = set.columnCount;
            while (set.next) {
                for (int i = 0; i < cols; i ++) {
                    //                    NSString * colName = [set columnNameForIndex:i];
                    id colValue = [set objectForColumnIndex:i];
                    [resultArray addObject:colValue];
                }
            }
            //结果集使用完一定要关闭
            [set close];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return resultArray;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return nil;
    }
}

#pragma mark -- 表操作
/**
 *  创建表（eg：字典格式如下）
 *  NSMutableDictionary * dict = [NSMutableDictionary dictionary];
 *  dict[@"tableName"] = @"studentInfo"; //关键参数：表名
 *  dict[@"key"] = @"'SNo'"; //关键参数：主键
 *  dict[@"Sname"] = @"text"; //其他参数 参数名-数据库数据类型
 *  dict[@"SAge"] = @"integer";
 *  dict[@"SClass"] = @"integer";
 *
 *  @param DBQ        数据库连接
 *  @param dictionary 属性字典
 */
+ (BOOL)createTableWithDBQ:(FMDatabaseQueue *)DBQ
            TableAttribute:(NSDictionary *)dictionary
{
    if (DBQ.openFlags) {
        __block BOOL isOk = NO;
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        
        [DBQ inDatabase:^(FMDatabase *db) {
            NSMutableString * sqlStr = [NSMutableString string];
            //创建的表名
            [sqlStr appendString:[NSString stringWithFormat:@"CREATE TABLE %@",dict[@"tableName"]]];
            //开始拼接参数
            [sqlStr appendString:[NSString stringWithFormat:@"("]];
            //主键
            [sqlStr appendString:[NSString stringWithFormat:@"%@ INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT",dict[@"key"]]];
            //其他列名
            [dict removeObjectForKey:@"tableName"];
            [dict removeObjectForKey:@"key"];
            for (NSString * str in dict) {
                [sqlStr appendString:[NSString stringWithFormat:@",'%@' %@",str,dict[str]]];
            }
            //结束参数拼接
            [sqlStr appendString:@")"];
            
            isOk = [db executeUpdate:sqlStr];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return isOk;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
}

/**
 *  删除数据库中的一个表
 *
 *  @param DBQ       数据库操作队列
 *  @param tableName 要删除的表名
 *
 *  @return 是否删除成功
 */
+ (BOOL)dropTableWithDBQ:(FMDatabaseQueue *)DBQ
            TableName:(NSString *)tableName
{
    if (DBQ.openFlags) {
        __block BOOL isOk = NO;
        
        [DBQ inDatabase:^(FMDatabase *db) {
            
            NSString * sqlStr = [NSString stringWithFormat:@"DROP TABLE %@",tableName ];
            
            isOk = [db executeUpdate:sqlStr];
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return isOk;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
}

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
                   Attribute:(NSDictionary *)dictionary
{
    __block BOOL isOk = NO;
    if (DBQ.openFlags) {
        
        NSMutableString * sqlStr = [NSMutableString string];
        
        NSArray * allkeys = [[dictionary allKeys]sortedArrayUsingSelector:@selector(compare:)];
        //确定要插入数据的表
        [sqlStr appendString:[NSString stringWithFormat:@"insert into %@",tableName]];
        //拼接数据
        [sqlStr appendString:@"("];
        for (NSString * key in allkeys) {
            [sqlStr appendString:[NSString stringWithFormat:@"%@,",key]];
        }
        sqlStr = [NSMutableString stringWithString:[sqlStr substringWithRange:NSMakeRange(0, sqlStr.length - 1)]];
        [sqlStr appendString:@")"];
        [sqlStr appendString:@"values"];
        
        [sqlStr appendString:@"("];
        for (NSString * key in allkeys) {
            [sqlStr appendString:[NSString stringWithFormat:@"%@,",dictionary[key]]];
        }
        sqlStr = [NSMutableString stringWithString:[sqlStr substringWithRange:NSMakeRange(0, sqlStr.length - 1)]];
        [sqlStr appendString:@")"];

        
        [DBQ inDatabase:^(FMDatabase *db) {
            isOk = [db executeUpdate:sqlStr];
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return isOk;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
    
}

/**
 *  查询一个表中的所有数据返回数据数组，数组存放每一行对应字典
 *
 *  @param DBQ       数据库操作队列
 *  @param tableName 要查询的表名
 *
 *  @return 结果数组
 */
+ (NSArray *)selectedAllDataWithDBQ:(FMDatabaseQueue *)DBQ
                         Table:(NSString *)tableName
{
    if (DBQ.openFlags) {
        //用于接收数据的数组
        __block NSMutableArray * resultArray = [NSMutableArray array];
        NSMutableString * sqlStr = [NSMutableString string];
        [sqlStr appendString:[NSString stringWithFormat:@"select * from %@",tableName]];
        [DBQ inDatabase:^(FMDatabase *db) {
            FMResultSet * set = [db executeQuery:sqlStr];
            int cols = set.columnCount;
            while (set.next) {                
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                for (int i = 0; i < cols; i ++) {
                    NSString * colName = [set columnNameForIndex:i];
                    id colValue = [set objectForColumnIndex:i];
                    dict[colName] = colValue;
                }
                [resultArray addObject:dict];
            }
            //结果集使用完一定要关闭
            [set close];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return resultArray;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return nil;
    }
}

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
                     Table1Value:(id)value
{
    if (DBQ.openFlags) {
        //用于接收数据的数组
        __block NSMutableArray * resultArray = [NSMutableArray array];
        NSMutableString * sqlStr = [NSMutableString string];
        [sqlStr appendString:[NSString stringWithFormat:@"select * from %@ as t1 , %@ as t2 where t1.%@ = t2.%@ and t1.%@ = %@",tableName1,tableName2,key1,key2,key1,value]];

        [DBQ inDatabase:^(FMDatabase *db) {
            FMResultSet * set = [db executeQuery:sqlStr];
            int cols = set.columnCount;
            while (set.next) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                for (int i = 0; i < cols; i ++) {
                    NSString * colName = [set columnNameForIndex:i];
                    id colValue = [set objectForColumnIndex:i];
                    dict[colName] = colValue;
                }
                [resultArray addObject:dict];
            }
            //结果集使用完一定要关闭
            [set close];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return resultArray;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return nil;
    }
}

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
            password:(NSString *)password
{
    __block BOOL isOk = NO;
    if (DBQ.openFlags) {
        
        [DBQ inDatabase:^(FMDatabase *db) {
            
            NSMutableString * sqlStr = [NSMutableString stringWithFormat:@"select * from %@ where %@ = ? and %@ = ?",tableName,userNameColName,passwrodColName];
            FMResultSet * set = [db executeQuery:sqlStr,userName,password];
            if (set.next) {
                isOk = YES;
            }
            [set close];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return isOk;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
}

/**
 *  更新数据
 *
 *  @param DBQ        数据库操作队列
 *  @param tableName  表名
 *  @param dictionary 属性字典：（格式如下）
 *  NSMutableDictionary * dict = [NSMutableDictionary dictionary];
 *  dict[@"flag"] = @"SNo"; //关键参数，要修改行的唯一标示列名（主键）
 *  dict[@"flagValue"] = @1; //关键参数，要修改行的唯一标示列名对应的值（主键对应的值）
 *  dict[@"Sname"] = @"'张珊珊'"; //要修改的列名和对应的value 字符串用‘’引起来
 *  dict[@"SClass"] = @4; //数字类转化成NSNumber
 *
 *  @return 是否修改成功
 */
+ (BOOL)updateWithDBQ:(FMDatabaseQueue *)DBQ
                Table:(NSString *)tableName
           Auttribute:(NSDictionary *)dictionary
{
    __block BOOL isOk = NO;
    if (DBQ.openFlags) {
        //UPDATE  studentInfo SET Sname = '张三2' where Sno = 1;
        NSMutableString * sqlStr = [NSMutableString string];
        //确定修改的表
        [sqlStr appendString:[NSString stringWithFormat:@"update %@ set ",tableName]];
        //拼接参数
        for (NSString * key in dictionary) {
            if ([key isEqualToString:@"flag"]) {
                continue;
            }
            if ([key isEqualToString:@"flagValue"]) {
                continue;
            }
            [sqlStr appendString:[NSString stringWithFormat:@"%@ = %@,",key,dictionary[key]]];
        }
        sqlStr =[NSMutableString stringWithString:[sqlStr substringWithRange:NSMakeRange(0, sqlStr.length - 1)]];
        [sqlStr appendString:[NSString stringWithFormat:@" where %@ = %@",dictionary[@"flag"],dictionary[@"flagValue"]]];

        [DBQ inDatabase:^(FMDatabase *db) {
            isOk = [db executeUpdate:sqlStr];
        }];

    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (DBQ.openFlags){
            [DBQ close];
        }
    });
    return isOk;
}

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
             WhereStr:(NSString *)whereStr
{
    __block BOOL isOk = NO;
    if (DBQ.openFlags) {
        //UPDATE  studentInfo SET Sname = '张三2' where Sno = 1;
        NSMutableString * sqlStr = [NSMutableString string];
        //确定修改的表
        [sqlStr appendString:[NSString stringWithFormat:@"update %@ set ",tableName]];
        for (int i = 0 ; i < colNames.count ; i ++) {
            if (i == colNames.count -1) {
                [sqlStr appendFormat:@"%@ = %@ ",colNames[i],colValues[i]];
                continue;
            }
            [sqlStr appendFormat:@"%@ = %@ ,",colNames[i],colValues[i]];
        }
        [sqlStr appendFormat:@" where %@",whereStr];

        [DBQ inDatabase:^(FMDatabase *db) {
            isOk = [db executeUpdate:sqlStr];
        }];
        
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (DBQ.openFlags){
            [DBQ close];
        }
    });
    return isOk;
}


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
         FlagColValue:(id)flagColValue
{
    __block BOOL isOk = YES;
    if (DBQ.openFlags) {
       
        NSString * selectStr = [NSString stringWithFormat:@"select * from %@ where %@ = %@",tableName,flagColName,flagColValue];
        [DBQ inDatabase:^(FMDatabase *db) {
            FMResultSet * set = [db executeQuery:selectStr];
            if (!set.next) {
                isOk = NO;
                NSLog(@"数据库中没有找到相应的数据");
            }
            [set close];
        }];
        
        if (isOk == YES) {
            NSString * sqlStr = [NSString stringWithFormat:@"delete from %@ where %@ = %@",tableName,flagColName,flagColValue];
            [DBQ inDatabase:^(FMDatabase *db) {
                isOk = [db executeUpdate:sqlStr];
            }];
        }
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return NO;
    }
    return isOk;
}


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
                              WithDBQ:(FMDatabaseQueue *)DBQ

{
    if (DBQ.openFlags) {
        //用于接收数据的数组
        __block NSMutableArray * resultArray = [NSMutableArray array];
        NSMutableString * sqlStr = [NSMutableString string];
        [sqlStr appendString:[NSString stringWithFormat:@"select "]];
        for (int i = 0 ; i < colNames.count; i++) {
            if (i == colNames.count - 1) {
                [sqlStr appendString:colNames[i]];
                continue;
            }
            [sqlStr appendFormat:@"%@ ,",colNames[i]];
        }
        [sqlStr appendFormat:@" from %@ where %@",tableName,whereStr];
        
        [DBQ inDatabase:^(FMDatabase *db) {
            FMResultSet * set = [db executeQuery:sqlStr];
            int cols = set.columnCount;
            while (set.next) {
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                for (int i = 0; i < cols; i ++) {
                    NSString * colName = [set columnNameForIndex:i];
                    id colValue = [set objectForColumnIndex:i];
                    dict[colName] = colValue;
                }
                [resultArray addObject:dict];
            }
            //结果集使用完一定要关闭
            [set close];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (DBQ.openFlags){
                [DBQ close];
            }
        });
        return resultArray;
    }else{
        NSLog(@"数据库没有成功连接,请创建数据库连接");
        return nil;
    }
}












@end
