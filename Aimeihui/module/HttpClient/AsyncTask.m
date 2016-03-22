//
//  AsyncTask.m
//  PaixieMall
//
//  Created by zhwx on 14/12/8.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "AsyncTask.h"

@implementation AsyncTask


/**
 * 执行异步任务是方法 executeTask:withParam: 的简便形式，该方法将直接委托 executeTask:withParam:
 * 完成逻辑，并传递nil值给参数withParam。
 *
 * @param what 表明当前执行具体的业务逻辑
 */
- (void)executeTask:(NSInteger)what
{
    [self executeTask:what withParam:nil];
}

/**
 * 执行异步任务，该方法将从iOS中获得全局线程队列，并在该队列执行[AsyncWorker executeAsyncTask:withParam:]。
 * 当任务执行完毕后，该方法再在应用程序主线程队列，回调[AsyncWorker asyncTaskCallback:result:]，
 * 通知调用者处理结果。
 *
 * @param what 表明当前执行具体的业务逻辑
 * @param param
 */
- (void)executeTask:(NSInteger)what withParam:(id)param
{
    //    id<AsyncWorker> __myworker = self.worker; // YES
    __block id<AsyncWorker> __myworker = self.worker;//YES
    //    __weak id<AsyncWorker> __myworker = self.worker;//NO
    if ([__myworker respondsToSelector:@selector(executeAsyncTask:withParam:)]) {
        
        //主线程 显示进度信息
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([__myworker respondsToSelector:@selector(asyncTaskWillExecute:)]) {
                [__myworker asyncTaskWillExecute:what];
            }
        });
        
        //线程 执行操作
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            id result = nil;
            @try {
                result = [__myworker executeAsyncTask:what withParam:param];
                //                [NSException raise:@"adf" format:@"11111111"];
            }
            @catch (NSException *exception) {
                
                NSLog(@"executeAsyncTask exception---:\n%@",exception);
                
                //主线程  【异常】  返回结果
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([__myworker respondsToSelector:@selector(asyncTaskDidExecute:)]) {
                        [__myworker asyncTaskDidExecute:what];
                    }
                    
                    if ([__myworker respondsToSelector:@selector(onAsyncException:exception:)]) {
                        [__myworker onAsyncException:what exception:exception];
                    }
                });
                return;
                
            }
            
            
            //主线程  【正常】 返回结果
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([__myworker respondsToSelector:@selector(asyncTaskDidExecute:)]) {
                    [__myworker asyncTaskDidExecute:what];
                }
                
                if ([__myworker respondsToSelector:@selector(asyncTaskCallback:result:)]) {
                    [__myworker asyncTaskCallback:what result:result];
                }
            });
        });
    }
}

/**
 *  取消所有异步操作
 */
- (void)cancelAllOperations
{
    _worker = nil;
    
}


@end
