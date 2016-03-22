//
//  AsyncTask.h
//  PaixieMall
//
//  Created by zhwx on 14/12/8.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Definition for AsyncWorker

/**
 * 异步任务的具体执行者，AsyncWorker将被AsyncWorker。
 * 一个需要处理复杂的业务逻辑的类中，有可能需要执行多个异步任务，AsyncWorker的方法中通过参数what
 * 来区分当前执行的任务。
 *
 * AsyncWorker要求实现者必须实现方法：
 *  executeAsyncTask:withParam:
 *  asyncTaskCallback:result:
 *
 * 方法executeAsyncTask一般用于执行具体的业务逻辑
 */
@protocol AsyncWorker<NSObject>
@required

/**
 * 在异步线程中执行具体的业务逻辑。（线程）
 *
 * @param what 该参数是一个标记值，用于表明当前执行具体的业务逻辑，该参数将被直接传递给方法 asyncTaskCallback。
 * @param param 执行业务所需要的参数
 */
- (id)executeAsyncTask:(NSInteger)what withParam:(id)param;

/**
 * 异步任务执行结束后，将通过该方法将返回值传递给调用者 （主线程）
 *
 * @param result 执行结果，即为 【executeAsyncTask:(NSInteger)what withParam:(id)param】  方法的返回值。
 * @param what
 */
- (void)asyncTaskCallback:(NSInteger)what result:(id)result;

@optional

/**
 * 异步调用中出现异常回调。
 *
 * @param exception
 */
- (void)onAsyncException:(NSInteger)what exception:(NSException *)exception;


/**
 * 异步任务执行前 的回调
 * 执行异步操作时，显示“处理中”，参数what当前具体的操作。
 *
 */
- (void)asyncTaskWillExecute:(NSInteger)what;

/**
 * 异步任务执行结束时 的回调
 * 执行异步操作结束时，关闭“处理中”，参数what当前具体的操作。
 *
 */
- (void)asyncTaskDidExecute:(NSInteger)what;

@end


#pragma mark - Definition for AsyncTask

/**
 * AsyncTask利用iOS的机制，封装复杂的异步调用过程。
 * AsyncTask通过AsyncWorker与调用者交互。
 */
@interface AsyncTask : NSObject {
    
}

@property (weak, nonatomic) id<AsyncWorker> worker;

/**
 * 执行异步任务是方法 executeTask:withParam: 的简便形式，该方法将直接委托 executeTask:withParam:
 * 完成逻辑，并传递nil值给参数withParam。
 *
 * @param what 表明当前执行具体的业务逻辑
 */
- (void)executeTask:(NSInteger)what;

/**
 * 执行异步任务，该方法将从iOS中获得全局线程队列，并在该队列执行[AsyncWorker executeAsyncTask:withParam:]。
 * 当任务执行完毕后，该方法再在应用程序主线程队列，回调[AsyncWorker asyncTaskCallback:result:]，
 * 通知调用者处理结果。
 *
 * @param what 表明当前执行具体的业务逻辑
 * @param param
 */
- (void)executeTask:(NSInteger)what withParam:(id)param;

/**
 *  取消所有异步操作
 */
- (void)cancelAllOperations;

@end
