//
//  ZUtilsFile.h
//  YiLi
//
//  Created by zhwx on 14-6-19.
//
//

#import <Foundation/Foundation.h>

@interface ZUtilsFile : NSObject

/**
 *判断文件是否存在
 */
+(BOOL) isExists:(NSString*)path;

/**
 * 获取 资源路径
 */
+(NSString *) getBundlePath;

/**
 * 获取 Documents路径
 */
+(NSString*) getDocumentsPath;

/**
 * 获取 home 根目录
 */
+(NSString*) getHomePath;

/**
 * 获取 Caches路径
 */
+(NSString*) getCachesPath;

/**
 * 获取 Library路径
 */
+(NSString*) getLibraryPath;

/**
 * 获取 Temp路径
 */
+(NSString*) getTempPath;

/**
 * 获取所有文件
 */
+(NSArray*) getAllFilesWithFolder:(NSString*)folder;

/**
 * 大文件 拷贝 ，循环读取数据
 */
+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;


/**
 * NSFileManager 拷贝
 */
+ (BOOL)copyFile2FromPath:(NSString *)fromPath toPath:(NSString *)toPath;

/**
 * 获取文件大小
 */
+(long long) getFileSizeWithPath:(NSString *)Path;


/**
 * 删除文件
 */
+(BOOL) removeFileWithPath:(NSString *)path;


/**
 * 删除 文件夹 下所有文件、文件夹
 */
+(BOOL) removeAllFileWithDirectory:(NSString*) directory;


@end
