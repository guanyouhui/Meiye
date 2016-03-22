// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "JsonHandler.h"


extern NSString * const AFAppDotNetAPIBaseURLString;
extern NSString * const AFAppDotNetTempPathURLString;


//封装的统一 成功，失败Block
typedef void(^AFSuccessDetailBlock)(BaseObject* aObject);//单个对象
typedef void(^AFSuccessListBlock)(JsonHandler* aJsonHandler);//数组（返回整个解析对象）
typedef void(^AFFailureBlock)(Erroring* error);//错误对象

@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;


#pragma mark-
/***************自定义方法*******************/

//-(void) get:(nullable NSString*)URLString
// parameters:(nullable id)parameters
//    success:(nullable AFSuccessBlock)success
//    failure:(nullable AFFailureBlock)failure
//processView:(nullable UIView*)processView;
//
//-(void) post:(nullable NSString*)URLString
//  parameters:(nullable id)parameters
//     success:(nullable AFSuccessBlock)success
//     failure:(nullable AFFailureBlock)failure
// processView:(nullable UIView*)processView;


/*********获取详情(单对象)**********/
-(void) post4Detail:(nullable NSString*)URLString
  parameters:(nullable id)parameters
       class:(nullable Class)aClass
     success:(nullable AFSuccessDetailBlock)success
     failure:(nullable AFFailureBlock)failure
 processView:(nullable UIView*)processView;

/*********获取数组对象**********/
-(void) post4List:(nullable NSString*)URLString
         parameters:(nullable id)parameters
              class:(nullable Class)aClass
            success:(nullable AFSuccessListBlock)success
            failure:(nullable AFFailureBlock)failure
        processView:(nullable UIView*)processView;

/*********获取数组对象（且含有扩展对象）**********/
-(void) post4List:(nullable NSString*)URLString
       parameters:(nullable id)parameters
            class:(nullable Class)aClass
       extraClass:(nullable Class)eClass
          success:(nullable AFSuccessListBlock)success
          failure:(nullable AFFailureBlock)failure
      processView:(nullable UIView*)processView;


@end
