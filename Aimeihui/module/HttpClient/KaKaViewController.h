//
//  KaKaViewController.h
//  PaixieMall
//
//  Created by zhwx on 14/12/10.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncTask.h"
#import "Exceptions.h"
#import "RefreshTableView.h"

@interface KaKaViewController : UIViewController <AsyncWorker,RefreshTableViewDelegate> {
    
@protected
    
    AsyncTask *asyncTask;
    
    /**
     *	是否开启网络提示功能，默认为开启
     */
    BOOL o_isNetworkingValidateEnabled;
    
    BOOL o_isAdjustView;//是否已调整完几何
}

@property (nonatomic,copy) NSString * navTitle;

@property (strong, nonatomic) AsyncTask *asyncTask;

@property (strong, nonatomic) RefreshTableView * basetableView;
/**
 * 初始化控制器时，预操作。
 * 此方法在 init或awakeFromNib之后， 在view加载之前调用。
 */
- (void)controllerDidCreate;

/**
 * 加载完View，并调整完几何完调用
 * 此方法在 viewDidAppear之后，且只在初始化后调用一次。
 */
- (void)viewDidAdjust;

/**
 *  同 initWithNibName:bundle:
 *  用XIB 名称初始化，bundle 为nil
 */
- (id)initWithNibName:(NSString *)nibNameOrNil;

/**
 *  同 initWithNibName:bundle:
 *  用XIB 名称初始化，bundle 为nil
 */
- (id)initWithDefaultNibName:(Class)controllerClass;

#pragma mark - AsyncTask

/**
 * 设置AsyncTask对象
 */
- (void)setAsyncTask:(AsyncTask *)newTask;
/**
 *  取消所有异步任务
 */
- (void)cancelAllAsyncTasks;



#pragma mark - 异常处理
/**
 * 请求等待超时 异常
 */
- (void)handleRequestTimeoutException:(NSInteger)what;
/**
 * 处理登录超时异常，可以是远程服务返回的超时异常，也可以是本地系统的超时异常
 */
- (void)handleLoginTimeoutException:(NSInteger)what;

/**
 * 处理无网络异常
 */
- (void)handleNetworkingException:(NSInteger)what;

/**
 * 处理未知异常，通常为业务异常
 */
- (void)handleUnknowException:(NSInteger)what exception:(NSException *)exception;

@end
