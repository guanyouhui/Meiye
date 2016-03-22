//
//  SplashViewController.m
//  TinyShop
//
//  Created by zhwx on 14-8-26.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "LaunchViewController.h"
#import "Member.h"
#import "MemberService.h"
#import "MSWeakTimer.h"
#import "CMNavBarNotificationView.h"
//#import "YdxAddressView.h"
//#import "USArea.h"
//#import "AddressService.h"

#define MINUTE_COUNT 5

@interface LaunchViewController ()<UIAlertViewDelegate,BDSSpeechSynthesizerDelegate>
{
    MemberService *memberService;
    
    BOOL _isPaused;
    BOOL _isStart;
    
    MSWeakTimer * o_serviceTimer;
    NSInteger secondCount;
}
@property (weak, nonatomic) IBOutlet UIImageView *o_bgImageView;

//第一次 创建此控制器(即第一次启动软件)
@property (assign, nonatomic)BOOL o_isFirstLoadView;

@property (nonatomic, copy) NSString *userInput;
@property (nonatomic) NSInteger playProgress;
//@property (nonatomic, strong)BDSSpeechSynthesizer* synthesizer;
//@property (nonatomic, strong)BDSBuiltInPlayer* player;

//监听接收推送 发送通知用
@property (assign, nonatomic)BOOL o_isReceiveNewPushInfo;//接收到通知才有跳转


@end

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _o_isFirstLoadView = YES;
        
        [self addObserverForPush];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotify:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.o_bgImageView.image = [UIImage imageNamed:IPHONE5_OR_LATER?@"Default-568h":@"Default"];
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    memberService = [[MemberService alloc] init];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    __weak LaunchViewController* __mySelf = self;
    dispatch_async(kBgQueue, ^{
        [__mySelf asynAutoLogin];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setO_apnsUserInfo:(NSDictionary *)o_apnsUserInfo
{
    _o_apnsUserInfo = o_apnsUserInfo;
    
    if (_o_apnsUserInfo) {
        self.o_isReceiveNewPushInfo = YES;
    }
    //    cdf0c6d56a67af529ac2838f290d889b
}

-(void) asynAutoLogin
{
//    //网络检测
//    if (![Global sharedInstance].applicationHelper.isOnlineMode) {
//        dispatch_async(kMainQueue, ^{
//            [JoProgressHUD makeToast:@"当前网络不可用,请检查"];
//        });
//        
//        return;
//    }

    [self checkLogin];
    
    //先进入首页
    __weak LaunchViewController* __mySelf = self;
    dispatch_async(kMainQueue, ^{
        [__mySelf entryToHome];
        return ;
    });
    
}

- (void)entryToHome{
    
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [GlobalVC sharedInstance].mainTabVC;
}

-(void) asyncTaskWillExecute:(NSInteger)what
{
    
}

-(void) asyncTaskDidExecute:(NSInteger)what
{
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView == o_strongUpateAlert) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WeiXiaoDian_Appstore_URL]];
//        o_strongUpateAlert = nil;
//    }
    
}
#pragma mark- KVO 监听推送通知 和 是否进入了主页

-(void) addObserverForPush
{
    
    [self addObserver:self forKeyPath:@"o_isEntryMainTabVC"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:@"o_isEntryMainTabVC"];
    [self addObserver:self forKeyPath:@"o_isReceiveNewPushInfo"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:@"o_isReceiveNewPushInfo"];
    
    //自动登录
    [self addObserver:self forKeyPath:@"o_isAutoLogining"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:@"o_isAutoLogining"];
    
}

-(void) removeObserverForPush
{
    [self removeObserver:self forKeyPath:@"o_isEntryMainTabVC"];
    [self removeObserver:self forKeyPath:@"o_isReceiveNewPushInfo"];
    
    [self removeObserver:self forKeyPath:@"o_isAutoLogining"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"o_isReceiveNewPushInfo") {
        
        NSLog(@"changed new=%@", [change valueForKey:NSKeyValueChangeNewKey]);
        
        NSLog(@"Step2");
        if (_o_isReceiveNewPushInfo) {
            _o_isReceiveNewPushInfo = NO;
            [self postPushNotify];
        }
        
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//触发推送通知
-(void) postPushNotify
{
    
//    UIApplicationState state = [Global sharedInstance].applicationHelper.o_apnsToAppStatus;
//    
//    RemoteNotification* remote = [RemoteNotification getRemoteNotificationInfo:_o_apnsUserInfo];
    
    
    
}

//#pragma mark- service timer
///**
// * 开启 服务器时间 计算的 timer
// */
//-(void) startTimer
//{
//    [self stopTimer];
//    o_serviceTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleServiceTimer:) userInfo:nil repeats:YES dispatchQueue:kBgQueue];
//}
//
///**
// * 停止
// */
//-(void) stopTimer
//{
//    if (o_serviceTimer) {
//        [o_serviceTimer invalidate];
//        o_serviceTimer = nil;
//    }
//}

//-(void) handleServiceTimer:(MSWeakTimer*)timer
//{
//    secondCount ++ ;
//    if (secondCount % (MINUTE_COUNT * D_MINUTE) == 0) {
//        @try {
//            ApplicationHelper * applicationHelper = [Global sharedInstance].applicationHelper;
//            
//            NSMutableDictionary * requestParam = [NSMutableDictionary dictionary];
//            [requestParam setObject:@(0) forKey:@"LocationType"];
//            [requestParam setObject:@(applicationHelper.currendCoordinate.latitude) forKey:@"Latidude"];
//            [requestParam setObject:@(applicationHelper.currendCoordinate.longitude) forKey:@"Longitude"];
//            [requestParam setObjectNotNull:applicationHelper.locationCity forKey:@"CityName"];
//            [requestParam setObjectNotNull:applicationHelper.locationAddress forKey:@"Address"];
//            [self.baseService getDetailWithoutCache:URI_Test requestParam:requestParam];
//        }
//        @catch (NSException *exception) {
//            NSLog(@"%@",exception.name);
//        }
//        @finally {
//            
//        }
//        
//    }
//    
//}


-(void) dealloc
{
    
    
    [self removeObserverForPush];
}

@end
