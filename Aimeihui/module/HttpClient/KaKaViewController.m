//
//  KaKaViewController.m
//  PaixieMall
//
//  Created by zhwx on 14/12/10.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "KaKaViewController.h"


@interface KaKaViewController ()




@end

@implementation KaKaViewController

@synthesize asyncTask;


-(void) awakeFromNib
{
    o_isNetworkingValidateEnabled = YES;
    asyncTask = [[AsyncTask alloc] init];
    asyncTask.worker = self;
    
    if ([self respondsToSelector:@selector(controllerDidCreate)]) {
        [self controllerDidCreate];
    }
    
    [super awakeFromNib];
}

- (void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    self.navigationItem.title = navTitle;
    
    UILabel *titleLabel = (UILabel *)self.navigationItem.titleView;
    titleLabel.text = navTitle;
}

- (void)setBasetableView:(RefreshTableView *)basetableView{
    _basetableView = basetableView;
    _basetableView.refreshDelegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"segue new = %@",[[segue destinationViewController] class]);
}


-(id) init
{
    return [self initWithNibName:nil bundle:nil];
}


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        o_isNetworkingValidateEnabled = YES;
        asyncTask = [[AsyncTask alloc] init];
        asyncTask.worker = self;
        
        if ([self respondsToSelector:@selector(controllerDidCreate)]) {
            [self controllerDidCreate];
        }
        
        
    }
    return self;
}


/**
 * 初始化控制器时，预操作。
 * 此方法在 init或awakeFromNib之后， 在view加载之前调用。
 */
- (void)controllerDidCreate
{
    
    
}
/**
 * 加载完View，并调整完几何完调用
 * 此方法在 viewDidAppear之后，且只在初始化后调用一次。
 */
- (void)viewDidAdjust{
    
}

/**
 *  同 initWithNibName:bundle:
 *  用XIB 名称初始化，bundle 为nil
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nil];
}

/**
 *  同 initWithNibName:bundle:
 *  用XIB 名称初始化，bundle 为nil
 */
- (id)initWithDefaultNibName:(Class)controllerClass
{
    return [self initWithNibName:NSStringFromClass(controllerClass) bundle:nil];
}


#pragma mark - 超时字段
/**
 * 重写 超时的自定义 key 值
 */
- (NSString *)getTimeoutExceptionName {
    
    return nil;
}



#pragma mark - 状态栏进度条
/**
 * 显示状态栏加载提示视图
 */
- (void)presentProcessingIndicatorView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

/**
 * 关闭状态栏加载提示视图
 */
- (void)dismissProcessingIndicatorView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


#pragma mark- 替换AsyncTask
/**
 * 设置AsyncTask对象
 */
- (void)setAsyncTask:(AsyncTask *)newTask
{
    asyncTask = newTask;
    
}

/**
 *  取消所有异步任务
 */
- (void)cancelAllAsyncTasks
{
    asyncTask.worker = nil;
    asyncTask = nil;
}


#pragma mark- AsyncTask
/**
 * 在异步线程中执行具体的业务逻辑。
 *
 * @param what 该参数是一个标记值，用于表明当前执行具体的业务逻辑，该参数将被直接传递给方法 asyncTaskCallback。
 * @param param 执行业务所需要的参数
 */
- (id)executeAsyncTask:(NSInteger)what withParam:(id)param
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
    return nil;
}

/**
 * 异步任务执行结束后，将通过该方法将返回值传递给调用者
 *
 * @param result 执行结果
 * @param what
 */
- (void)asyncTaskCallback:(NSInteger)what result:(id)result
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}

/**
 * 异步调用中出现异常。
 *
 * @param exception
 */
- (void)onAsyncException:(NSInteger)what exception:(NSException *)exception
{
    NSLog(@"father exception:%@",exception);
    
    __weak KaKaViewController* __myself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__myself handleAllException:what exception:exception];
    });
}


/**
 * 执行异步操作时，显示“处理中”，参数what当前具体的操作。
 *
 */
- (void)asyncTaskWillExecute:(NSInteger)what
{
    if (o_isNetworkingValidateEnabled) {
        [self presentProcessingIndicatorView];
    }
}

/**
 * 执行异步操作结束时，关闭“处理中”，参数what当前具体的操作。
 *
 */
- (void)asyncTaskDidExecute:(NSInteger)what
{
    if (o_isNetworkingValidateEnabled) {
        [self dismissProcessingIndicatorView];
    }
}


#pragma mark - 异常处理

/**
 * 处理未知异常，通常为业务异常
 */
- (void)handleAllException:(NSInteger)what exception:(NSException *)exception
{
    if ([_basetableView isKindOfClass:[RefreshTableView class]]) {
        [_basetableView endRefreshing];
    }
    
    //登录超时 (业务逻辑)
    if ([exception.name isEqualToString:[self getTimeoutExceptionName]]) {
        [self handleLoginTimeoutException:what];
        
        //通讯逻辑 (无网络链接)
    }else if ([exception.name isEqualToString:NET_WORKING_NONE_EXCEPTION]) {
        [self handleNetworkingException:what];
        
        //通讯逻辑 （请求超时）
    }else if ([exception.name isEqualToString:NET_WORKING_TIMEOUT_EXCEPTION]){
        [self handleRequestTimeoutException:what];
    }else{
        //其他业务逻辑
        [self handleUnknowException:what exception:exception];
    }
}


/**
 * 处理登录超时异常，可以是远程服务返回的超时异常，也可以是本地系统的超时异常
 */
- (void)handleLoginTimeoutException:(NSInteger)what
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}

/**
 * 处理网络异常
 */
- (void)handleNetworkingException:(NSInteger)what
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}

/**
 * 处理 请求超时
 */
- (void)handleRequestTimeoutException:(NSInteger)what
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}


/**
 * 处理未知异常，通常为业务异常
 */
- (void)handleUnknowException:(NSInteger)what exception:(NSException *)exception
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}



@end
