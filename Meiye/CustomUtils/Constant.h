//
//  Constant.h
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#ifndef Yundx_Constant_h
#define Yundx_Constant_h

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import "ServiceUrls.h"
#import "NotifyDefine.h"
#import "UserDefaultsKeies.h"

#import "TXLib.h"
#import "ZWXLib.h"

#import "AppDelegate.h"
#import "Global.h"
#import "GlobalVC.h"
#import "TXControllerCategory.h"

#import "Http-Base-Layer.h" 
#import "SerialConstant.h"

#import "EGOImageView.h"
#import "IQKeyboardManager.h"



#define YUNDX_APP_ID @"888979399"

#define YUNDX_APP_URL @"https://itunes.apple.com/us/app/yun-dong-xi-zong-he-ban/id888979399?l=zh&ls=1&mt=8"

//百度地图
//#define BAIDU_MAP_KEY @"mMIRPRxsNLYFs0c4Q3ATMk5r"

#define BAIDU_MAP_KEY @"GsvgCuFEx4rt7UwTdHaobdew"


//百度推送
#define BAIDU_PUSH_ID_KEY @"6589122"
#define  BAIDU_PUSH_API_KEY @"GsvgCuFEx4rt7UwTdHaobdew"

//百度语音KEY
#define BAIDU_VOICE_AppID @"6589122"
#define BAIDU_VOICE_AppKey @"GsvgCuFEx4rt7UwTdHaobdew"
#define BAIDU_VOICE_SecretKey @"RGX5GclDV0ZRfUCLG9ZVhYlQwuwE3XkW"
//#define BAIDU_VOICE_AppID @"6528738"
//#define BAIDU_VOICE_AppKey @"mMIRPRxsNLYFs0c4Q3ATMk5r"
//#define BAIDU_VOICE_SecretKey @"Te4T0I1UXNyI6XFHjoicnwmvM8M6GbN3"

//友盟
#define UMENG_APPKEY @"55c96dcd67e58e777d000f1c"

//----------Sina-----------
#define WEIBO_KEY               @"sina.540ea724fd98c597e4004613"
#define WEIBO_SECRET            @"90fc23413c51d44741ffeadb98ca1a01"
#define WEIBO_CALLBACK_URL      @"http://sns.whalecloud.com/sina2/callback" //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil


//QQ
#define QQ_KEY               @"1104821032"
#define QQ_SECRET            @"95H5XBGsAjub3jCz"
#define QQ_CALLBACK_URL      SERVICE_MP_URL


//----------微信-----------
#define WX_APP_ID       @"wxe509e6c2e9139fcb"
#define WX_APP_SCERET   @"1e19ff6928fad86308e94c3ca465458c"

#endif
