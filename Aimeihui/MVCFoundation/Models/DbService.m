//
//  DbService.m
//  PaixieMall
//
//  Created by xhs on 14-12-9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "DbService.h"
#import "FMDatabase.h"

@implementation SQLBlock

- (id)initWithSQL:(NSString *)sql
{
    self = [super init];
    if (self) {
        self.sql = sql;
    }
    return self;
}

- (id)initWithSQL:(NSString *)sql withArguments:(NSArray *)arguments
{
    self = [super init];
    if (self) {
        self.sql = sql;
        self.arguments = arguments;
    }
    return self;
}

@end



@interface DbService()
{
    FMDatabase *db;
}

@end

@implementation DbService
/**
 @method initWithDbPath:
 @abstract 使用数据库文件路径构建对象
 @param dbPath 数据库文件路径
 */
- (id)initWithDbPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        db= [FMDatabase databaseWithPath:dbPath] ;
    }
    return self;
}

/**
 @method initWithDb:
 @abstract 使用数据库构造对象，该方法会检测${DOCUMENT_HOME}/DB/${dbFilename}数据库，
 如果未检测到数据库，则会将App中${dbFilename}资源拷贝到目标目录中
 @param dbFilename 数据库文件名
 */
- (id)initWithDb:(NSString *)dbFilename
{
    self = [super init];
    if (self) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0] ;
        
        NSString *documentsDirectory = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"DB"];
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(bo,@"创建目录失败");
        
        NSString *appDirectory = [[NSBundle mainBundle] bundlePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
   
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:dbFilename];

        if(![fileManager fileExistsAtPath:filePath]) //如果不存在
        {
            NSString *dataPath = [appDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",dbFilename]];//获取程序包中相应文件的路径
            NSError *error;
            [fileManager copyItemAtPath:dataPath toPath:filePath error:&error]; //拷贝
        }
        db= [FMDatabase databaseWithPath:filePath] ;
    }
    return self;
}

/**
 @method initWithDb:withDbFolder:
 @abstract 使用数据库构造对象，该方法会检测${DOCUMENT_HOME}/${dir}/${dbFilename}数据库，
 如果未检测到数据库，则会将App中${dbFilename}资源拷贝到目标目录中
 @param dbFilename 数据库文件名
 @param dbDir 数据库存放的目录
 */
- (id)initWithDb:(NSString *)dbFilename withDbFolder:(NSString *)dir
{
    self = [super init];
    if (self) {
        NSString *appDirectory = [[NSBundle mainBundle] bundlePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
      
        if(![fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@%@",dir,dbFilename]]) //如果不存在
        {
            NSString *dataPath = [appDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",dbFilename]];//获取程序包中相应文件的路径
            NSError *error;
            [fileManager copyItemAtPath:dataPath toPath:dir error:&error]; //拷贝
        }
        db= [FMDatabase databaseWithPath:dir] ;
    }
    return self;
}


/**
 @method query:resultSet:
 @abstract 根据SQL查询数据库，并将记录集回调callback block块
 */
- (NSArray *)query:(NSString *)sql resultSet:(id (^)(FMResultSet *))resultSetHandler
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSMutableArray* array = [NSMutableArray array];
    
    FMResultSet* set = [db executeQuery:sql];
    while ([set next]) {
        [array addObject:resultSetHandler(set)];
    }
    [db close];
    return array;
}

/**
 @method query:resultSet:
 @abstract 根据SQL查询数据库，并将记录集回调callback block块
 */
- (NSArray *)query:(NSString *)sql withArgumentsInArray:(NSArray *)arguments resultSet:(id (^)(FMResultSet *))resultSetHandler
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSMutableArray* array = [NSMutableArray array];
    
    FMResultSet* set = [db executeQuery:sql withArgumentsInArray:arguments];
    while ([set next]) {
        [array addObject:resultSetHandler(set)];
    }
    [db close];
    return array;
}

/**
 @method get:resultSet:
 @abstract 根据SQL查询数据库，获取单挑记录，如果没有符合条件的记录，则返回nil
 */
- (id)get:(NSString *)sql resultSet:(id (^)(FMResultSet *))resultSetHandler
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    id resultSet = nil;
    FMResultSet* set = [db executeQuery:sql];
    while ([set next]) {
      resultSet = resultSetHandler(set);
    }
    [db close];
    return resultSet;
}

/**
 @method get:resultSet:
 @abstract 根据SQL查询数据库，获取单挑记录，如果没有符合条件的记录，则返回nil
 */
- (id)get:(NSString *)sql withArgumentsInArray:(NSArray *)arguments resultSet:(id (^)(FMResultSet *))resultSetHandler
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    id resultSet = nil;
    FMResultSet* set = [db executeQuery:sql withArgumentsInArray:arguments];
    while ([set next]) {
        resultSet = resultSetHandler(set);
    }
    [db close];
    return resultSet;
}

/**
 @method executeUpdate:withArgumentsInArray:
 @abstract 执行数据更新，该方法可以执行insert/update/delete语句
 @param sql 执行SQL语句
 @param arguments SQL中的参数
 */
- (void)executeUpdate:(NSString *)sql withArgumentsInArray:(NSArray *)arguments
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    [db executeUpdate:sql withArgumentsInArray:arguments];
    [db close];
}

/**
 @method batchUpdate:
 @abstract 在一个事务中，批量执行SQL更新
 @param blocks，SQLBlock类型的数组
 */
- (void)batchUpdate:(NSArray *)blocks
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    [db beginTransaction];
    
    BOOL isRollBack = NO;
    @try {
        for (SQLBlock *sqlBlock in blocks) {
            BOOL a = [db executeUpdate:sqlBlock.sql withArgumentsInArray:sqlBlock.arguments];
            if (!a) {
                NSLog(@"更新失败1");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        [db rollback];
    }
    @finally {
        if (!isRollBack) {
            [db commit];
        }
    }
    
    [db close];
 
}

@end
