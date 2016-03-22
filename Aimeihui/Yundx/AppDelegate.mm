//
//  AppDelegate.m
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "AppDelegate.h"
//#import "IQKeyboardManager.h"
#import <BaiduMapAPI/BMapKit.h>
#import "BPush.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "WXApi.h"
#import "CMNavBarNotificationView.h"

@interface AppDelegate ()
{
    BOOL isDebug;
}
@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
//    [IQKeyboardManager sharedManager];


#if DEBUG
    isDebug = YES;
    //[UMSocialData openLog:YES];
#endif
    
    //分享
    [self createUmeng:launchOptions];
    
    //百度推送
    [self createBaiduPush:launchOptions];
    
    //百度地图
    [self crateBaiduMap];
    
    GlobalVC * _globalVC = [GlobalVC sharedInstance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _globalVC.launchVC;
    [self.window makeKeyAndVisible];
    
    //响应推送消息
    [self handleFirstAPNSNotifyWithOptions:launchOptions];
    
    return YES;
}


//友盟分享
- (void)createUmeng:(NSDictionary *)launchOptions{
    
    /**注册友盟**/
    //【UMeng】
    [MobClick setLogEnabled:isDebug];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    [MobClick setAppVersion:[ZUtilsApplication appMajorVersion]];
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
//    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//    
//    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialWechatHandler setWXAppId:WX_APP_ID appSecret:WX_APP_SCERET url:@"http://www.umeng.com/social"];
//
    //【新浪微博】
    [UMSocialSinaHandler openSSOWithRedirectURL:WEIBO_CALLBACK_URL];

    //【QQ】
    [UMSocialQQHandler setQQWithAppId:QQ_KEY appKey:QQ_SECRET url:QQ_CALLBACK_URL];
//
//    //【设置APP下载渠道】
    [MobClick startWithAppkey:UMENG_APPKEY];
    
    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    

//
//    //【开启更新提示】
    [MobClick checkUpdate:@"运东西新版发布" cancelButtonTitle:@"取消" otherButtonTitles:@"立即安装"];

    //    //【WeiXin】
    [WXApi registerApp:WX_APP_ID];
        //设置微信AppId，url地址传nil，将默认使用友盟的网址
}

//百度推送
- (void)createBaiduPush:(NSDictionary *)launchOptions{
    
    // iOS8 下需要使用新的 API
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:BAIDU_PUSH_API_KEY pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:isDebug];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
//        [self playVoiceFromNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

//百度地图
- (void)crateBaiduMap{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_MAP_KEY  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}




- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    
    
    [self bindChannel];
    
}




/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //微信
    if ([[url absoluteString] hasPrefix:WX_APP_ID]) {
        
        //微信分享
        NSRange range = [[url absoluteString] rangeOfString:@"platformId="];
        if (range.location == NSNotFound){//不包含
        }else{
            return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
        }
    }
    return  [UMSocialSnsService handleOpenURL:url];
}
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    // 打印到日志 textView 中
////    [self.viewController addLogString:[NSString stringWithFormat:@"backgroud : %@",userInfo]];
//    completionHandler(UIBackgroundFetchResultNewData);
//    
//    NSLog(@"=========didReceiveRemoteNotification，fetchCompletionHandler=======%@",userInfo);
//}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    
    
    NSLog(@"=========didReceiveRemoteNotification=======%@",userInfo);
    
//    UIApplicationState state = [UIApplication sharedApplication].applicationState;
//    applicationHelper.o_apnsToAppStatus = state;
    
    //用户自定义操作
//    [GlobalVC sharedInstance].launchVC.o_apnsUserInfo = userInfo;
    
//    //APP 处于激活(打开)状态
//    if (state == UIApplicationStateActive){
//        NSString * title = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//        [CMNavBarNotificationView notifyWithText:[ZUtilsApplication appDisplayName]
//                                          detail:title
//                                           image:[UIImage imageNamed:@"Icon_push"]
//                                        duration:5.0
//                                   andTouchBlock:^(CMNavBarNotificationView *notificationView) {
//                                       //                                   NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
//                                       //                                   [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_For_Receive_APNS_Notify object:nil userInfo:_o_apnsUserInfo];
//                                       
//                                   } userInfo:nil];
//    } else {
//        
//    }
//    
    
    
//    [self playVoiceFromNotification:userInfo];
    
}

//- (void)playVoiceFromNotification:(NSDictionary *)userInfo{
//     NSString * title = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    
//    //语音播放
//    if ([ZUtilsString isNotEmpty:title]) {
//        LaunchViewController * lauchVC = [GlobalVC sharedInstance].launchVC;
//        [lauchVC cancleSpeakingAndPlayVoice:title];
//    }
//}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"接收本地通知啦！！！");
    [BPush showLocalNotificationAtFront:notification identifierKey:nil];
}


/**
 * 第一次响应推送消息的 回调函数
 */
- (void) handleFirstAPNSNotifyWithOptions:(NSDictionary *) launchOptions
{
    if (launchOptions) {
        NSDictionary * userInfo = (NSDictionary *)[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            
            NSLog(@"handleFirstAPNSNotifyWithOptions info:\n%@",launchOptions);
            
            //设置进入 推送消息进入APP 的状态
//            applicationHelper.o_apnsToAppStatus = UIApplicationStateBackground;
            //响应推送消息。
            //            [APService handleRemoteNotification:userInfo];
            
            //用户自定义操作
            [GlobalVC sharedInstance].launchVC.o_apnsUserInfo = userInfo;
            
        }
        
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)bindChannel{
    
    BOOL isOffPush = [[NSUserDefaults standardUserDefaults] boolForKey:UD_IS_OFF_PUSH];
    if (isOffPush) {
        [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
            
        }];
    }else{
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            
        }];
    }
}
@end
