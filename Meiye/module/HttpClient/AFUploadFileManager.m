//
//  AFUploadFileManager.m
//  WuLiuDS
//
//  Created by zhwx on 14-10-22.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import "AFUploadFileManager.h"

@interface AFUploadFileManager ()

@property (nonatomic,strong) AFHTTPRequestOperation* o_afRequestOperation;
@property (nonatomic,strong) AFJSONRequestSerializer* o_afJSONRequestSerializer;


//------------------------------------回调Block------------------------------------------------
@property (nonatomic,copy) UploadFileSuccess o_successBlock;
@property (nonatomic,copy) UploadFileFailure o_failureBlock;
@property (nonatomic,copy) UploadFileProgress o_progressBlock;




//------------------------------------填充上传参数------------------------------------------------

/**
 * 上传的URL 地址 (必须设置，非nil)
 */
@property (nonatomic,copy) NSString* o_fullUrlString;

/**
 * 上传的文件类型 (必须设置，非nil)
 */
@property (nonatomic,assign) UploadFileType o_uploadFileType;

/**
 * 以 文件路径方式上传 或 nsdata 上传
 */
@property (nonatomic,assign) UploadMethods o_uploadMethods;
/**
 * 待上传的 NSData
 */
@property (nonatomic,strong) NSData* o_willUploadData;
/**
 * 待上传的 文件路径Path
 */
@property (nonatomic,copy) NSString* o_willUploadFilePath;


/**
 * 请求接口的额外 参数  (可为nil)
 */
@property (nonatomic,strong) NSDictionary* o_requestParams;

/**
 * data 字段的 key值， name (必须设置，非nil)
 */
@property (nonatomic,copy) NSString* o_name;

/**
 * 上传需要 要设置的 文件名称 (必须设置，非nil)
 */
@property (nonatomic,copy) NSString* o_fileName;

@end


@implementation AFUploadFileManager


-(id) init
{
    if (self = [super init]) {
        self.o_afJSONRequestSerializer = [[AFJSONRequestSerializer alloc] init];
    }
    return self;
}


+(instancetype) sharedInstance
{
    static AFUploadFileManager* __uploadFileManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __uploadFileManager = [[AFUploadFileManager alloc] init];
    });
    return __uploadFileManager;
}



/**
 * -------------------------以NSData 方式上传--------------------------
 * fullUrl:上传地址url全路径
 * parameters: 额外的上传参数  【选填参数】
 * data:文件流
 *
 * keyName:data 的 键值名称
 * fileName:文件名 （http 头部用）
 * format:上传的文件类型  eg:@"image/jpeg" 等
 */
-(void) setFileDataMethodsWithFullUrl:(NSString*)fullUrl
                           parameters:(NSDictionary *)parameters
                                 data:(NSData*)data
                              keyName:(NSString*)keyName
                             fileName:(NSString*)fileName
                               format:(UploadFileType)format
{
    self.o_fullUrlString = fullUrl;
    self.o_requestParams = parameters;
    self.o_willUploadData = data;
    self.o_name = keyName;
    self.o_fileName = fileName;
    self.o_uploadFileType = format;
    
    self.o_uploadMethods = UploadMethods_FileData;
}

/**
 * -------------------------以FilePath 方式上传--------------------------
 * fullUrl:上传地址url全路径
 * parameters: 额外的上传参数  【选填参数】
 * filePath:本地待上传文件的 全路径
 *
 * keyName:data 的 键值名称
 * fileName:文件名 （http 头部用）
 * format:上传的文件类型  eg:@"image/jpeg" 等
 */
-(void) setFilePathMethodsWithFullUrl:(NSString*)fullUrl
                           parameters:(NSDictionary *)parameters
                             filePath:(NSString*)filePath
                              keyName:(NSString*)keyName
                             fileName:(NSString*)fileName
                               format:(UploadFileType)format
{
    self.o_fullUrlString = fullUrl;
    self.o_requestParams = parameters;
    self.o_willUploadFilePath = filePath;
    self.o_name = keyName;
    self.o_fileName = fileName;
    self.o_uploadFileType = format;
    
    self.o_uploadMethods = UploadMethods_FilePath;
}



-(BOOL) checkAllParams
{
    if (!self.o_name || self.o_name.length<=0 || !self.o_fileName || self.o_fileName.length<=0) {
        
        NSLog(@"o_name or o_fileName is null");
        return NO;
    }
    
    if (!self.o_fullUrlString || self.o_fullUrlString.length<=0) {
        
        NSLog(@"fullUrlString is null");
        return NO;
    }

    
    if (self.o_uploadFileType != UploadFileType_JPEG
        && self.o_uploadFileType != UploadFileType_PNG
        && self.o_uploadFileType != UploadFileType_MP3) {
        
        NSLog(@"uploadFileType error");
        return NO;
    }
    
    if (self.o_uploadMethods != UploadMethods_FileData
        && self.o_uploadMethods != UploadMethods_FilePath) {
        NSLog(@"uploadMethods error");
        return NO;
    }
    
    if (!self.o_willUploadData && !self.o_willUploadFilePath) {
        NSLog(@"UploadData  UploadFilePath all is nil");
        return NO;
    }
    
    return YES;
}

/**
 * 开启上传 操作
 */
-(void) startUpload
{
    BOOL isValid = [self checkAllParams];
    
    //验证失败
    if (!isValid) {
        return;
    }

    __weak AFUploadFileManager* __myself = self;

    
    NSMutableURLRequest *request = [self.o_afJSONRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:self.o_fullUrlString parameters:self.o_requestParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        NSString* typeString = nil;
        if (__myself.o_uploadFileType == UploadFileType_JPEG) {
            typeString = @"image/jpeg";
        }else if (__myself.o_uploadFileType == UploadFileType_MP3){
            typeString = @"audio/mpeg3";
        }else if (__myself.o_uploadFileType == UploadFileType_PNG){
            typeString = @"image/png";
        }
        
        if (__myself.o_uploadMethods == UploadMethods_FileData) {

            [formData appendPartWithFileData:__myself.o_willUploadData name:__myself.o_name fileName:__myself.o_fileName mimeType:typeString];
            
        }else if (__myself.o_uploadMethods == UploadMethods_FilePath){

            [formData appendPartWithFileURL:[NSURL fileURLWithPath:__myself.o_willUploadFilePath] name:__myself.o_name fileName:__myself.o_fileName mimeType:typeString error:nil];
        }
        
        
    } error:nil];
    
    
    self.o_afRequestOperation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
//    //设置进度条 block
//    __block AFUploadFileManager* __myself = self;
    [self.o_afRequestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        if (__myself.o_progressBlock) {
            __myself.o_progressBlock(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
        }

    }];
    
    //设置失败成功 block
    [self.o_afRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (__myself.o_successBlock) {
            __myself.o_successBlock(operation,responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (__myself.o_failureBlock) {
            __myself.o_failureBlock(operation,error);
        }
    }];
    
    [self.o_afRequestOperation start];

    
}

/**
 * 终止上传
 */
-(void) stopUpload
{
    [self.o_afRequestOperation cancel];
}


/**
 * 设置 block success failure progress
 */

-(void) setBlockWithProgress:(UploadFileProgress)progress success:(UploadFileSuccess)success failure:(UploadFileFailure)failure
{
    self.o_progressBlock = progress;
    self.o_successBlock = success;
    self.o_failureBlock = failure;
}


-(void) dealloc
{
#ifdef DEBUG
    NSLog(@"Class %@ dealloc -----!-----\n\n",[self class]);
#endif
}

@end
