//
//  ZUtilsFile.m
//  YiLi
//
//  Created by zhwx on 14-6-19.
//
//

#import "ZUtilsFile.h"

@implementation ZUtilsFile


/**
 *判断文件是否存在
 */
+(BOOL) isExists:(NSString *)path
{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

/**
 * 获取 资源路径
 */
+(NSString *) getBundlePath
{
    return [[NSBundle mainBundle] bundlePath] ;
}


/**
 * 获取 Documents路径
 */
+(NSString*) getDocumentsPath
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* pathfile = [path objectAtIndex:0];
    
//#if __has_feature(obj_arc)
//    NSMutableString* pathfile = [[NSMutableString alloc] initWithString:str];
//#else
//    NSMutableString* pathfile = [[[NSMutableString alloc] initWithString:str] autorelease];
//#endif

	return pathfile;
}

/**
 * 获取 home 根目录
 */
+(NSString*) getHomePath
{
    return NSHomeDirectory();
}


/**
 * 获取 Caches路径
 */
+(NSString*) getCachesPath
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* pathfile = [path objectAtIndex:0];

	return pathfile;
}

/**
 * 获取 Library路径
 */
+(NSString*) getLibraryPath
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString* pathfile = [path objectAtIndex:0];
    
	return pathfile;
}

/**
 * 获取 Temp路径
 */
+(NSString*) getTempPath
{
	return NSTemporaryDirectory();
}


/**
 * 获取所有文件
 */
+(NSArray*) getAllFilesWithFolder:(NSString*)folder
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    return [fileManager contentsOfDirectoryAtPath:folder error:&error];
}


+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    //每次读取数据大小
#define READ_SIZE 1000
    // 获取文件管理器
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // 创建目标文件,用于存储从源文件读取的NSData数据
    
    BOOL isSuccess = [fm createFileAtPath:toPath contents:nil attributes:nil];
    
    if (!isSuccess) {
        NSLog(@"创建目标文件失败!");
        return NO;
    }
    // 获取源文件大小
    NSDictionary *dic = [fm attributesOfItemAtPath:fromPath error:nil];
    NSNumber *file_size = [dic objectForKey:@"NSFileSize"];
    NSNumber *hadReadSize = @0;
    double leftSize = [file_size doubleValue] - [hadReadSize doubleValue];
    // 创建源文件和目标文件的句柄
    NSFileHandle *sh = [NSFileHandle fileHandleForReadingAtPath:fromPath];
    NSFileHandle *dh = [NSFileHandle fileHandleForWritingAtPath:toPath];
    NSData *tempData = nil;
    while (leftSize > 0) {
        if (leftSize < READ_SIZE) {
            tempData = [sh readDataToEndOfFile];
            [dh writeData:tempData];
            break;
        }
        else
        {
            tempData = [sh readDataOfLength:READ_SIZE];
            [dh writeData:tempData];
            leftSize -= READ_SIZE;
        }
        
    }
    
    return YES;
}

/**
 * NSFileManager 拷贝
 */
+ (BOOL)copyFile2FromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    NSFileManager *fm  = [NSFileManager defaultManager];
    
    return [fm copyItemAtPath:fromPath toPath:toPath error:nil];
}

/**
 * 获取文件大小
 */
+(long long) getFileSizeWithPath:(NSString *)Path
{
    NSFileManager *fm  = [NSFileManager defaultManager];
    
    // 取文件大小
    NSError *error = nil;
    NSDictionary* dictFile = [fm attributesOfItemAtPath:Path error:&error];
    if (error)
    {
        NSLog(@"getfilesize error: %@", error);
        return -1;
    }
    long long nFileSize = [dictFile fileSize]; //得到文件大小
    
    return nFileSize;
}

/**
 * 删除文件
 */
+(BOOL) removeFileWithPath:(NSString *)path
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

/**
 * 删除 文件夹 下所有文件、文件夹
 */
+(BOOL) removeAllFileWithDirectory:(NSString*) directory
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![fileManager fileExistsAtPath:directory isDirectory:&isDirectory]) {
        return NO;
    }
    
    NSArray* files = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    
    NSLog(@"Removing dir: %@", directory);
    
    for (NSString *file in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:file];
        NSLog(@"Removing file : %@", filePath);
        
        if ([fileManager removeItemAtPath:filePath error:&error] != YES) {
            NSInteger errCode = (error!=nil ? error.code : -1);
            NSLog(@"Removing file error: [error code:%ld], [file:%@]", (long)errCode, filePath);
        }
    }
    
    return YES;
}




@end
